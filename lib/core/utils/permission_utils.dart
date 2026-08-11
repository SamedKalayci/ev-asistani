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
  ///   3. denied             → iOS'ta tekrar sormak mümkün değil; permanentlyDenied gibi davran.
  ///   4. permanentlyDenied / restricted → openAppSettings gerekir.
  ///
  /// - Kamera kaynağı: yalnızca [Permission.camera] kontrol edilir.
  /// - Galeri kaynağı: yalnızca [Permission.photos] (iOS) veya [Permission.storage]
  ///   (Android API < 33) kontrol edilir.
  ///
  /// iOS 14+ "Sınırlı Erişim" (Limited/Özel Erişim) durumu geçerli kabul edilir.
  static Future<PermissionStatus> requestImagePermission(ImageSource source) async {
    if (kIsWeb) return PermissionStatus.granted;

    // ── KAMERA ────────────────────────────────────────────────────────────────
    if (source == ImageSource.camera) {
      return _requestSingle(Permission.camera, isPhotos: false);
    }

    // ── GALERİ ────────────────────────────────────────────────────────────────
    // iOS: Permission.photos kullanılır; Limited (Özel Erişim) geçerlidir.
    if (Platform.isIOS) {
      return _requestSingle(Permission.photos, isPhotos: true);
    }

    // Android: API 33+ için photos, daha eski sürümler için storage yedeğine geç.
    final requestedPhotos = await _requestSingle(Permission.photos, isPhotos: true);
    if (_isAllowed(requestedPhotos, isPhotos: true)) return requestedPhotos;

    // Android API < 33 yedeği: Permission.storage
    return _requestSingle(Permission.storage, isPhotos: true);
  }

  /// Tek bir [Permission] için doğru sırayla izin ister:
  ///   notDetermined → request()
  ///   denied (iOS) → direkt permanentlyDenied döndür (sistem bir daha sormaz)
  ///   granted / limited → olduğu gibi döndür
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
    // bu, kullanıcının bir kez "İzin Verme" dediği anlamına gelir.
    // iOS sistemi bir daha sormayacaktır → permanentlyDenied gibi davran.
    if (Platform.isIOS && requested.isDenied) {
      return PermissionStatus.permanentlyDenied;
    }

    return requested;
  }

  /// İzin durumunun "geçerli" (devam edilebilir) olup olmadığını döndürür.
  static bool _isAllowed(PermissionStatus status, {required bool isPhotos}) {
    if (isPhotos) {
      // Galeri: granted ve limited (Özel Erişim) her ikisi de geçerlidir.
      return status.isGranted || status.isLimited;
    }
    // Kamera: yalnızca tam erişim
    return status.isGranted;
  }

  // ── Geriye dönük uyumluluk için tutuldu ──────────────────────────────────
  /// @deprecated Lütfen `_isAllowed` kullanın.
  static bool isPhotosAllowed(PermissionStatus status) =>
      status.isGranted || status.isLimited;
}
