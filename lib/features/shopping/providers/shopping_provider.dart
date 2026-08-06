import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/ad_provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../shared/services/shopping_list_service.dart';
import '../models/shopping_item_model.dart';
import '../repository/shopping_repository.dart';

// ── Repository ────────────────────────────────────────────────────────────────

final shoppingRepositoryProvider = Provider<ShoppingRepository>((ref) {
  return ShoppingRepository(ref.watch(firestoreServiceProvider));
});

// ── Stream Provider ───────────────────────────────────────────────────────────

/// Aktif ailenin alışveriş listesini gerçek zamanlı dinleyen provider.
///
/// Alınmayanlar üstte, alınanlar altta listelenir.
final shoppingItemsProvider =
    StreamProvider<List<ShoppingItemModel>>((ref) {
  final familyId = ref.watch(activeFamilyIdProvider);
  if (familyId.isEmpty) {
    return Stream.value([]);
  }
  return ref.watch(shoppingRepositoryProvider).watchItems(familyId);
});

// ── Türetilmiş Providers ──────────────────────────────────────────────────────

/// Alınmamış ürünler.
final pendingShoppingItemsProvider =
    Provider<List<ShoppingItemModel>>((ref) {
  final items = ref.watch(shoppingItemsProvider).valueOrNull ?? [];
  return items.where((i) => !i.isCompleted).toList();
});

/// Alınan ürünler.
final completedShoppingItemsProvider =
    Provider<List<ShoppingItemModel>>((ref) {
  final items = ref.watch(shoppingItemsProvider).valueOrNull ?? [];
  return items.where((i) => i.isCompleted).toList();
});

/// Toplam ürün sayısı — AppBar rozeti için.
final shoppingItemCountProvider = Provider<int>((ref) {
  return (ref.watch(shoppingItemsProvider).valueOrNull ?? []).length;
});

// ── Notifier ─────────────────────────────────────────────────────────────────

/// Alışveriş listesi CRUD işlemlerini yöneten Notifier.
class ShoppingNotifier extends AsyncNotifier<void> {
  ShoppingRepository get _repo => ref.read(shoppingRepositoryProvider);
  String get _familyId => ref.read(activeFamilyIdProvider);

  /// Oturum yoksa veya anonim auth yükleniyorsa varsayılan dev/web UID döner.
  String get _uid {
    final authUser = ref.read(firebaseAuthProvider).currentUser;
    if (authUser != null && authUser.uid.isNotEmpty) {
      return authUser.uid;
    }
    return kIsWeb ? 'demo_user_web_123' : 'demo_user_dev';
  }

  @override
  Future<void> build() async {}

  // ── Ekle ─────────────────────────────────────────────────────────────────

  /// Hızlı ekleme: sadece isim verilir, kategori/not opsiyonel.
  Future<void> addItem({
    required String name,
    String? note,
    String? category,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return;

    final uid = _uid;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final item = ShoppingItemModel(
        id: '',
        familyId: _familyId,
        name: trimmedName,
        createdBy: uid,
        note: note?.trim().isEmpty == true ? null : note?.trim(),
        category: category?.trim().isEmpty == true ? null : category?.trim(),
      );
      await _repo.addItem(item);
      
      // Özellik bazlı geçiş reklamı tetikleyicisi (5. ve 12. eklemelerde)
      await ref.read(adServiceProvider).handleFeatureAdTrigger('shopping_add_count', [5, 12]);
    });
  }

  // ── Dış kaynaklı toplu ekleme (tarif malzemeleri için) ────────────────────

  /// Birden fazla maddeyi ekler.
  Future<void> addBulkItems(List<String> names) async {
    if (names.isEmpty) return;

    final uid = _uid;
    final familyId = _familyId;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = _repo;
      for (final name in names) {
        if (name.trim().isEmpty) continue;
        await repo.addItem(
          ShoppingItemModel(
            id: '',
            familyId: familyId,
            name: name.trim(),
            createdBy: uid,
          ),
        );
      }
    });
  }

  // ── Toggle ────────────────────────────────────────────────────────────────

  /// Maddeyi alındı / alınmadı olarak işaretle.
  Future<void> toggleItem(String itemId, {required bool isCompleted}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.toggleItem(
          _familyId,
          itemId,
          isCompleted: isCompleted,
          completedByUid: isCompleted ? _uid : null,
        ));
  }

  // ── Sil ───────────────────────────────────────────────────────────────────

  Future<void> deleteItem(String itemId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.deleteItem(_familyId, itemId));
  }

  /// Tüm alınan maddeleri siler.
  Future<void> clearCompleted() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.clearCompleted(_familyId));
  }
}

final shoppingNotifierProvider =
    AsyncNotifierProvider<ShoppingNotifier, void>(ShoppingNotifier.new);

// ── Shared Service Implementation ──────────────────────────────────────────────

/// Modüller arası bağımsız iletişim için [ShoppingListService] implemantasyonu.
class ShoppingListServiceImpl implements ShoppingListService {
  ShoppingListServiceImpl(this._ref);
  final Ref _ref;

  @override
  Future<void> addBulkItems(List<String> items) {
    return _ref.read(shoppingNotifierProvider.notifier).addBulkItems(items);
  }
}

