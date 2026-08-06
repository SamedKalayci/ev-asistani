import 'package:cloud_firestore/cloud_firestore.dart';

enum AccountType {
  cash,
  bank,
  creditCard,
  debtCredit;

  String get label {
    switch (this) {
      case AccountType.cash:
        return 'Nakit';
      case AccountType.bank:
        return 'Banka';
      case AccountType.creditCard:
        return 'Kredi Kartı';
      case AccountType.debtCredit:
        return 'Cari (Borç/Alacak)';
    }
  }

  static AccountType fromString(String? value) {
    if (value == null) return AccountType.cash;
    switch (value.toLowerCase()) {
      case 'bank':
        return AccountType.bank;
      case 'creditcard':
        return AccountType.creditCard;
      case 'debtcredit':
        return AccountType.debtCredit;
      case 'cash':
      default:
        return AccountType.cash;
    }
  }
}

class AccountModel {
  final String id;
  final String familyId;
  final String title;
  final AccountType type;
  final double balance;
  final String? bankName;
  final String? cutoffDay;
  final double? limit;
  final String? personType; // 'debt' (Borç) or 'credit' (Alacak) for debtCredit accounts
  final String createdBy;
  final DateTime? createdAt;

  const AccountModel({
    required this.id,
    required this.familyId,
    required this.title,
    required this.type,
    required this.balance,
    this.bankName,
    this.cutoffDay,
    this.limit,
    this.personType,
    required this.createdBy,
    this.createdAt,
  });

  factory AccountModel.fromMap(Map<String, dynamic> map, String docId) {
    return AccountModel(
      id: docId,
      familyId: (map['familyId'] as String?) ?? '',
      title: (map['title'] as String?) ?? '',
      type: AccountType.fromString(map['type'] as String?),
      balance: ((map['balance'] as num?) ?? 0).toDouble(),
      bankName: map['bankName'] as String?,
      cutoffDay: map['cutoffDay'] as String?,
      limit: map['limit'] != null ? (map['limit'] as num).toDouble() : null,
      personType: map['personType'] as String?,
      createdBy: (map['createdBy'] as String?) ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'familyId': familyId,
      'title': title,
      'type': type.name,
      'balance': balance,
      'bankName': bankName,
      'cutoffDay': cutoffDay,
      'limit': limit,
      'personType': personType,
      'createdBy': createdBy,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  AccountModel copyWith({
    String? id,
    String? familyId,
    String? title,
    AccountType? type,
    double? balance,
    String? bankName,
    String? cutoffDay,
    double? limit,
    String? personType,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return AccountModel(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      title: title ?? this.title,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      bankName: bankName ?? this.bankName,
      cutoffDay: cutoffDay ?? this.cutoffDay,
      limit: limit ?? this.limit,
      personType: personType ?? this.personType,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
