import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  /// Verilen kaynak için izin ister.
  ///
  /// - Kamera kaynağı: yalnızca [Permission.camera] kontrol edilir.
  /// - Galeri kaynağı: yalnızca [Permission.photos] (iOS) veya [Permission.storage]
  ///   (Android API < 33) kontrol edilir. Kamera izniyle hiçbir zaman karıştırılmaz.
  ///
  /// iOS 14+ "Sınırlı Erişim" (Limited/Özel Erişim) durumu geçerli kabul edilir.
  /// [permission_handler] bazı sürümlerde `isLimited` yerine `isRestricted` döndürebilir;
  /// bu nedenle her iki durum da galeri için geçerli kabul edilmektedir.
  static Future<PermissionStatus> requestImagePermission(ImageSource source) async {
    if (kIsWeb) return PermissionStatus.granted;

    // ── KAMERA ────────────────────────────────────────────────────────────────
    if (source == ImageSource.camera) {
      final status = await Permission.camera.status;
      if (_isCameraAllowed(status)) return status;
      return await Permission.camera.request();
    }

    // ── GALERİ ────────────────────────────────────────────────────────────────
    // iOS: Permission.photos kullanılır; Limited (Özel Erişim) geçerlidir.
    if (Platform.isIOS) {
      final status = await Permission.photos.status;
      if (_isPhotosAllowed(status)) return status;
      return await Permission.photos.request();
    }

    // Android: API 33+ için photos, daha eski sürümler için storage yedeğine geç.
    final photosStatus = await Permission.photos.status;
    if (_isPhotosAllowed(photosStatus)) return photosStatus;

    final requestedPhotos = await Permission.photos.request();
    if (_isPhotosAllowed(requestedPhotos)) return requestedPhotos;

    // Android API < 33 yedeği: Permission.storage
    final storageStatus = await Permission.storage.status;
    if (_isPhotosAllowed(storageStatus)) return storageStatus;
    return await Permission.storage.request();
  }

  /// Kamera izni için geçerli durumları döndürür.
  /// Yalnızca tam erişim (isGranted) kabul edilir.
  static bool _isCameraAllowed(PermissionStatus status) {
    return status.isGranted;
  }

  /// Fotoğraf/galeri izni için geçerli durumları döndürür.
  /// iOS 14+ "Sınırlı Erişim" (isLimited) ve bazı permission_handler sürümlerinde
  /// isRestricted olarak yansıyabilen durumlar da geçerli kabul edilir.
  static bool _isPhotosAllowed(PermissionStatus status) {
    return status.isGranted || status.isLimited;
  }
}
