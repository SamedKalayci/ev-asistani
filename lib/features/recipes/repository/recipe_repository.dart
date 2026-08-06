import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/firestore_service.dart';
import '../models/recipe_model.dart';

/// Yemek tarifleri Firestore CRUD ve real-time stream işlemlerini yöneten repository.
class RecipeRepository {
  RecipeRepository(this._firestoreService);

  final FirestoreService _firestoreService;

  CollectionReference<Map<String, dynamic>> _col(String familyId) =>
      _firestoreService.recipeItemsRef(familyId);

  // ── Stream / Real-time ────────────────────────────────────────────────────

  /// [familyId]'e ait tarifleri gerçek zamanlı dinler (tarihe göre azalan).
  Stream<List<RecipeModel>> watchRecipes(String familyId) {
    return _col(familyId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RecipeModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Tek bir tarifi gerçek zamanlı dinler.
  Stream<RecipeModel?> watchRecipe(String familyId, String recipeId) {
    return _col(familyId).doc(recipeId).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return null;
      return RecipeModel.fromMap(snapshot.data()!, snapshot.id);
    });
  }

  // ── Yazma İşlemleri ───────────────────────────────────────────────────────

  /// Yeni tarif ekler.
  Future<String> addRecipe(RecipeModel recipe) async {
    final data = recipe.toMap();
    data['createdAt'] = FieldValue.serverTimestamp();
    final ref = await _col(recipe.familyId).add(data);
    return ref.id;
  }

  /// Var olan tarifi günceller.
  Future<void> updateRecipe(RecipeModel recipe) {
    final data = {
      'title': recipe.title,
      'description': recipe.description,
      'category': recipe.category,
      'prepTimeMinutes': recipe.prepTimeMinutes,
      'cookTimeMinutes': recipe.cookTimeMinutes,
      'servings': recipe.servings,
      'imageUrl': recipe.imageUrl,
      'ingredients': recipe.ingredients.map((i) => i.toMap()).toList(),
      'instructions': recipe.instructions,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    return _col(recipe.familyId).doc(recipe.id).update(data);
  }

  /// Tarifi siler.
  Future<void> deleteRecipe(String familyId, String recipeId) =>
      _col(familyId).doc(recipeId).delete();
}
