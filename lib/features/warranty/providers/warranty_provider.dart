import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/ad_provider.dart';
import '../../../core/providers/notification_provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/services/notification_service.dart';
import '../models/warranty_model.dart';
import '../repository/warranty_repository.dart';

// ── Repository ────────────────────────────────────────────────────────────────

final warrantyRepositoryProvider = Provider<WarrantyRepository>((ref) {
  return WarrantyRepository(ref.watch(firestoreServiceProvider));
});

// ── Stream Provider ───────────────────────────────────────────────────────────

/// Aktif ailenin garanti kayıtlarını gerçek zamanlı dinleyen provider.
final warrantyItemsProvider =
    StreamProvider<List<WarrantyModel>>((ref) {
  final familyId = ref.watch(activeFamilyIdProvider);
  return ref.watch(warrantyRepositoryProvider).watchItems(familyId);
});

// ── Türetilmiş Providers ──────────────────────────────────────────────────────

/// Yalnızca aktif garanti kayıtları.
final activeWarrantyItemsProvider = Provider<List<WarrantyModel>>((ref) {
  final items = ref.watch(warrantyItemsProvider).valueOrNull ?? [];
  return items.where((i) => i.status == WarrantyStatus.active).toList();
});

/// Yaklaşan (≤60 gün) garanti kayıtları.
final upcomingWarrantyItemsProvider = Provider<List<WarrantyModel>>((ref) {
  final items = ref.watch(warrantyItemsProvider).valueOrNull ?? [];
  return items.where((i) => i.status == WarrantyStatus.upcoming).toList();
});

/// Yaklaşan + süresi dolan toplam sayısı — Ana Sayfa uyarı badge'i.
final warrantyAlertCountProvider = Provider<int>((ref) {
  final upcoming = ref.watch(upcomingWarrantyItemsProvider).length;
  final items = ref.watch(warrantyItemsProvider).valueOrNull ?? [];
  final expired =
      items.where((i) => i.status == WarrantyStatus.expired).length;
  return upcoming + expired;
});

// ── Notifier ─────────────────────────────────────────────────────────────────

/// Garanti kaydı CRUD işlemlerini yöneten ve zamanlanmış bildirimleri kuran Notifier.
class WarrantyNotifier extends AsyncNotifier<void> {
  WarrantyRepository get _repo => ref.read(warrantyRepositoryProvider);
  NotificationService get _notificationService =>
      ref.read(notificationServiceProvider);

  String get _familyId => ref.read(activeFamilyIdProvider);
  String? get _uid => ref.read(firebaseAuthProvider).currentUser?.uid;

  @override
  Future<void> build() async {}

  Future<void> addItem(WarrantyModel item) async {
    final uid = _uid;
    if (uid == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final docId = await _repo.addItem(item);
      final newItem = item.copyWith(id: docId);
      await _notificationService.scheduleWarrantyNotifications(newItem);

      // Oturum bazlı döngüsel geçiş reklamı (1-3-5 mantığı)
      await ref.read(adServiceProvider).handleSessionFeatureAdTrigger('warranty_add_count', 2, triggerFirst: true);
    });
  }

  Future<void> updateItem(WarrantyModel item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.updateItem(item);
      await _notificationService.cancelWarrantyNotifications(item.id);
      await _notificationService.scheduleWarrantyNotifications(item);
    });
  }

  Future<void> deleteItem(String itemId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.deleteItem(_familyId, itemId);
      await _notificationService.cancelWarrantyNotifications(itemId);
    });
  }
}

final warrantyNotifierProvider =
    AsyncNotifierProvider<WarrantyNotifier, void>(WarrantyNotifier.new);
