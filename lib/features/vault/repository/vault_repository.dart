import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/firestore_service.dart';
import '../models/vault_item_model.dart';

/// Dijital Ev Kasası (Vault) döküman işlemlerinden sorumlu repository.
class VaultRepository {
  final FirestoreService _firestoreService;

  VaultRepository(this._firestoreService);

  CollectionReference<Map<String, dynamic>> _vaultRef(String familyId) =>
      _firestoreService.familiesRef.doc(familyId).collection('vaultItems');

  /// Aktif ailenin dijital kasa dökümanlarını gerçek zamanlı dinler.
  Stream<List<VaultItemModel>> watchVaultItems(String familyId) {
    if (familyId.isEmpty) return Stream.value([]);

    return _vaultRef(familyId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => VaultItemModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// Yeni dijital kasa dökümanı ekler.
  Future<void> addVaultItem(String familyId, VaultItemModel item) async {
    await _vaultRef(familyId).add(item.toMap());
  }

  /// Mevcut bir kasa dökümanını günceller.
  Future<void> updateVaultItem(
      String familyId, String itemId, Map<String, dynamic> data) async {
    await _vaultRef(familyId).doc(itemId).update(data);
  }

  /// Bakım / İlgili döküman tamamlandı durumunu değiştirir.
  Future<void> toggleCompletedStatus(
      String familyId, String itemId, bool currentStatus) async {
    await _vaultRef(familyId).doc(itemId).update({'isCompleted': !currentStatus});
  }

  /// Kasadaki bir dökümanı siler.
  Future<void> deleteVaultItem(String familyId, String itemId) async {
    await _vaultRef(familyId).doc(itemId).delete();
  }
}
