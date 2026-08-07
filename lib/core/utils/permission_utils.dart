import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  /// Verilen kaynak için izin ister. 
  /// Eğer izin verilmiş veya sınırlı olarak verilmişse (isGranted veya isLimited) doğrudan statüyü döner.
  static Future<PermissionStatus> requestImagePermission(ImageSource source) async {
    if (kIsWeb) return PermissionStatus.granted;

    PermissionStatus status;
    if (source == ImageSource.camera) {
      status = await Permission.camera.status;
      if (status.isGranted || status.isLimited) return status;
      status = await Permission.camera.request();
    } else {
      status = await Permission.photos.status;
      if (status.isGranted || status.isLimited) return status;
      
      status = await Permission.photos.request();
      
      // Android'de API 33 öncesi photos izni reddedilirse/yok sayılırsa storage yedeğine geç
      if (Platform.isAndroid && !status.isGranted && !status.isLimited) {
        final storageStatus = await Permission.storage.status;
        if (storageStatus.isGranted || storageStatus.isLimited) return storageStatus;
        status = await Permission.storage.request();
      }
    }

    return status;
  }
}
