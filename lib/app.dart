import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ev_asistani/l10n/app_localizations.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/user_provider.dart';
import 'core/theme/app_theme.dart';
import 'router/app_router.dart';
import 'core/services/att_service.dart';
import 'core/services/ad_service.dart';

class EvAsistaniApp extends ConsumerStatefulWidget {
  const EvAsistaniApp({super.key});

  @override
  ConsumerState<EvAsistaniApp> createState() => _EvAsistaniAppState();
}

class _EvAsistaniAppState extends ConsumerState<EvAsistaniApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initAdsAndTracking();
    });
  }

  Future<void> _initAdsAndTracking() async {
    // Dialog'un güvenle gösterilebilmesi için kısa bir süre bekliyoruz
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // iOS'ta AdMob kişiselleştirme için App Tracking Transparency (ATT) iznini iste
    try {
      await ATTService.requestTrackingAuthorization();
    } catch (e) {
      debugPrint('ATT servisi başlatılırken hata: $e');
    }

    // İzin sonucu alındıktan sonra AdMob Reklam servisini başlat
    try {
      await AdService.instance.init();
    } catch (e) {
      debugPrint('AdService başlatılırken hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Uygulama açılışında anonim auth'u tetikle (sonucu beklemeye gerek yok —
    // bootstrapAuthProvider zaten auth akışını başlatıyor).
    ref.watch(bootstrapAuthProvider);

    final router = ref.watch(appRouterProvider);
    final currentLocale = ref.watch(localeProvider);
    final currentThemeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Ev Asistanı',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: currentThemeMode,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: currentLocale,
    );
  }
}
