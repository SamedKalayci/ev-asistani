import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/firestore_service.dart';
import '../../../shared/models/family_model.dart';
import '../../../shared/models/user_model.dart';

/// Aile ve davet kodu yönetimi Firestore işlemlerini atomik WriteBatch ile gerçekleştiren repository.
class FamilyRepository {
  FamilyRepository(this._firestoreService);

  final FirestoreService _firestoreService;

  CollectionReference<Map<String, dynamic>> get _familiesRef =>
      _firestoreService.familiesRef;

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestoreService.usersRef;

  // ── Stream / Real-time ────────────────────────────────────────────────────

  /// Aile dökümanını gerçek zamanlı dinler.
  Stream<FamilyModel?> watchFamily(String familyId) {
    if (familyId.isEmpty) return Stream.value(null);
    return _familiesRef.doc(familyId).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return null;
      return FamilyModel.fromMap(snapshot.data()!, snapshot.id);
    });
  }

  /// Aile üyelerini gerçek zamanlı dinler.
  Stream<List<UserModel>> watchFamilyMembers(String familyId) {
    if (familyId.isEmpty) return Stream.value([]);
    return _usersRef
        .where('familyId', isEqualTo: familyId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // ── Aile Oluşturma (Atomik WriteBatch) ────────────────────────────────────

  /// Yeni bir aile oluşturur, 6 haneli benzersiz davet kodu atar ve oluşturan kişiyi ev sahibi (owner) yapar.
  /// `families` dökümanı ile `users/{userId}` dökümanı atomik (WriteBatch) olarak güncellenir.
  Future<FamilyModel> createFamily({
    required String familyName,
    required String ownerUid,
  }) async {
    final inviteCode = FamilyModel.generateInviteCode();
    final batch = _firestoreService.batch();

    final familyDocRef = _familiesRef.doc();
    final familyId = familyDocRef.id;

    final familyData = {
      'familyId': familyId,
      'familyName': familyName.trim(),
      'name': familyName.trim(),
      'inviteCode': inviteCode,
      'memberUids': [ownerUid],
      'memberIds': [ownerUid],
      'createdBy': ownerUid,
      'ownerId': ownerUid,
      'createdAt': FieldValue.serverTimestamp(),
    };

    // 1. families dokümanını ekle
    batch.set(familyDocRef, familyData);

    // 2. users/{userId} dokümanında familyId ve role alanlarını güncelle
    final userDocRef = _usersRef.doc(ownerUid);
    batch.set(
      userDocRef,
      {
        'uid': ownerUid,
        'familyId': familyId,
        'role': UserRole.owner.name,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    // Atomik olarak commit et
    await batch.commit();

    return FamilyModel(
      familyId: familyId,
      familyName: familyName.trim(),
      inviteCode: inviteCode,
      memberUids: [ownerUid],
      createdBy: ownerUid,
      createdAt: DateTime.now(),
    );
  }

  // ── Aileye Katılma (Atomik WriteBatch) ────────────────────────────────────

  /// 6 haneli davet kodunu Firestore'da sorgular, geçerliyse kullanıcıyı ailenin üyesi yapar.
  /// `families` ve `users/{userId}` dokümanları atomik WriteBatch ile güncellenir.
  Future<FamilyModel> joinFamilyWithCode({
    required String inviteCode,
    required String userUid,
  }) async {
    final cleanedCode = inviteCode.trim().toUpperCase();

    if (cleanedCode.length != 6) {
      throw StateError('Davet kodu 6 haneli olmalıdır.');
    }

    final query = await _familiesRef
        .where('inviteCode', isEqualTo: cleanedCode)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      throw StateError('Girdiğiniz "$cleanedCode" davet koduna ait bir ev bulunamadı.');
    }

    final familyDoc = query.docs.first;
    final familyId = familyDoc.id;
    final familyMap = familyDoc.data();

    final batch = _firestoreService.batch();

    // 1. families/{familyId} üye listesine kullanıcıyı ekle
    final familyDocRef = _familiesRef.doc(familyId);
    batch.update(familyDocRef, {
      'memberUids': FieldValue.arrayUnion([userUid]),
      'memberIds': FieldValue.arrayUnion([userUid]),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // 2. users/{userUid} dökümanını aile bilgisiyle güncelle
    final userDocRef = _usersRef.doc(userUid);
    batch.set(
      userDocRef,
      {
        'uid': userUid,
        'familyId': familyId,
        'role': UserRole.member.name,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    await batch.commit();

    return FamilyModel.fromMap(familyMap, familyId);
  }

  // ── Aileden Ayrılma / Üye Çıkarma ─────────────────────────────────────────

  /// Kullanıcıyı aileden çıkarır ve kullanıcının `familyId`'sini atomik olarak temizler.
  Future<void> leaveFamily({
    required String familyId,
    required String userUid,
  }) async {
    final batch = _firestoreService.batch();

    final familyDocRef = _familiesRef.doc(familyId);
    batch.update(familyDocRef, {
      'memberUids': FieldValue.arrayRemove([userUid]),
      'memberIds': FieldValue.arrayRemove([userUid]),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    final userDocRef = _usersRef.doc(userUid);
    batch.set(
      userDocRef,
      {
        'familyId': FieldValue.delete(),
        'role': UserRole.member.name,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  /// Ev sahibinin bir üyeyi aileden çıkarmasını sağlar.
  Future<void> removeMember({
    required String familyId,
    required String memberUid,
  }) async {
    await leaveFamily(familyId: familyId, userUid: memberUid);
  }
}
