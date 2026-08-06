import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/firestore_service.dart';
import '../models/expiration_model.dart';

/// Son kullanma tarihi ürünlerinin Firestore CRUD ve real-time stream
/// işlemlerini yöneten repository.
///
/// Tüm sorguların `familyId` parametresi, çağıran provider tarafından
/// `activeFamilyIdProvider`'dan okunarak sağlanır. Repository iş katmanı
/// olup provider detaylarından habersizdir.
class ExpirationRepository {
  ExpirationRepository(this._firestoreService);

  final FirestoreService _firestoreService;

  // ── Private Yardımcı ─────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> _col(String familyId) =>
      _firestoreService.expiryItemsRef(familyId);

  // ── Stream / Real-time ────────────────────────────────────────────────────

  /// [familyId]'e ait tüm son kullanma ürünlerini gerçek zamanlı dinler.
  ///
  /// Sonuçlar son kullanma tarihine göre artan sırada döner.
  Stream<List<ExpirationModel>> watchItems(String familyId) {
    if (familyId.isEmpty) return Stream.value([]);
    return _col(familyId)
        .orderBy('expirationDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExpirationModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Tek bir ürünü gerçek zamanlı dinler.
  Stream<ExpirationModel?> watchItem(String familyId, String itemId) {
    return _col(familyId).doc(itemId).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return null;
      return ExpirationModel.fromMap(snapshot.data()!, snapshot.id);
    });
  }

  // ── Tek Seferlik Okuma ────────────────────────────────────────────────────

  /// Tüm ürünleri tek seferlik okur (bildirim zamanlaması vb. için).
  Future<List<ExpirationModel>> fetchItems(String familyId) async {
    final snapshot =
        await _col(familyId).orderBy('expirationDate').get();
    return snapshot.docs
        .map((doc) => ExpirationModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  // ── Yazma İşlemleri ───────────────────────────────────────────────────────

  /// Yeni ürün ekler ve oluşturulan Firestore döküman ID'sini döner.
  Future<String> addItem(ExpirationModel item) async {
    final data = item.toMap();
    // createdAt henüz belirlenmemiş — sunucu timestamp kullanacağız
    data['createdAt'] = FieldValue.serverTimestamp();
    final ref = await _col(item.familyId).add(data);
    return ref.id;
  }

  /// Var olan ürünü günceller.
  ///
  /// Yalnızca değişen alanları (`title`, `location`, `expirationDate`,
  /// `iconCodePoint`, `notes`, `updatedAt`) günceller; `createdBy` ve
  /// `createdAt` dokunulmaz.
  Future<void> updateItem(ExpirationModel item) {
    final data = {
      'title': item.title,
      'location': item.location,
      'expirationDate': Timestamp.fromDate(item.expirationDate),
      'iconCodePoint': item.icon.codePoint,
      'notes': item.notes,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    return _col(item.familyId).doc(item.id).update(data);
  }

  /// Ürünü Firestore'dan siler.
  Future<void> deleteItem(String familyId, String itemId) =>
      _col(familyId).doc(itemId).delete();
}
