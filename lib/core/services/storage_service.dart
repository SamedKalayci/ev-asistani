import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Firebase Storage ile dosya ve görsel yükleme işlemlerini merkezileştiren servis.
class StorageService {
  StorageService(this._storage);

  final FirebaseStorage _storage;

  /// Dosya uzantısına göre SettableMetadata (MIME Content-Type) oluşturur.
  SettableMetadata _getMetadata(String fileName) {
    final ext = fileName.toLowerCase().split('.').last;
    String contentType = 'application/octet-stream';

    switch (ext) {
      case 'pdf':
        contentType = 'application/pdf';
        break;
      case 'jpg':
      case 'jpeg':
        contentType = 'image/jpeg';
        break;
      case 'png':
        contentType = 'image/png';
        break;
      case 'webp':
        contentType = 'image/webp';
        break;
      case 'doc':
      case 'docx':
        contentType = 'application/msword';
        break;
      case 'xls':
      case 'xlsx':
        contentType = 'application/vnd.ms-excel';
        break;
      case 'txt':
        contentType = 'text/plain';
        break;
    }

    return SettableMetadata(contentType: contentType);
  }

  /// Vault dökümanını / görselini Firebase Storage'a yükler ve indirme bağlantısını (`downloadURL`) döner.
  ///
  /// Dosya `families/{familyId}/vault/{docId}_{fileName}` yoluna kaydedilir.
  Future<String> uploadVaultDocument({
    required String familyId,
    required String docId,
    required String fileName,
    File? file,
    Uint8List? bytes,
  }) async {
    try {
      if (familyId.trim().isEmpty) throw Exception('Geçersiz Family ID');
      if (docId.trim().isEmpty) throw Exception('Geçersiz Document ID');
      
      final ref = _storage.ref().child('families/$familyId/vault/${docId}_$fileName');
      final metadata = _getMetadata(fileName);

      if (kIsWeb) {
        if (bytes == null) {
          throw ArgumentError('Web platformunda dosya yükleme için bytes parametresi zorunludur.');
        }
        await ref.putData(bytes, metadata).whenComplete(() {});
      } else {
        if (file == null && bytes == null) {
          throw ArgumentError('Mobil platformda file veya bytes parametresi zorunludur.');
        }
        if (file != null) {
          if (!await file.exists()) {
            throw Exception('Yüklenecek dosya cihazda bulunamadı veya erişilemiyor.');
          }
          await ref.putFile(file, metadata).whenComplete(() {});
        } else {
          await ref.putData(bytes!, metadata).whenComplete(() {});
        }
      }
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception('Depolama hatası: ${e.message ?? 'Dosya yüklenemedi.'}');
    } catch (e) {
      throw Exception('Beklenmeyen hata: $e');
    }
  }

  /// Garanti fatura/belgesini Firebase Storage'a yükler ve indirme bağlantısını döner.
  ///
  /// Dosya `families/{familyId}/warranty/{docId}_{fileName}` yoluna kaydedilir.
  Future<String> uploadWarrantyDocument({
    required String familyId,
    required String docId,
    required String fileName,
    File? file,
    Uint8List? bytes,
  }) async {
    try {
      if (familyId.trim().isEmpty) throw Exception('Geçersiz Family ID');
      if (docId.trim().isEmpty) throw Exception('Geçersiz Document ID');

      final ref = _storage.ref().child('families/$familyId/warranty/${docId}_$fileName');
      final metadata = _getMetadata(fileName);

      if (kIsWeb) {
        if (bytes == null) {
          throw ArgumentError('Web platformunda dosya yükleme için bytes parametresi zorunludur.');
        }
        await ref.putData(bytes, metadata).whenComplete(() {});
      } else {
        if (file == null && bytes == null) {
          throw ArgumentError('Mobil platformda file veya bytes parametresi zorunludur.');
        }
        if (file != null) {
          if (!await file.exists()) {
            throw Exception('Yüklenecek dosya cihazda bulunamadı veya erişilemiyor.');
          }
          await ref.putFile(file, metadata).whenComplete(() {});
        } else {
          await ref.putData(bytes!, metadata).whenComplete(() {});
        }
      }
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception('Depolama hatası: ${e.message ?? 'Garanti belgesi yüklenemedi.'}');
    } catch (e) {
      throw Exception('Beklenmeyen hata: $e');
    }
  }

  /// Son kullanma tarihi ürün görselini Firebase Storage'a yükler ve indirme bağlantısını döner.
  ///
  /// Dosya `families/{familyId}/expiration/{docId}_{fileName}` yoluna kaydedilir.
  Future<String> uploadExpirationImage({
    required String familyId,
    required String docId,
    required String fileName,
    File? file,
    Uint8List? bytes,
  }) async {
    try {
      if (familyId.trim().isEmpty) throw Exception('Geçersiz Family ID');
      if (docId.trim().isEmpty) throw Exception('Geçersiz Document ID');

      final ref = _storage.ref().child('families/$familyId/expiration/${docId}_$fileName');
      final metadata = _getMetadata(fileName);

      if (kIsWeb) {
        if (bytes == null) {
          throw ArgumentError('Web platformunda resim yükleme için bytes parametresi zorunludur.');
        }
        await ref.putData(bytes, metadata).whenComplete(() {});
      } else {
        if (file == null && bytes == null) {
          throw ArgumentError('Mobil platformda file veya bytes parametresi zorunludur.');
        }
        if (file != null) {
          if (!await file.exists()) {
            throw Exception('Yüklenecek resim cihazda bulunamadı veya erişilemiyor.');
          }
          await ref.putFile(file, metadata).whenComplete(() {});
        } else {
          await ref.putData(bytes!, metadata).whenComplete(() {});
        }
      }
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception('Depolama hatası: ${e.message ?? 'Ürün görseli yüklenemedi.'}');
    } catch (e) {
      throw Exception('Beklenmeyen hata: $e');
    }
  }

  /// Kullanıcı profil resmini Firebase Storage'a yükler ve indirme bağlantısını (`downloadURL`) döner.
  ///
  /// Görsel `users/{userId}/avatar.jpg` yoluna kaydedilir.
  Future<String> uploadProfileImage({
    required String userId,
    File? imageFile,
    Uint8List? bytes,
  }) async {
    try {
      if (userId.trim().isEmpty) throw Exception('Geçersiz User ID');

      final ref = _storage.ref().child('users/$userId/avatar.jpg');
      final metadata = _getMetadata('avatar.jpg');
      
      if (kIsWeb) {
        if (bytes == null) {
          throw ArgumentError('Web platformunda resim yükleme için bytes parametresi zorunludur.');
        }
        await ref.putData(bytes, metadata).whenComplete(() {});
      } else {
        if (imageFile == null && bytes == null) {
          throw ArgumentError('Mobil platformda imageFile veya bytes parametresi zorunludur.');
        }
        if (imageFile != null) {
          if (!await imageFile.exists()) {
            throw Exception('Yüklenecek resim cihazda bulunamadı veya erişilemiyor.');
          }
          await ref.putFile(imageFile, metadata).whenComplete(() {});
        } else {
          await ref.putData(bytes!, metadata).whenComplete(() {});
        }
      }
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception('Depolama hatası: ${e.message ?? 'Resim yüklenemedi.'}');
    } catch (e) {
      throw Exception('Beklenmeyen hata: $e');
    }
  }
}
