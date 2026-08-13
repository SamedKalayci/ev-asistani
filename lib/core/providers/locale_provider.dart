import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kLocaleKey = 'selected_locale_code';

/// Uygulama genelinde dil tercihini yöneten provider.
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('tr')) {
    _initLocale();
  }

  /// Desteklenen tüm dillerin listesi.
  /// İleride Almanca (de), İspanyolca (es), Fransızca (fr), Azerice (az) ve Yunanca (el)
  /// kolayca eklenebilecek şekilde altyapı kurulmuştur.
  static const List<String> supportedLanguages = ['tr', 'en', 'de', 'es', 'fr', 'az', 'el', 'pt'];

  Future<void> _initLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_kLocaleKey);
      
      if (savedCode != null && supportedLanguages.contains(savedCode)) {
        state = Locale(savedCode);
      } else {
        // Cihaz dilini tespit et (Örn: 'tr_TR', 'en_US', 'de-DE' vb. için sadece dil kodunu al)
        final rawLocale = PlatformDispatcher.instance.locale;
        final deviceLanguageCode = rawLocale.languageCode.toLowerCase().split('_').first.split('-').first;
        
        if (supportedLanguages.contains(deviceLanguageCode)) {
          state = Locale(deviceLanguageCode);
        } else {
          state = const Locale('en'); // Desteklenmeyen diller için varsayılan İngilizce
        }
      }
    } catch (e) {
      // Hata durumunda varsayılan olarak Türkçe başlat
      state = const Locale('tr');
    }
  }

  /// Dil tercihini günceller ve kalıcı olarak kaydeder.
  Future<void> setLocale(String languageCode) async {
    if (supportedLanguages.contains(languageCode)) {
      state = Locale(languageCode);
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_kLocaleKey, languageCode);
      } catch (e) {
        // Log or handle shared preferences error
      }
    }
  }
}
