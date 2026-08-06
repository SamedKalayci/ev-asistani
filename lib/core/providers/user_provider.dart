import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';

// ── Altyapı Sağlayıcıları ─────────────────────────────────────────────────────

/// Firebase Auth singleton sağlayıcısı.
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (_) => FirebaseAuth.instance,
);

/// Firestore singleton sağlayıcısı.
final firestoreProvider = Provider<FirebaseFirestore>(
  (_) => FirebaseFirestore.instance,
);

/// Firebase Storage singleton sağlayıcısı.
final firebaseStorageProvider = Provider<FirebaseStorage>(
  (_) => FirebaseStorage.instance,
);

// ── Servis Sağlayıcıları ──────────────────────────────────────────────────────

/// [AuthService] sağlayıcısı.
final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.watch(firebaseAuthProvider)),
);

/// [FirestoreService] sağlayıcısı.
final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(ref.watch(firestoreProvider)),
);

/// [StorageService] sağlayıcısı.
final storageServiceProvider = Provider<StorageService>(
  (ref) => StorageService(ref.watch(firebaseStorageProvider)),
);

// ── Anonymous Auth Bootstrap ──────────────────────────────────────────────────

/// Otomatik anonim girişi TETİKLEMEZ; sadece mevcut kullanıcı durumunu döner.
final bootstrapAuthProvider = FutureProvider<User?>((ref) async {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.currentUser;
});

// ── Auth Durumu ───────────────────────────────────────────────────────────────

/// Firebase Auth oturumunu gerçek zamanlı dinleyen provider.
///
/// - `null` → oturum kapalı (LoginScreen açılır).
/// - `User` → oturum açık (E-posta veya Misafir/Anonim).
final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authServiceProvider).authStateChanges,
);

// ── Kullanıcı Profili ─────────────────────────────────────────────────────────

/// Aktif kullanıcının Firestore profilini gerçek zamanlı dinleyen provider.
/// Oturum kapalıysa (`null`) Stream.value(null) döner.
final userProvider = StreamProvider<UserModel?>(
  (ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => const Stream.empty(),
      error: (_, __) => const Stream.empty(),
      data: (user) {
        if (user == null) return Stream.value(null);

        final firestoreService = ref.watch(firestoreServiceProvider);
        return firestoreService.watchUser(user.uid).map((snapshot) {
          if (!snapshot.exists || snapshot.data() == null) return null;
          return UserModel.fromMap(snapshot.data()!, snapshot.id);
        });
      },
    );
  },
);

// ── Türetilmiş Sağlayıcılar ───────────────────────────────────────────────────

/// Aktif kullanıcının `familyId` bilgisini dinleyen provider.
final activeFamilyIdProvider = Provider<String>(
  (ref) {
    final userAsync = ref.watch(userProvider);
    final familyId = userAsync.whenOrNull(data: (user) => user?.familyId);
    return (familyId != null && familyId.isNotEmpty) ? familyId : '';
  },
);

/// Kullanıcının gerçek bir aile dökümanına bağlı olup olmadığını döner.
final hasRealFamilyProvider = Provider<bool>(
  (ref) {
    final userAsync = ref.watch(userProvider);
    return userAsync.whenOrNull(data: (user) => user?.hasFamilyId) ?? false;
  },
);

/// Aktif kullanıcının kimlik doğrulamasının tamamlanıp tamamlanmadığını döner.
final isAuthenticatedProvider = Provider<bool>(
  (ref) {
    final authState = ref.watch(authStateProvider);
    return authState.whenOrNull(data: (user) => user != null) ?? false;
  },
);
