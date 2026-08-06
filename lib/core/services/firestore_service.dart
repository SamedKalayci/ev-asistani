import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore ile gerçek zamanlı (real-time) iletişimi yöneten servis.
///
/// Koleksiyon referansları ve genel CRUD yardımcıları burada merkezileştirilmiştir.
/// Sorguların tamamı aktif kullanıcının [familyId]'sine göre filtrelenir.
class FirestoreService {
  FirestoreService(this._db);

  final FirebaseFirestore _db;

  // ── Koleksiyon Referansları ───────────────────────────────────────────────

  /// `users/{uid}` koleksiyonu
  CollectionReference<Map<String, dynamic>> get usersRef =>
      _db.collection('users');

  /// `families/{familyId}` koleksiyonu
  CollectionReference<Map<String, dynamic>> get familiesRef =>
      _db.collection('families');

  /// `families/{familyId}/expiryItems` alt-koleksiyonu
  CollectionReference<Map<String, dynamic>> expiryItemsRef(String familyId) =>
      _db.collection('families').doc(familyId).collection('expiryItems');

  /// `families/{familyId}/warrantyItems` alt-koleksiyonu
  CollectionReference<Map<String, dynamic>> warrantyItemsRef(String familyId) =>
      _db.collection('families').doc(familyId).collection('warrantyItems');

  /// `families/{familyId}/shoppingItems` alt-koleksiyonu
  CollectionReference<Map<String, dynamic>> shoppingItemsRef(String familyId) =>
      _db.collection('families').doc(familyId).collection('shoppingItems');

  /// `families/{familyId}/recipes` alt-koleksiyonu
  CollectionReference<Map<String, dynamic>> recipeItemsRef(String familyId) =>
      _db.collection('families').doc(familyId).collection('recipes');

  // ── Kullanıcı İşlemleri ───────────────────────────────────────────────────

  /// Belirtilen `uid`'ye ait kullanıcı dökümanını okur (tek seferlik).
  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) =>
      usersRef.doc(uid).get();

  /// Belirtilen `uid`'ye ait kullanıcı dökümanını gerçek zamanlı dinler.
  Stream<DocumentSnapshot<Map<String, dynamic>>> watchUser(String uid) =>
      usersRef.doc(uid).snapshots();

  /// Kullanıcı dökümanını oluşturur veya günceller (merge: true).
  Future<void> setUser(
    String uid,
    Map<String, dynamic> data, {
    bool merge = true,
  }) =>
      usersRef.doc(uid).set(data, SetOptions(merge: merge));

  /// Kullanıcının profil bilgilerini (isim, avatar vb.) günceller.
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) =>
      usersRef.doc(uid).update(data);

  // ── Aile İşlemleri ────────────────────────────────────────────────────────

  /// Belirtilen `familyId`'ye ait aile dökümanını okur (tek seferlik).
  Future<DocumentSnapshot<Map<String, dynamic>>> getFamily(String familyId) =>
      familiesRef.doc(familyId).get();

  /// Belirtilen `familyId`'ye ait aile dökümanını gerçek zamanlı dinler.
  Stream<DocumentSnapshot<Map<String, dynamic>>> watchFamily(String familyId) =>
      familiesRef.doc(familyId).snapshots();

  /// Yeni bir aile dökümanı oluşturur ve döküman ID'sini döner.
  Future<String> createFamily(Map<String, dynamic> data) async {
    final docRef = await familiesRef.add(data);
    return docRef.id;
  }

  /// Belirtilen `familyId`'ye ait aile dökümanını günceller.
  Future<void> updateFamily(String familyId, Map<String, dynamic> data) =>
      familiesRef.doc(familyId).update(data);

  // ── Genel Koleksiyon Yardımcıları ─────────────────────────────────────────

  /// Verilen alt-koleksiyondan gerçek zamanlı veri dinler.
  Stream<QuerySnapshot<Map<String, dynamic>>> watchCollection(
    CollectionReference<Map<String, dynamic>> ref, {
    String? orderByField,
    bool descending = false,
  }) {
    Query<Map<String, dynamic>> query = ref;
    if (orderByField != null) {
      query = query.orderBy(orderByField, descending: descending);
    }
    return query.snapshots();
  }

  /// Bir alt-koleksiyona yeni döküman ekler ve oluşturulan dökümanı döner.
  Future<DocumentReference<Map<String, dynamic>>> addDocument(
    CollectionReference<Map<String, dynamic>> ref,
    Map<String, dynamic> data,
  ) =>
      ref.add(data);

  /// Belirtilen referanstaki dökümanı günceller.
  Future<void> updateDocument(
    DocumentReference<Map<String, dynamic>> ref,
    Map<String, dynamic> data,
  ) =>
      ref.update(data);

  /// Belirtilen referanstaki dökümanı siler.
  Future<void> deleteDocument(
    DocumentReference<Map<String, dynamic>> ref,
  ) =>
      ref.delete();

  // ── Transaction & Batch ───────────────────────────────────────────────────

  /// Atomik işlem grubu çalıştırır.
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) updateFunction,
  ) =>
      _db.runTransaction(updateFunction);

  /// Toplu yazma işlemi başlatır.
  WriteBatch batch() => _db.batch();
}
