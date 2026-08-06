import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_provider.dart';
import '../../../shared/models/family_model.dart';
import '../../../shared/models/user_model.dart';
import '../repository/auth_repository.dart';
import '../repository/family_repository.dart';

// ── Repository Providers ─────────────────────────────────────────────────────

final familyRepositoryProvider = Provider<FamilyRepository>((ref) {
  return FamilyRepository(ref.watch(firestoreServiceProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(authServiceProvider),
    ref.watch(firestoreServiceProvider),
  );
});

// ── Stream Providers ─────────────────────────────────────────────────────────

/// Aktif kullanıcının ailesini gerçek zamanlı dinleyen provider.
final currentFamilyProvider = StreamProvider<FamilyModel?>((ref) {
  final familyId = ref.watch(activeFamilyIdProvider);
  return ref.watch(familyRepositoryProvider).watchFamily(familyId);
});

/// Aktif ailenin üyelerini gerçek zamanlı dinleyen provider.
final familyMembersProvider = StreamProvider<List<UserModel>>((ref) {
  final familyId = ref.watch(activeFamilyIdProvider);
  return ref.watch(familyRepositoryProvider).watchFamilyMembers(familyId);
});

// ── Family Notifier ──────────────────────────────────────────────────────────

/// Aile oluşturma, katılma, ayrılma ve üye yönetimi işlemlerini yürüten Notifier.
class FamilyNotifier extends AsyncNotifier<void> {
  FamilyRepository get _familyRepo => ref.read(familyRepositoryProvider);
  AuthRepository get _authRepo => ref.read(authRepositoryProvider);

  /// Aktif kullanıcı UID'sini döner. Oturum kapalıysa StateError fırlatır.
  Future<String> _getOrEnsureUid() async {
    final auth = ref.read(firebaseAuthProvider);
    final user = auth.currentUser;
    if (user != null) return user.uid;
    throw StateError('Oturum kapalı. Lütfen önce giriş yapın.');
  }

  @override
  Future<void> build() async {}

  void _refreshProviders() {
    ref.invalidate(userProvider);
    ref.invalidate(currentFamilyProvider);
    ref.invalidate(familyMembersProvider);
  }

  /// Yeni bir ev / aile oluşturur.
  Future<void> createFamily(String familyName) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = await _getOrEnsureUid();
      await _familyRepo.createFamily(
        familyName: familyName,
        ownerUid: uid,
      );
      _refreshProviders();
    });
  }

  /// 6 haneli davet koduyla var olan bir eve katılır.
  Future<void> joinFamilyWithCode(String inviteCode) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = await _getOrEnsureUid();
      await _familyRepo.joinFamilyWithCode(
        inviteCode: inviteCode,
        userUid: uid,
      );
      _refreshProviders();
    });
  }

  /// Aileden ayrılır.
  Future<void> leaveFamily() async {
    final familyId = ref.read(activeFamilyIdProvider);
    if (familyId.isEmpty) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = await _getOrEnsureUid();
      await _familyRepo.leaveFamily(
        familyId: familyId,
        userUid: uid,
      );
      _refreshProviders();
    });
  }

  /// Üyeyi evden çıkarır (sadece Ev Sahibi).
  Future<void> removeMember(String memberUid) async {
    final familyId = ref.read(activeFamilyIdProvider);
    if (familyId.isEmpty) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _familyRepo.removeMember(
        familyId: familyId,
        memberUid: memberUid,
      );
      _refreshProviders();
    });
  }

  /// Kullanıcı adını günceller.
  Future<void> updateProfileName(String newName) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = await _getOrEnsureUid();
      await _authRepo.updateUserProfile(
        uid: uid,
        name: newName,
      );
      _refreshProviders();
    });
  }

  /// Anonim kullanıcı hesabını Google hesabı ile bağlar.
  Future<void> linkWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final credential = await _authRepo.linkWithGoogle();
      if (credential?.user != null) {
        _refreshProviders();
      }
    });
  }
}

final familyNotifierProvider =
    AsyncNotifierProvider<FamilyNotifier, void>(FamilyNotifier.new);
