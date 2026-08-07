// Re-export: user_provider.dart'taki provider'lara bu dosyadan da ulaşılabilir.
export '../../../core/providers/user_provider.dart'
    show firebaseAuthProvider, activeFamilyIdProvider;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/ad_provider.dart';
import '../../../core/providers/notification_provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/services/notification_service.dart';
import '../models/expiration_model.dart';
import '../repository/expiration_repository.dart';

// ── Repository ────────────────────────────────────────────────────────────────

/// [ExpirationRepository] singleton'ı — [FirestoreService] enjekte edilir.
final expirationRepositoryProvider = Provider<ExpirationRepository>((ref) {
  return ExpirationRepository(ref.watch(firestoreServiceProvider));
});

// ── Stream Provider ───────────────────────────────────────────────────────────

/// Aktif ailenin son kullanma ürünlerini real-time dinleyen provider.
final expirationItemsProvider =
    StreamProvider<List<ExpirationModel>>((ref) {
  final familyId = ref.watch(activeFamilyIdProvider);
  return ref.watch(expirationRepositoryProvider).watchItems(familyId);
});

// ── Türetilmiş Providers ──────────────────────────────────────────────────────

/// Yalnızca kritik durumda olanları döner (süresi dolmuş veya bugün son).
final criticalExpirationItemsProvider =
    Provider<List<ExpirationModel>>((ref) {
  final items = ref.watch(expirationItemsProvider).valueOrNull ?? [];
  return items
      .where((i) => i.status == ExpirationStatus.critical || i.status == ExpirationStatus.expired)
      .toList();
});

/// Yalnızca yaklaşan (≤7 gün) ürünleri döner.
final upcomingExpirationItemsProvider =
    Provider<List<ExpirationModel>>((ref) {
  final items = ref.watch(expirationItemsProvider).valueOrNull ?? [];
  return items
      .where((i) => i.status == ExpirationStatus.upcoming)
      .toList();
});

/// Kritik + yaklaşan toplam sayısı — Ana Sayfa badge'i için.
final expirationAlertCountProvider = Provider<int>((ref) {
  final critical = ref.watch(criticalExpirationItemsProvider).length;
  final upcoming = ref.watch(upcomingExpirationItemsProvider).length;
  return critical + upcoming;
});

// ── Notifier: Ekleme / Düzenleme / Silme ─────────────────────────────────────

/// [ExpirationModel] CRUD işlemlerini tetikleyen Notifier.
///
/// Her metod sonucu `AsyncValue` olarak yönetilir; UI `isLoading` ve
/// hata durumlarını buradan okur.
class ExpirationNotifier extends AsyncNotifier<void> {
  ExpirationRepository get _repo =>
      ref.read(expirationRepositoryProvider);

  NotificationService get _notificationService =>
      ref.read(notificationServiceProvider);

  String get _familyId => ref.read(activeFamilyIdProvider);

  String? get _uid =>
      ref.read(firebaseAuthProvider).currentUser?.uid;

  @override
  Future<void> build() async {}

  // ── Ekle ─────────────────────────────────────────────────────────────────

  /// Yeni ürün ekler, otomatik bildirimleri zamanlar ve günlük geçiş reklamını tetikler.
  ///
  /// [familyId] veya [uid] yoksa [StateError] fırlatır.
  Future<void> addItem({
    required String title,
    required String location,
    required DateTime expirationDate,
    required int iconCodePoint,
    String? imageUrl,
    String? notes,
  }) async {
    state = const AsyncLoading();
    final familyId = _familyId;
    final uid = _uid;

    if (uid == null) {
      state = AsyncError(
        StateError('Kullanıcı oturumu bulunamadı.'),
        StackTrace.current,
      );
      return;
    }

    state = await AsyncValue.guard(() async {
      final item = ExpirationModel(
        id: '', // Firestore tarafından atanacak
        familyId: familyId,
        title: title,
        location: location,
        expirationDate: expirationDate,
        icon: _codePointToIcon(iconCodePoint),
        createdBy: uid,
        imageUrl: imageUrl,
        notes: notes,
      );
      final docId = await _repo.addItem(item);
      final newItem = item.copyWith(id: docId);
      await _notificationService.scheduleExpirationNotifications(newItem);

      // Oturum bazlı döngüsel geçiş reklamı (her 5 ürün eklemede bir)
      await ref.read(adServiceProvider).handleSessionFeatureAdTrigger('expiration_add_count', 5);
    });
  }

  // ── Güncelle ──────────────────────────────────────────────────────────────

  /// Var olan ürünü günceller ve bildirimlerini yeniden zamanlar.
  Future<void> updateItem(ExpirationModel updated) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.updateItem(updated);
      await _notificationService.cancelExpirationNotifications(updated.id);
      await _notificationService.scheduleExpirationNotifications(updated);
    });
  }

  // ── Sil ───────────────────────────────────────────────────────────────────

  /// Ürünü Firestore'dan siler ve zamanlanmış bildirimlerini iptal eder.
  Future<void> deleteItem(String itemId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.deleteItem(_familyId, itemId);
      await _notificationService.cancelExpirationNotifications(itemId);
    });
  }

  // ── Toplu Silme (Süresi Dolanlar) ─────────────────────────────────────────

  /// Süresi dolmuş tüm ürünleri siler ve bildirimlerini iptal eder.
  Future<void> batchDeleteExpiredItems() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final items = ref.read(expirationItemsProvider).valueOrNull ?? [];
      final expiredItems = items.where((i) => i.status == ExpirationStatus.expired).toList();
      
      for (final item in expiredItems) {
        await _repo.deleteItem(_familyId, item.id);
        await _notificationService.cancelExpirationNotifications(item.id);
      }
    });
  }

  // ── Özel Yardımcı ─────────────────────────────────────────────────────────

  static IconData _codePointToIcon(int codePoint) =>
      // ignore: non_const_argument_for_const_parameter
      IconData(codePoint, fontFamily: 'MaterialIcons');
}

/// [ExpirationNotifier] provider'ı.
final expirationNotifierProvider =
    AsyncNotifierProvider<ExpirationNotifier, void>(
  ExpirationNotifier.new,
);
