import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../shared/models/user_model.dart';

/// Kullanıcı kimlik doğrulama ve profil yönetimi repository'si.
class AuthRepository {
  AuthRepository(this._authService, this._firestoreService);

  final AuthService _authService;
  final FirestoreService _firestoreService;

  Stream<User?> get authStateChanges => _authService.authStateChanges;
  User? get currentUser => _authService.currentUser;

  /// Anonim giriş yapar veya mevcut oturumu döner.
  Future<User?> ensureAuthenticated() async {
    final current = currentUser;
    if (current != null) return current;
    final credential = await _authService.signInAnonymously();
    return credential.user;
  }

  /// Yeni kullanıcı kaydı oluşturur ve Firestore users/{userId} dökümanını yazar.
  Future<UserCredential> registerUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    final credential = await _authService.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user != null) {
      try {
        await user.updateDisplayName(name.trim());
      } catch (_) {}

      await _firestoreService.setUser(
        user.uid,
        {
          'uid': user.uid,
          'email': email.trim(),
          'displayName': name.trim(),
          'name': name.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'familyId': null,
          'role': UserRole.member.name,
        },
        merge: true,
      );
    }
    return credential;
  }

  /// E-posta & parola ile giriş yapar.
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _authService.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Google ile doğrudan giriş yapar ve Firestore dökümanını eşitler.
  Future<UserCredential?> signInWithGoogle() async {
    final credential = await _authService.signInWithGoogle();
    final user = credential?.user;
    if (user != null) {
      final data = <String, dynamic>{
        'uid': user.uid,
        'email': user.email ?? '',
        'displayName': user.displayName ?? '',
        'name': user.displayName ?? '',
        'photoUrl': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'role': UserRole.member.name,
      };
      await _firestoreService.setUser(user.uid, data, merge: true);
    }
    return credential;
  }

  /// Apple ile doğrudan giriş yapar ve Firestore dökümanını eşitler.
  Future<UserCredential?> signInWithApple() async {
    final credential = await _authService.signInWithApple();
    final user = credential?.user;
    if (user != null) {
      final data = <String, dynamic>{
        'uid': user.uid,
        if (user.email != null) 'email': user.email,
        if (user.displayName != null && user.displayName!.isNotEmpty) ...{
          'displayName': user.displayName,
          'name': user.displayName,
        },
        if (user.photoURL != null) 'photoUrl': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'role': UserRole.member.name,
      };
      await _firestoreService.setUser(user.uid, data, merge: true);
    }
    return credential;
  }

  /// Parola sıfırlama e-postası gönderir.
  Future<void> sendPasswordResetEmail(String email) {
    return _authService.sendPasswordResetEmail(email.trim());
  }

  /// Oturumu kapatır.
  Future<void> signOut() => _authService.signOut();

  /// Anonim hesabı Google ile bağlar ve Firestore kullanıcı dökümanını günceller.
  Future<UserCredential?> linkWithGoogle() async {
    final credential = await _authService.linkWithGoogle();
    final user = credential?.user;
    if (user != null) {
      final updates = <String, dynamic>{
        'uid': user.uid,
        if (user.email != null) 'email': user.email,
        if (user.displayName != null && user.displayName!.isNotEmpty) ...{
          'displayName': user.displayName,
          'name': user.displayName,
        },
        if (user.photoURL != null) 'photoUrl': user.photoURL,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      await _firestoreService.setUser(user.uid, updates, merge: true);
    }
    return credential;
  }

  /// Firestore'daki kullanıcı profilini dinler.
  Stream<UserModel?> watchUser(String uid) {
    return _firestoreService.watchUser(uid).map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return null;
      return UserModel.fromMap(snapshot.data()!, snapshot.id);
    });
  }

  /// Kullanıcı profil bilgilerini günceller (isim, photoUrl vb.).
  Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? photoUrl,
    String? familyId,
    UserRole? role,
  }) async {
    final updates = <String, dynamic>{
      if (name != null) 'name': name,
      if (name != null) 'displayName': name,
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (familyId != null) 'familyId': familyId,
      if (role != null) 'role': role.name,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await _firestoreService.setUser(uid, updates, merge: true);
  }
}
