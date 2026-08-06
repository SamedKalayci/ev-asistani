import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Firebase Authentication işlemlerini yöneten servis.
///
/// Desteklenen giriş yöntemleri:
/// - Anonim giriş (misafir kullanıcı)
/// - E-posta & parola ile kayıt / giriş / çıkış
/// - Google hesabı ile anonim hesap bağlama (Account Linking)
class AuthService {
  AuthService(this._auth);

  final FirebaseAuth _auth;

  // ── Streams ──────────────────────────────────────────────────────────────

  /// Firebase'in oturum değişikliklerini dinleyen stream.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Getters ──────────────────────────────────────────────────────────────

  /// Anlık aktif kullanıcı. Oturum açılmamışsa `null` döner.
  User? get currentUser => _auth.currentUser;

  /// Aktif kullanıcının UID'si. Oturum açılmamışsa `null` döner.
  String? get uid => _auth.currentUser?.uid;

  // ── Anonim Giriş ─────────────────────────────────────────────────────────

  /// Anonim kullanıcı oluşturur. Zaten anonim bir oturum varsa aynı kullanıcıyı döner.
  Future<UserCredential> signInAnonymously() => _auth.signInAnonymously();

  // ── E-posta / Parola ──────────────────────────────────────────────────────

  /// Yeni kullanıcı kaydı oluşturur.
  ///
  /// Throws [FirebaseAuthException] giriş hatalarında.
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

  /// Mevcut kullanıcı ile e-posta & parola girişi yapar.
  ///
  /// Throws [FirebaseAuthException] giriş hatalarında.
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

  /// Anonim hesabı e-posta & parola ile kalıcı hesaba bağlar.
  ///
  /// Throws [FirebaseAuthException] bağlama başarısız olursa.
  Future<UserCredential?> linkWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    return user.linkWithCredential(credential);
  }

  // ── Google Hesap Bağlama (Account Linking) ───────────────────────────────

  /// Anonim hesabı Google ile kalıcı hesaba bağlar.
  ///
  /// Web (`kIsWeb`) ve Mobil platform farklarını otomatik yönetir.
  Future<UserCredential?> linkWithGoogle() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    if (kIsWeb) {
      final googleProvider = GoogleAuthProvider();
      googleProvider.setCustomParameters({
        'prompt': 'select_account',
      });
      return user.linkWithPopup(googleProvider);
    } else {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return user.linkWithCredential(credential);
    }
  }

  // ── Google ile Giriş Yap ──────────────────────────────────────────────────

  /// Google ile doğrudan giriş yapar.
  ///
  /// Web (`kIsWeb`) için `signInWithPopup`, Mobil için `GoogleSignIn` credential ile `signInWithCredential` kullanır.
  Future<UserCredential?> signInWithGoogle() async {
    if (kIsWeb) {
      final googleProvider = GoogleAuthProvider();
      googleProvider.setCustomParameters({
        'prompt': 'select_account',
      });
      return _auth.signInWithPopup(googleProvider);
    } else {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return _auth.signInWithCredential(credential);
    }
  }

  // ── Apple ile Giriş Yap ───────────────────────────────────────────────────

  /// Apple ile doğrudan giriş yapar.
  Future<UserCredential?> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    return _auth.signInWithCredential(oauthCredential);
  }

  // ── Çıkış ────────────────────────────────────────────────────────────────

  /// Aktif oturumu sonlandırır.
  Future<void> signOut() => _auth.signOut();

  // ── Parola Sıfırlama ──────────────────────────────────────────────────────

  /// Verilen e-posta adresine parola sıfırlama bağlantısı gönderir.
  Future<void> sendPasswordResetEmail(String email) =>
      _auth.sendPasswordResetEmail(email: email);
}
