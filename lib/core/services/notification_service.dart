import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/expiration/models/expiration_model.dart';
import '../../features/vault/models/vault_item_model.dart';
import '../../features/warranty/models/warranty_model.dart';

/// Cihaz içi yerel bildirimleri (Local Notifications) yöneten singleton servis.
///
/// SKT (Son Kullanma Tarihi), Garanti ve Periyodik Bakım bitişleri için otomatik
/// zamanlanmış bildirimler kurar ve temizler.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  // ── Kanal Tanımları (Android) ──────────────────────────────────────────────
  static const String _expirationChannelId = 'expiration_channel';
  static const String _expirationChannelName = 'Son Kullanma Tarihi Uyarıları';
  static const String _expirationChannelDesc =
      'Son kullanma tarihi yaklaşan ürünler için zamanlanmış uyarılar.';

  static const String _warrantyChannelId = 'warranty_channel';
  static const String _warrantyChannelName = 'Garanti Bitiş Uyarıları';
  static const String _warrantyChannelDesc =
      'Garanti süresi dolmak üzere olan ürünler için zamanlanmış uyarılar.';

  static const String _maintenanceChannelId = 'maintenance_channel';
  static const String _maintenanceChannelName = 'Periyodik Bakım Uyarıları';
  static const String _maintenanceChannelDesc =
      'Yaklaşan periyodik bakımlar için zamanlanmış uyarılar.';

  // ── Gün Offset Kuralları ──────────────────────────────────────────────────
  /// SKT Bildirim Kuralları: 7, 5, 3, 2, 1 ve 0. gün (SKT Dolduğu Gün)
  static const List<int> expirationNotificationOffsets = [7, 5, 3, 2, 1, 0];

  /// Garanti Bildirim Kuralları: 30, 15, 7 ve 0. gün (Garanti Bittiği Gün)
  static const List<int> warrantyNotificationOffsets = [30, 15, 7, 0];

  /// Periyodik Bakım Bildirim Kuralları: 7, 3, 1 ve 0. gün
  static const List<int> maintenanceNotificationOffsets = [7, 3, 1, 0];

  // ── Initialisation ────────────────────────────────────────────────────────

  /// Bildirim servisini ve saat dilimlerini başlatır.
  Future<void> init() async {
    if (_isInitialized) return;

    // 1. Timezone veritabanını yükle ve yerel konumu ayarla
    tz.initializeTimeZones();
    try {
      final dynamic timezoneInfo = await FlutterTimezone.getLocalTimezone();
      final String timeZoneName = timezoneInfo is String
          ? timezoneInfo
          : (timezoneInfo?.name ?? 'UTC');
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      debugPrint('Local TimeZone belirlenirken hata oluştu: $e');
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    // 2. Android ve iOS başlatma ayarları
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Bildirime tıklandı: ${details.payload}');
      },
    );

    // 3. Android Özel Kanallarını Oluştur
    final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _expirationChannelId,
          _expirationChannelName,
          description: _expirationChannelDesc,
          importance: Importance.high,
        ),
      );
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _warrantyChannelId,
          _warrantyChannelName,
          description: _warrantyChannelDesc,
          importance: Importance.high,
        ),
      );
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _maintenanceChannelId,
          _maintenanceChannelName,
          description: _maintenanceChannelDesc,
          importance: Importance.high,
        ),
      );
    }

    _isInitialized = true;
  }

  // ── İzin Talebi ───────────────────────────────────────────────────────────

  /// Cihazdan bildirim izinlerini ister.
  Future<bool> requestPermissions() async {
    bool granted = false;

    // Android 13+ İzinleri
    final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      final notifGranted =
          await androidPlugin.requestNotificationsPermission() ?? false;
      final exactAlarmGranted =
          await androidPlugin.requestExactAlarmsPermission() ?? false;
      granted = notifGranted || exactAlarmGranted;
    }

    // iOS İzinleri
    final iosPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null) {
      final result = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      granted = result ?? false;
    }

    return granted;
  }

  // ── SKT Bildirim Zamanlama & İptal ────────────────────────────────────────

  /// SKT ürünü için kuraldaki tüm günlerde bildirimleri zamanlar.
  Future<void> scheduleExpirationNotifications(ExpirationModel item) async {
    if (item.id.isEmpty) return;

    for (final offset in expirationNotificationOffsets) {
      final scheduledDate = _calculateScheduledDate(item.expirationDate, offset);
      if (scheduledDate == null) continue;

      final notificationId = generateNotificationId(item.id, offset);
      final String title;
      final String body;

      if (offset == 0) {
        title = '⚠️ Son Kullanma Tarihi Doldu!';
        body = '${item.title} ürününün son kullanma tarihi bugün doluyor! (${item.location})';
      } else {
        title = '⏳ SKT Yaklaşıyor!';
        body = '${item.title} ürününün son kullanma tarihine $offset gün kaldı. (${item.location})';
      }

      await _scheduleNotification(
        id: notificationId,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        channelId: _expirationChannelId,
        channelName: _expirationChannelName,
        channelDescription: _expirationChannelDesc,
        payload: 'expiration:${item.id}',
      );
    }
  }

  /// SKT ürününe ait tüm zamanlanmış bildirimleri iptal eder.
  Future<void> cancelExpirationNotifications(String itemId) async {
    if (itemId.isEmpty) return;
    for (final offset in expirationNotificationOffsets) {
      final notificationId = generateNotificationId(itemId, offset);
      await _notificationsPlugin.cancel(notificationId);
    }
  }

  // ── Garanti Bildirim Zamanlama & İptal ─────────────────────────────────────

  /// Garanti ürünü için kuraldaki tüm günlerde bildirimleri zamanlar.
  Future<void> scheduleWarrantyNotifications(WarrantyModel item) async {
    if (item.id.isEmpty) return;

    for (final offset in warrantyNotificationOffsets) {
      final scheduledDate =
          _calculateScheduledDate(item.warrantyEndDate, offset);
      if (scheduledDate == null) continue;

      final notificationId = generateNotificationId(item.id, offset);
      final String title;
      final String body;

      if (offset == 0) {
        title = '⚠️ Garanti Süresi Bitti!';
        body = '${item.name} (${item.brand}) ürününün garantisi bugün doluyor!';
      } else {
        title = '🛡️ Garanti Bitişi Yaklaşıyor!';
        body = '${item.name} (${item.brand}) ürününün garantisinin bitmesine $offset gün kaldı.';
      }

      await _scheduleNotification(
        id: notificationId,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        channelId: _warrantyChannelId,
        channelName: _warrantyChannelName,
        channelDescription: _warrantyChannelDesc,
        payload: 'warranty:${item.id}',
      );
    }
  }

  /// Garanti ürününe ait tüm zamanlanmış bildirimleri iptal eder.
  Future<void> cancelWarrantyNotifications(String itemId) async {
    if (itemId.isEmpty) return;
    for (final offset in warrantyNotificationOffsets) {
      final notificationId = generateNotificationId(itemId, offset);
      await _notificationsPlugin.cancel(notificationId);
    }
  }

  // ── Periyodik Bakım Bildirimleri ─────────────────────────────────────────

  /// Bir [VaultItemModel] periyodik bakım ögesi için zamanlanmış bildirimleri kurar.
  Future<void> scheduleMaintenanceNotifications(VaultItemModel item) async {
    if (item.dueDate == null) return;

    // Önceki zamanlanmış bildirimleri temizle
    await cancelMaintenanceNotifications(item.id);

    for (final offset in maintenanceNotificationOffsets) {
      final scheduledDate = _calculateScheduledDate(item.dueDate!, offset);

      if (scheduledDate != null) {
        final notificationId = generateNotificationId('maint_${item.id}', offset);
        final bodyText = offset == 0
            ? '${item.title} için bakım günü bugün!'
            : '${item.title} periyodik bakıma $offset gün kaldı.';

        await _scheduleNotification(
          id: notificationId,
          title: '🛠️ Periyodik Bakım Hatırlatıcısı',
          body: bodyText,
          scheduledDate: scheduledDate,
          channelId: _maintenanceChannelId,
          channelName: _maintenanceChannelName,
          channelDescription: _maintenanceChannelDesc,
          payload: 'maintenance:${item.id}',
        );
      }
    }
  }

  /// Belirtilen periyodik bakım ögesinin tüm zamanlanmış bildirimlerini iptal eder.
  Future<void> cancelMaintenanceNotifications(String itemId) async {
    for (final offset in maintenanceNotificationOffsets) {
      final notificationId = generateNotificationId('maint_$itemId', offset);
      await _notificationsPlugin.cancel(notificationId);
    }
  }

  // ── Genel İptal Yardımcıları ──────────────────────────────────────────────

  /// Belirli bir ID'ye sahip tek bir bildirimi iptal eder.
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// Cihazdaki tüm zamanlanmış bildirimleri iptal eder.
  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }

  // ── ID & Tarih Yardımcıları ───────────────────────────────────────────────

  /// Bir ürün ID'si ve offset günü için benzersiz (unique), 31-bit pozitif integer ID türetir.
  static int generateNotificationId(String itemId, int offsetInDays) {
    final hash = itemId.hashCode ^ (offsetInDays * 10007);
    return hash.abs() % 0x7FFFFFFF;
  }

  /// Hedef tarihten [offsetDays] kadar önceki günün saat 09:00'unu zamanlama tarihi olarak hesaplar.
  /// Eğer hesaplanan tarih geçmişte kalmışsa `null` döner.
  tz.TZDateTime? _calculateScheduledDate(DateTime targetDate, int offsetDays) {
    final targetDay = targetDate.subtract(Duration(days: offsetDays));
    final scheduledDate = tz.TZDateTime(
      tz.local,
      targetDay.year,
      targetDay.month,
      targetDay.day,
      9, // Sabah 09:00'da bildirim gönder
      0,
    );

    final now = tz.TZDateTime.now(tz.local);
    if (scheduledDate.isBefore(now)) {
      return null; // Geçmiş tarihe bildirim kurulmaz
    }
    return scheduledDate;
  }

  /// İç metod: Zamanlanmış bildirimi kuar.
  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required String channelId,
    required String channelName,
    required String channelDescription,
    String? payload,
  }) async {
    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: channelDescription,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Bildirim zamanlanırken hata ($id): $e');
    }
  }
}
