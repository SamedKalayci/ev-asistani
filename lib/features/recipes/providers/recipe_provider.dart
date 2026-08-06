import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_provider.dart';
import '../models/recipe_model.dart';
import '../repository/recipe_repository.dart';

// ── Repository Provider ──────────────────────────────────────────────────────

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  return RecipeRepository(ref.watch(firestoreServiceProvider));
});

// ── Stream Providers ─────────────────────────────────────────────────────────

/// Aktif ailenin yemek tariflerini gerçek zamanlı dinleyen provider.
final recipesProvider = StreamProvider<List<RecipeModel>>((ref) {
  final familyId = ref.watch(activeFamilyIdProvider);
  return ref.watch(recipeRepositoryProvider).watchRecipes(familyId);
});

/// Tek bir yemeğin detayını dinleyen stream provider.
final recipeDetailProvider =
    StreamProvider.family<RecipeModel?, String>((ref, recipeId) {
  final familyId = ref.watch(activeFamilyIdProvider);
  return ref
      .watch(recipeRepositoryProvider)
      .watchRecipe(familyId, recipeId);
});

// ── Notifier ─────────────────────────────────────────────────────────────────

/// Yemek tarifi CRUD işlemlerini yöneten Notifier.
class RecipeNotifier extends AsyncNotifier<void> {
  RecipeRepository get _repo => ref.read(recipeRepositoryProvider);
  String get _familyId => ref.read(activeFamilyIdProvider);
  String? get _uid => ref.read(firebaseAuthProvider).currentUser?.uid;

  @override
  Future<void> build() async {}

  /// Yeni tarif ekler.
  Future<void> addRecipe(RecipeModel recipe) async {
    final uid = _uid;
    if (uid == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final newRecipe = recipe.copyWith(
        familyId: _familyId,
        createdBy: uid,
      );
      await _repo.addRecipe(newRecipe);
    });
  }

  /// Var olan tarifi günceller.
  Future<void> updateRecipe(RecipeModel recipe) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.updateRecipe(recipe));
  }

  /// Tarifi siler.
  Future<void> deleteRecipe(String recipeId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.deleteRecipe(_familyId, recipeId));
  }
}

final recipeNotifierProvider =
    AsyncNotifierProvider<RecipeNotifier, void>(RecipeNotifier.new);
