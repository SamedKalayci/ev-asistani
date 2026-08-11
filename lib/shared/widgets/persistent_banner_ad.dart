import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/providers/ad_provider.dart';
import '../../core/services/ad_service.dart';

/// Ekranların en altında sabit duran persistent AdMob Banner reklamı.
/// Kullanıcı reklamları kaldırdığında (isAdFree == true) veya web ortamındaysa kendini gizler.
class PersistentBannerAdWidget extends ConsumerStatefulWidget {
  const PersistentBannerAdWidget({super.key});

  @override
  ConsumerState<PersistentBannerAdWidget> createState() => _PersistentBannerAdWidgetState();
}

class _PersistentBannerAdWidgetState extends ConsumerState<PersistentBannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    if (kIsWeb) return;

    // Reklamsız satın alınmışsa yükleme
    final isAdFree = ref.read(isAdFreeProvider);
    if (isAdFree) return;

    final unitId = AdService.bannerAdUnitId;
    if (unitId.isEmpty) return;

    _bannerAd = BannerAd(
      adUnitId: unitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isAdLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('PersistentBannerAd failed to load: $error');
          ad.dispose();
          _bannerAd = null;
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Web'de veya reklamlar kaldırılmışsa alanı sıfırla (shrink)
    if (kIsWeb) return const SizedBox.shrink();

    final isAdFree = ref.watch(isAdFreeProvider);
    if (isAdFree) {
      return const SizedBox.shrink();
    }

    // 2. Reklam yüklenmediyse veya yüklenme aşamasındaysa boş alan dön
    if (!_isAdLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    // 3. Reklam alanını şık ve dikeyde dikey çakışma olmadan göster
    return Container(
      width: double.infinity,
      height: _bannerAd!.size.height.toDouble(),
      alignment: Alignment.center,
      color: theme.colorScheme.surfaceContainerLow,
      child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
