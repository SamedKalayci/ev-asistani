import 'package:cloud_firestore/cloud_firestore.dart';

enum PaymentScheduleGroup {
  overdue,
  thisMonth,
  nextMonth;

  static PaymentScheduleGroup fromDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate.isBefore(today)) {
      return PaymentScheduleGroup.overdue;
    } else if (targetDate.year == today.year && targetDate.month == today.month) {
      return PaymentScheduleGroup.thisMonth;
    } else {
      return PaymentScheduleGroup.nextMonth;
    }
  }
}

class PaymentScheduleModel {
  final String id;
  final String familyId;
  final String title;
  final double amount;
  final DateTime date;
  final String? accountId;
  final String? accountName;
  final bool isIncome;
  final bool isPaid;
  final String? recurringGroupId;
  final String createdBy;
  final DateTime? createdAt;

  const PaymentScheduleModel({
    required this.id,
    required this.familyId,
    required this.title,
    required this.amount,
    required this.date,
    this.accountId,
    this.accountName,
    required this.isIncome,
    this.isPaid = false,
    this.recurringGroupId,
    required this.createdBy,
    this.createdAt,
  });

  PaymentScheduleGroup get group => PaymentScheduleGroup.fromDate(date);

  factory PaymentScheduleModel.fromMap(Map<String, dynamic> map, String docId) {
    return PaymentScheduleModel(
      id: docId,
      familyId: (map['familyId'] as String?) ?? '',
      title: (map['title'] as String?) ?? '',
      amount: ((map['amount'] as num?) ?? 0).toDouble(),
      date: (map['date'] as Timestamp).toDate(),
      accountId: map['accountId'] as String?,
      accountName: map['accountName'] as String?,
      isIncome: (map['isIncome'] as bool?) ?? false,
      isPaid: (map['isPaid'] as bool?) ?? false,
      recurringGroupId: map['recurringGroupId'] as String?,
      createdBy: (map['createdBy'] as String?) ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'familyId': familyId,
      'title': title,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'accountId': accountId,
      'accountName': accountName,
      'isIncome': isIncome,
      'isPaid': isPaid,
      'recurringGroupId': recurringGroupId,
      'createdBy': createdBy,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  PaymentScheduleModel copyWith({
    String? id,
    String? familyId,
    String? title,
    double? amount,
    DateTime? date,
    String? accountId,
    String? accountName,
    bool? isIncome,
    bool? isPaid,
    String? recurringGroupId,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return PaymentScheduleModel(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      accountId: accountId ?? this.accountId,
      accountName: accountName ?? this.accountName,
      isIncome: isIncome ?? this.isIncome,
      isPaid: isPaid ?? this.isPaid,
      recurringGroupId: recurringGroupId ?? this.recurringGroupId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
