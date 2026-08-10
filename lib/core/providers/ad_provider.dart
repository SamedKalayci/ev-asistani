import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/ad_service.dart';
import 'purchase_provider.dart';

const String _kAdFreeKey = 'isAdFree';

/// Reklamsız mod durumunu yöneten StateNotifier.
class AdFreeNotifier extends StateNotifier<bool> {
  AdFreeNotifier() : super(false) {
    _init();
  }

  Future<void> _init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localAdFree = prefs.getBool(_kAdFreeKey) ?? false;
      state = localAdFree;
      AdService.instance.setPremium(localAdFree);
    } catch (e) {
      // SharedPreferences hatası durumunda false başla
      state = false;
    }
  }

  /// Reklamsız mod durumunu kalıcı olarak günceller.
  Future<void> setAdFree(bool value) async {
    state = value;
    AdService.instance.setPremium(value);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kAdFreeKey, value);
    } catch (e) {
      // Hata yönetimi
    }
  }
}

/// Reklamsız mod durumunu dinleyen temel provider.
final isAdFreeProvider = StateNotifierProvider<AdFreeNotifier, bool>((ref) {
  final notifier = AdFreeNotifier();
  
  // Ayrıca RevenueCat müşteri bilgilerini dinle ve 'remove_ads' paketini kontrol et
  ref.listen(customerInfoProvider, (previous, next) {
    final customerInfo = next.valueOrNull;
    if (customerInfo != null) {
      final activeEntitlements = customerInfo.entitlements.all;
      final hasAdFreeEntitlement = (activeEntitlements['remove_ads']?.isActive ?? false) ||
          (activeEntitlements['pro']?.isActive ?? false) ||
          (activeEntitlements['premium']?.isActive ?? false);
      if (hasAdFreeEntitlement) {
        notifier.setAdFree(true);
      }
    }
  });

  return notifier;
});

/// Aile Boyu PRO Üyelik sağlayıcısı.
/// Tüm özellik kısıtlamalarını kaldırdığımız için ARTIK HER ZAMAN TRUE döner.
final isPremiumProvider = Provider<bool>((ref) {
  return true;
});

/// [AdService] singleton'ını sunan provider.
final adServiceProvider = Provider<AdService>((ref) {
  return AdService.instance;
});
