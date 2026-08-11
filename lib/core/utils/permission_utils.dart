import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  /// Verilen kaynak için izin ister ve sonucu döndürür.
  ///
  /// Mantık:
  ///   1. granted / limited → direkt izinli say, devam et.
  ///   2. notDetermined      → request() çağır; sistem diyaloğu gösterir.
  ///   3. denied (iOS)       → permanentlyDenied gibi davran (sistem tekrar sormaz).
  ///   4. Android galeri      → Android Photo Picker / SAF izinsiz çalıştığı için sorunsuz devam et.
  static Future<PermissionStatus> requestImagePermission(ImageSource source) async {
    if (kIsWeb) return PermissionStatus.granted;

    // ── KAMERA ────────────────────────────────────────────────────────────────
    if (source == ImageSource.camera) {
      return _requestSingle(Permission.camera, isPhotos: false);
    }

    // ── GALERİ ────────────────────────────────────────────────────────────────
    if (Platform.isAndroid) {
      // Android: API 33+ Photo Picker ve SAF (Storage Access Framework)
      // runtime storage izni gerektirmeden ImagePicker çalıştığı için erişime izin ver.
      final photosStatus = await Permission.photos.status;
      if (_isAllowed(photosStatus, isPhotos: true)) return photosStatus;
      final storageStatus = await Permission.storage.status;
      if (_isAllowed(storageStatus, isPhotos: true)) return storageStatus;

      // İzin henüz istenmemişse bir kez sor (notDetermined durumunda)
      if (!photosStatus.isPermanentlyDenied && !storageStatus.isPermanentlyDenied) {
        final req = await Permission.photos.request();
        if (_isAllowed(req, isPhotos: true)) return req;
      }
      return PermissionStatus.granted;
    }

    // iOS: Permission.photos kullanılır; Limited (Özel Erişim) geçerlidir.
    if (Platform.isIOS) {
      return _requestSingle(Permission.photos, isPhotos: true);
    }

    return PermissionStatus.granted;
  }

  /// Tek bir [Permission] için doğru sırayla izin ister:
  static Future<PermissionStatus> _requestSingle(
    Permission permission, {
    required bool isPhotos,
  }) async {
    final status = await permission.status;

    // Zaten izinliyse request() çağırmadan dön
    if (_isAllowed(status, isPhotos: isPhotos)) return status;

    // Kalıcı red veya sistem kısıtlaması → ayarlara git gerekiyor
    if (status.isPermanentlyDenied || status.isRestricted) return status;

    // notDetermined veya denied → request() çağır
    final requested = await permission.request();

    // iOS'ta 'denied' durumunda request() tekrar 'denied' döndürür;
    if (Platform.isIOS && requested.isDenied) {
      return PermissionStatus.permanentlyDenied;
    }

    return requested;
  }

  /// İzin durumunun "geçerli" (devam edilebilir) olup olmadığını döndürür.
  static bool _isAllowed(PermissionStatus status, {required bool isPhotos}) {
    if (isPhotos) {
      return status.isGranted || status.isLimited;
    }
    return status.isGranted;
  }

  static bool isPhotosAllowed(PermissionStatus status) =>
      status.isGranted || status.isLimited;
}
