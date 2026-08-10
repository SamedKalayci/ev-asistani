import 'package:flutter_dotenv/flutter_dotenv.dart';

/// `.env` dosyasından konfigürasyonları okuyan güvenli erişim sınıfı.
class EnvConfig {
  EnvConfig._();

  /// Uygulama ortamını döner (`development` veya `production`). Varsayılan: `development`.
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';

  static bool get isProduction => environment == 'production';

  // ── RevenueCat API Keys ──────────────────────────────────────────────────
  static String get revenueCatApiKeyAndroid =>
      dotenv.env['REVENUECAT_API_KEY_ANDROID'] ?? 'goog_placeholder_api_key';

  static String get revenueCatApiKeyIOS =>
      dotenv.env['REVENUECAT_API_KEY_IOS'] ?? 'appl_placeholder_api_key';

  // ── AdMob Unit IDs ───────────────────────────────────────────────────────
  
  static String get admobBannerIdAndroid =>
      dotenv.env['ADMOB_BANNER_ID_ANDROID'] ?? 'ca-app-pub-3940256099942544/6300978111';

  static String get admobBannerIdIOS =>
      dotenv.env['ADMOB_BANNER_ID_IOS'] ?? 'ca-app-pub-3940256099942544/2934735716';

  static String get admobInterstitialIdAndroid =>
      dotenv.env['ADMOB_INTERSTITIAL_ID_ANDROID'] ?? 'ca-app-pub-3940256099942544/1033173712';

  static String get admobInterstitialIdIOS =>
      dotenv.env['ADMOB_INTERSTITIAL_ID_IOS'] ?? 'ca-app-pub-3940256099942544/4411468910';

  static String get admobRewardedIdAndroid =>
      dotenv.env['ADMOB_REWARDED_ID_ANDROID'] ?? 'ca-app-pub-3940256099942544/5224354917';

  static String get admobRewardedIdIOS =>
      dotenv.env['ADMOB_REWARDED_ID_IOS'] ?? 'ca-app-pub-3940256099942544/1712485313';
}
