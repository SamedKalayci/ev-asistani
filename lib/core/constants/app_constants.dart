// Uygulama genelinde sabit değerler

class AppConstants {
  AppConstants._();

  static const String appName = 'Ev Asistanı';
  static const String appVersion = '1.0.0';

  // Bildirim kanalları
  static const String notificationChannelId = 'ev_asistani_channel';
  static const String notificationChannelName = 'Ev Asistanı Bildirimleri';
  static const String notificationChannelDescription =
      'Son kullanma tarihi ve garanti hatırlatmaları';

  // Veritabanı
  static const String databaseName = 'ev_asistani.db';
  static const int databaseVersion = 1;

  // Gün eşikleri — kaç gün kaldığında uyarı verilecek
  static const int expirationWarningDays = 7;
  static const int warrantyWarningDays = 30;
}
