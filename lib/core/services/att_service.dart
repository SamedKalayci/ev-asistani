import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';

class ATTService {
  /// App Tracking Transparency (ATT) iznini ister.
  /// Özellikle iOS platformunda AdMob reklamlarının kişiselleştirilebilmesi için gereklidir.
  /// Bu fonksiyonu uygulama başlarken (örneğin SplashScreen sonrası veya ana ekranda) çağırabilirsiniz.
  static Future<void> requestTrackingAuthorization() async {
    // Sadece iOS platformunda çalışır
    if (!Platform.isIOS) return;

    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      
      // Eğer henüz izin istenmediyse (notDetermined)
      if (status == TrackingStatus.notDetermined) {
        // İzni göster
        final newStatus = await AppTrackingTransparency.requestTrackingAuthorization();
        debugPrint('ATT Permission Status: $newStatus');
      } else {
        debugPrint('ATT Permission Already Requested: $status');
      }
    } catch (e) {
      debugPrint('ATT Permission Error: $e');
    }
  }
}
