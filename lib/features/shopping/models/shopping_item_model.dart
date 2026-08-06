import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore `families/{familyId}/shoppingItems/{docId}` dökümanını temsil eder.
///
/// [isCompleted] → ürün alındı mı (gerçek zamanlı senkronize)
/// [familyId]   → tüm sorgular buna göre filtrelenir (RULES.md)
/// [createdBy]  → ekleyen kullanıcının UID'si
class ShoppingItemModel {
  const ShoppingItemModel({
    required this.id,
    required this.familyId,
    required this.name,
    required this.createdBy,
    this.note,
    this.category,
    this.isCompleted = false,
    this.createdAt,
    this.updatedAt,
    this.completedBy,
  });

  final String id;
  final String familyId;
  final String name;
  final String createdBy;
  final String? note;
  final String? category;
  final bool isCompleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Ürünü tamamlayan kullanıcının UID'si (sadece `isCompleted == true` için).
  final String? completedBy;

  // ── Serialization ─────────────────────────────────────────────────────────

  factory ShoppingItemModel.fromMap(Map<String, dynamic> map, String docId) {
    return ShoppingItemModel(
      id: docId,
      familyId: (map['familyId'] as String?) ?? '',
      name: (map['name'] as String?) ?? '',
      createdBy: (map['createdBy'] as String?) ?? '',
      note: map['note'] as String?,
      category: map['category'] as String?,
      isCompleted: (map['isCompleted'] as bool?) ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
      completedBy: map['completedBy'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'familyId': familyId,
      'name': name,
      'createdBy': createdBy,
      'note': note,
      'category': category,
      'isCompleted': isCompleted,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'completedBy': completedBy,
    };
  }

  // ── CopyWith ──────────────────────────────────────────────────────────────

  ShoppingItemModel copyWith({
    String? id,
    String? familyId,
    String? name,
    String? createdBy,
    String? note,
    String? category,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? completedBy,
  }) {
    return ShoppingItemModel(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      name: name ?? this.name,
      createdBy: createdBy ?? this.createdBy,
      note: note ?? this.note,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedBy: completedBy ?? this.completedBy,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingItemModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ShoppingItemModel(id: $id, name: $name, isCompleted: $isCompleted, '
      'familyId: $familyId)';
}
