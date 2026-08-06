import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/firestore_service.dart';
import '../models/warranty_model.dart';

/// Garanti kaydı CRUD ve real-time stream işlemlerini yöneten repository.
class WarrantyRepository {
  WarrantyRepository(this._firestoreService);

  final FirestoreService _firestoreService;

  CollectionReference<Map<String, dynamic>> _col(String familyId) =>
      _firestoreService.warrantyItemsRef(familyId);

  // ── Stream / Real-time ────────────────────────────────────────────────────

  /// [familyId]'e ait garanti kayıtlarını gerçek zamanlı dinler.
  ///
  /// Garanti bitiş tarihine göre artan sırada döner.
  Stream<List<WarrantyModel>> watchItems(String familyId) {
    if (familyId.isEmpty) return Stream.value([]);
    return _col(familyId)
        .orderBy('warrantyEndDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WarrantyModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Tek bir garanti kaydını gerçek zamanlı dinler.
  Stream<WarrantyModel?> watchItem(String familyId, String itemId) {
    return _col(familyId).doc(itemId).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return null;
      return WarrantyModel.fromMap(snapshot.data()!, snapshot.id);
    });
  }

  // ── Yazma İşlemleri ───────────────────────────────────────────────────────

  /// Yeni garanti kaydı ekler.
  Future<String> addItem(WarrantyModel item) async {
    final data = item.toMap();
    data['createdAt'] = FieldValue.serverTimestamp();
    final ref = await _col(item.familyId).add(data);
    return ref.id;
  }

  /// Var olan garanti kaydını günceller.
  Future<void> updateItem(WarrantyModel item) {
    final data = {
      'name': item.name,
      'brand': item.brand,
      'store': item.store,
      'purchaseDate': Timestamp.fromDate(item.purchaseDate),
      'warrantyEndDate': Timestamp.fromDate(item.warrantyEndDate),
      'iconCodePoint': item.icon.codePoint,
      'hasInvoice': item.hasInvoice,
      'invoiceNumber': item.invoiceNumber,
      'notes': item.notes,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    return _col(item.familyId).doc(item.id).update(data);
  }

  /// Garanti kaydını siler.
  Future<void> deleteItem(String familyId, String itemId) =>
      _col(familyId).doc(itemId).delete();
}
