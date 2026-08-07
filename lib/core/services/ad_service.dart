import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/env_config.dart';

/// Google Mobile Ads (AdMob) ve Freemium altyapısını yöneten singleton servis.
///
/// Interstitial (Geçiş) ve Rewarded (Ödüllü) reklam yükleme,
/// frekans sınırlama (Frequency Capping) ve `isPremium` kontrolü sağlar.
class AdService {
  AdService._();
  static final AdService instance = AdService._();

  bool _isInitialized = false;

  /// Freemium kontrol bayrağı (Varsayılan: false).
  /// [isPremium] true ise Interstitial reklamlar gösterilmez.
  bool isPremium = false;

  void setPremium(bool value) => isPremium = value;

  InterstitialAd? _preloadedInterstitialAd;
  bool _isInterstitialLoading = false;

  RewardedAd? _preloadedRewardedAd;
  bool _isRewardedLoading = false;


  // ── Ad Unit ID'leri ──────────────────────────────────────────────────────

  static String get interstitialAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) {
      return EnvConfig.admobInterstitialIdAndroid;
    } else if (Platform.isIOS) {
      return EnvConfig.admobInterstitialIdIOS;
    }
    return '';
  }

  static String get rewardedAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) {
      return EnvConfig.admobRewardedIdAndroid;
    } else if (Platform.isIOS) {
      return EnvConfig.admobRewardedIdIOS;
    }
    return '';
  }

  // ── Başlatma ──────────────────────────────────────────────────────────────

  /// AdMob SDK'sını başlatır (Web ortamında çalıştırmaz).
  Future<void> init() async {
    if (kIsWeb || _isInitialized) return;
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      debugPrint('AdMob SDK başarıyla başlatıldı.');
      if (!isPremium) {
        preloadInterstitialAd();
        preloadRewardedAd();
      }
    } catch (e) {
      debugPrint('AdMob SDK başlatılırken hata: $e');
    }
  }


  // ── Geçiş Reklamı (Interstitial) Ön Yükleme ve Gösterim ──────────────────

  /// Geçiş reklamını arka planda sessizce yükler.
  void preloadInterstitialAd() {
    if (kIsWeb || isPremium || _isInterstitialLoading || _preloadedInterstitialAd != null) return;
    _isInterstitialLoading = true;
    
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _preloadedInterstitialAd = ad;
          _isInterstitialLoading = false;
          debugPrint('Interstitial ad preloaded.');
        },
        onAdFailedToLoad: (error) {
          _isInterstitialLoading = false;
          debugPrint('Interstitial preloading failed: $error');
        },
      ),
    );
  }

  /// Önceden yüklenmiş reklamı gösterir ve hemen yenisini yüklemeye başlar.
  Future<void> showInterstitialAd() async {
    if (kIsWeb || isPremium) return;
    if (_preloadedInterstitialAd != null) {
      final ad = _preloadedInterstitialAd!;
      _preloadedInterstitialAd = null; // Gösterilmeden önce temizle
      
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          preloadInterstitialAd(); // Sonraki için yükle
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          preloadInterstitialAd(); // Sonraki için yükle
        },
      );
      await ad.show();
    } else {
      debugPrint('Ad not ready, skipping without interrupting UX.');
      preloadInterstitialAd(); // Hazır değilse şimdiden yüklemeyi dene
    }
  }

  final Map<String, int> _sessionFeatureCounts = {};

  /// Belirtilen [featureKey] için sayacı hafızada (in-memory / oturum bazlı) 1 artırır.
  /// Uygulama kapandığında / yeniden başlatıldığında sayaçlar sıfırlanıp başa sarar.
  /// [interval] değerine ulaşıldığında (veya [triggerFirst] true olup 1. elemana ulaşıldığında)
  /// Geçiş Reklamını (InterstitialAd) tetikler ve sayacı sıfırlar.
  Future<void> handleSessionFeatureAdTrigger(
    String featureKey,
    int interval, {
    bool triggerFirst = false,
  }) async {
    if (kIsWeb || isPremium) return;

    try {
      final currentCount = (_sessionFeatureCounts[featureKey] ?? 0) + 1;
      _sessionFeatureCounts[featureKey] = currentCount;

      if (triggerFirst) {
        if (currentCount % interval == 1) {
          await showInterstitialAd();
        }
      } else {
        if (currentCount % interval == 0) {
          await showInterstitialAd();
        }
      }
    } catch (e) {
      debugPrint('Session ad trigger error: $e');
    }
  }

  /// Belirtilen [featureKey] (örn: 'expiration_add_count') için reklam eşiklerini kontrol eder.
  /// Her gün ilk işlemde sayaçları sıfırlar. [thresholds] değerlerinden birine ulaşılırsa reklam gösterir.
  Future<void> handleFeatureAdTrigger(String featureKey, List<int> thresholds) async {
    if (kIsWeb || isPremium) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final todayStr = _getTodayDateString();
      final lastResetDate = prefs.getString('last_ad_reset_date') ?? '';
      
      if (lastResetDate != todayStr) {
        // Gün değiştiyse sayaçları sıfırla
        await prefs.setInt('expiration_add_count', 0);
        await prefs.setInt('warranty_add_count', 0);
        await prefs.setInt('shopping_add_count', 0);
        await prefs.setString('last_ad_reset_date', todayStr);
      }
      
      final currentCount = (prefs.getInt(featureKey) ?? 0) + 1;
      await prefs.setInt(featureKey, currentCount);
      
      if (thresholds.contains(currentCount)) {
        await showInterstitialAd();
      }
    } catch (e) {
      debugPrint('Ad trigger error: $e');
    }
  }

  // ── Ödüllü Reklam (Rewarded Ad) ──────────────────────────────────────────

  /// Ödüllü reklamı arka planda sessizce yükler.
  void preloadRewardedAd() {
    if (kIsWeb || isPremium || _isRewardedLoading || _preloadedRewardedAd != null) return;
    _isRewardedLoading = true;
    
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _preloadedRewardedAd = ad;
          _isRewardedLoading = false;
          debugPrint('Rewarded ad preloaded.');
        },
        onAdFailedToLoad: (error) {
          _isRewardedLoading = false;
          debugPrint('Rewarded ad preloading failed: $error');
        },
      ),
    );
  }

  /// Ödüllü reklam gösterir. (Önceden yüklenmiş reklamı kullanır)
  Future<void> showRewardedAd({
    required VoidCallback onRewardEarned,
    VoidCallback? onAdFailed,
  }) async {
    if (kIsWeb) {
      onRewardEarned();
      return;
    }

    if (_preloadedRewardedAd != null) {
      bool rewardEarned = false;
      final ad = _preloadedRewardedAd!;
      _preloadedRewardedAd = null;

      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          if (!rewardEarned) {
            onAdFailed?.call();
          }
          preloadRewardedAd(); // Yenisini yükle
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          onAdFailed?.call();
          preloadRewardedAd(); // Yenisini yükle
        },
      );

      ad.show(
        onUserEarnedReward: (adWithoutView, reward) {
          debugPrint('Kullanıcı ödüllü reklamı tamamladı: ${reward.amount}');
          rewardEarned = true;
          onRewardEarned();
        },
      );
    } else {
      debugPrint('Ödüllü reklam hazır değil.');
      onAdFailed?.call();
      preloadRewardedAd(); // Hazır değilse yüklemeyi dene
    }
  }

  // ── Yardımcı ─────────────────────────────────────────────────────────────

  String _getTodayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
