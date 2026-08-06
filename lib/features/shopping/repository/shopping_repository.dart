import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../core/services/firestore_service.dart';
import '../models/shopping_item_model.dart';

/// Alışveriş listesi maddelerinin Firestore CRUD ve real-time stream
/// işlemlerini yöneten repository.
class ShoppingRepository {
  ShoppingRepository(this._firestoreService);

  final FirestoreService _firestoreService;

  CollectionReference<Map<String, dynamic>> _col(String familyId) =>
      _firestoreService.shoppingItemsRef(familyId);

  // ── Stream / Real-time ────────────────────────────────────────────────────

  /// [familyId]'e ait alışveriş maddelerini gerçek zamanlı dinler.
  ///
  /// İndeks hatası oluşturmaması için istemci tarafında sıralanır:
  /// Alınmayanlar önce (`isCompleted: false`), alınanlar sonra gelir.
  /// Her grup kendi içinde eklenme tarihine göre azalan sıralıdır.
  Stream<List<ShoppingItemModel>> watchItems(String familyId) {
    if (familyId.isEmpty) return Stream.value([]);

    return _col(familyId).snapshots().map((snapshot) {
      final items = snapshot.docs
          .map((doc) => ShoppingItemModel.fromMap(doc.data(), doc.id))
          .toList();

      items.sort((a, b) {
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
        final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });

      return items;
    }).handleError((error, stackTrace) {
      debugPrint('ShoppingRepository.watchItems sorgu hatası: $error');
      return <ShoppingItemModel>[];
    });
  }

  // ── Yazma İşlemleri ───────────────────────────────────────────────────────

  /// Yeni alışveriş maddesi ekler.
  Future<String> addItem(ShoppingItemModel item) async {
    if (item.familyId.isEmpty) {
      throw StateError('familyId boş olamaz.');
    }
    final data = item.toMap();
    data['createdAt'] = FieldValue.serverTimestamp();
    final ref = await _col(item.familyId).add(data);
    return ref.id;
  }

  /// Maddenin `isCompleted` durumunu günceller.
  Future<void> toggleItem(
    String familyId,
    String itemId, {
    required bool isCompleted,
    String? completedByUid,
  }) {
    if (familyId.isEmpty || itemId.isEmpty) return Future.value();
    return _col(familyId).doc(itemId).update({
      'isCompleted': isCompleted,
      'completedBy': isCompleted ? completedByUid : null,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Tamamlanan tüm maddeleri Firestore'dan siler (toplu silme).
  Future<void> clearCompleted(String familyId) async {
    if (familyId.isEmpty) return;
    final snapshot = await _col(familyId)
        .where('isCompleted', isEqualTo: true)
        .get();
    final batch = _firestoreService.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  /// Belirli bir maddeyi siler.
  Future<void> deleteItem(String familyId, String itemId) {
    if (familyId.isEmpty || itemId.isEmpty) return Future.value();
    return _col(familyId).doc(itemId).delete();
  }
}
