import 'package:cloud_firestore/cloud_firestore.dart';
import 'finance_item_model.dart';

/// Firestore `families/{familyId}/budgets` döküman modeli.
class BudgetModel {
  final String id;
  final String familyId;
  final FinanceCategory category;
  final double limitAmount;
  final String createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BudgetModel({
    required this.id,
    required this.familyId,
    required this.category,
    required this.limitAmount,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory BudgetModel.fromMap(Map<String, dynamic> map, String docId) {
    return BudgetModel(
      id: docId,
      familyId: (map['familyId'] as String?) ?? '',
      category: FinanceCategory.fromString(map['category'] as String?),
      limitAmount: ((map['limitAmount'] as num?) ?? 0).toDouble(),
      createdBy: (map['createdBy'] as String?) ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'familyId': familyId,
      'category': category.name,
      'limitAmount': limitAmount,
      'createdBy': createdBy,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  BudgetModel copyWith({
    String? id,
    String? familyId,
    FinanceCategory? category,
    double? limitAmount,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      category: category ?? this.category,
      limitAmount: limitAmount ?? this.limitAmount,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
