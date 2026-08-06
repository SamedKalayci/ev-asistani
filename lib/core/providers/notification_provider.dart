import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';

/// [NotificationService] singleton erişimini sağlayan Riverpod Provider'ı.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});
