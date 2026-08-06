import 'package:cloud_firestore/cloud_firestore.dart';

/// Tarif malzemesi modeli.
class RecipeIngredientModel {
  const RecipeIngredientModel({
    required this.name,
    this.amount = '',
    this.unit = '',
    this.isOptional = false,
  });

  final String name;
  final String amount;
  final String unit;
  final bool isOptional;

  /// Ekranda gösterilecek formatlı miktar metni (örn: "2 su bardağı").
  String get displayAmount {
    final parts = [if (amount.isNotEmpty) amount, if (unit.isNotEmpty) unit];
    return parts.join(' ');
  }

  factory RecipeIngredientModel.fromMap(Map<String, dynamic> map) {
    return RecipeIngredientModel(
      name: (map['name'] as String?) ?? '',
      amount: (map['amount'] as String?) ?? '',
      unit: (map['unit'] as String?) ?? '',
      isOptional: (map['isOptional'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'unit': unit,
      'isOptional': isOptional,
    };
  }

  RecipeIngredientModel copyWith({
    String? name,
    String? amount,
    String? unit,
    bool? isOptional,
  }) {
    return RecipeIngredientModel(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      isOptional: isOptional ?? this.isOptional,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeIngredientModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          amount == other.amount &&
          unit == other.unit &&
          isOptional == other.isOptional;

  @override
  int get hashCode =>
      name.hashCode ^ amount.hashCode ^ unit.hashCode ^ isOptional.hashCode;
}

/// Firestore `families/{familyId}/recipes/{docId}` dökümanını temsil eden Yemek Tarifi modeli.
class RecipeModel {
  const RecipeModel({
    required this.id,
    required this.familyId,
    required this.title,
    required this.createdBy,
    this.description,
    this.category = 'Ana Yemek',
    this.prepTimeMinutes = 15,
    this.cookTimeMinutes = 30,
    this.servings = 4,
    this.imageUrl,
    this.ingredients = const [],
    this.instructions = const [],
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String familyId;
  final String title;
  final String createdBy;
  final String? description;
  final String category;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final String? imageUrl;
  final List<RecipeIngredientModel> ingredients;
  final List<String> instructions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Toplam süre (hazırlama + pişirme).
  int get totalTimeMinutes => prepTimeMinutes + cookTimeMinutes;

  factory RecipeModel.fromMap(Map<String, dynamic> map, String docId) {
    final rawIngredients = map['ingredients'] as List<dynamic>? ?? [];
    final rawInstructions = map['instructions'] as List<dynamic>? ?? [];

    return RecipeModel(
      id: docId,
      familyId: (map['familyId'] as String?) ?? '',
      title: (map['title'] as String?) ?? '',
      createdBy: (map['createdBy'] as String?) ?? '',
      description: map['description'] as String?,
      category: (map['category'] as String?) ?? 'Ana Yemek',
      prepTimeMinutes: (map['prepTimeMinutes'] as int?) ?? 15,
      cookTimeMinutes: (map['cookTimeMinutes'] as int?) ?? 30,
      servings: (map['servings'] as int?) ?? 4,
      imageUrl: map['imageUrl'] as String?,
      ingredients: rawIngredients
          .map((i) => RecipeIngredientModel.fromMap(i as Map<String, dynamic>))
          .toList(),
      instructions: rawInstructions.map((i) => i.toString()).toList(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'familyId': familyId,
      'title': title,
      'createdBy': createdBy,
      'description': description,
      'category': category,
      'prepTimeMinutes': prepTimeMinutes,
      'cookTimeMinutes': cookTimeMinutes,
      'servings': servings,
      'imageUrl': imageUrl,
      'ingredients': ingredients.map((i) => i.toMap()).toList(),
      'instructions': instructions,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  RecipeModel copyWith({
    String? id,
    String? familyId,
    String? title,
    String? createdBy,
    String? description,
    String? category,
    int? prepTimeMinutes,
    int? cookTimeMinutes,
    int? servings,
    String? imageUrl,
    List<RecipeIngredientModel>? ingredients,
    List<String>? instructions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      title: title ?? this.title,
      createdBy: createdBy ?? this.createdBy,
      description: description ?? this.description,
      category: category ?? this.category,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
      servings: servings ?? this.servings,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'RecipeModel(id: $id, title: $title, category: $category, familyId: $familyId)';
}
