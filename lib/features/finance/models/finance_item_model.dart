import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

/// Finans işlem türü: Gelir (income) veya Gider (expense).
enum FinanceType {
  income,
  expense;

  String get label {
    switch (this) {
      case FinanceType.income:
        return 'Gelir';
      case FinanceType.expense:
        return 'Gider';
    }
  }

  static FinanceType fromString(String? value) {
    if (value == null) return FinanceType.expense;
    switch (value.toLowerCase()) {
      case 'income':
        return FinanceType.income;
      case 'expense':
      default:
        return FinanceType.expense;
    }
  }
}

/// Finans kategorisi: 6 Ana Ev Cüzdanı Kategorisi + Genel Bakış Kategorileri.
enum FinanceCategory {
  diningOut,
  kitchenGrocery,
  homeBills,
  shoppingPersonal,
  transport,
  entertainmentSubscriptions,
  other,

  // Eski / Özel Kategoriler (Geriye Dönük Uyumluluk İçin)
  rent,
  bill,
  subscription,
  general,
  food,
  grocery,
  home,
  shopping,
  entertainment,
  health,
  pet,
  walletTotal;

  static const List<FinanceCategory> walletCategories = [
    diningOut,
    kitchenGrocery,
    homeBills,
    shoppingPersonal,
    transport,
    entertainmentSubscriptions,
    other,
  ];

  String getLocalizedLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case FinanceCategory.diningOut:
        return l10n.categoryDiningOut;
      case FinanceCategory.kitchenGrocery:
      case FinanceCategory.food:
      case FinanceCategory.grocery:
        return l10n.categoryKitchenGrocery;
      case FinanceCategory.homeBills:
      case FinanceCategory.home:
      case FinanceCategory.rent:
      case FinanceCategory.bill:
        return l10n.categoryHomeBills;
      case FinanceCategory.shoppingPersonal:
      case FinanceCategory.shopping:
      case FinanceCategory.health:
        return l10n.categoryShoppingPersonal;
      case FinanceCategory.transport:
        return l10n.categoryTransport;
      case FinanceCategory.entertainmentSubscriptions:
      case FinanceCategory.entertainment:
      case FinanceCategory.subscription:
      case FinanceCategory.pet:
        return l10n.categoryEntertainmentSubscriptions;
      case FinanceCategory.other:
      case FinanceCategory.general:
        return l10n.categoryOther;
      case FinanceCategory.walletTotal:
        return l10n.householdWalletTab;
    }
  }

  String get label {
    switch (this) {
      case FinanceCategory.diningOut:
        return 'Yeme / İçme';
      case FinanceCategory.kitchenGrocery:
      case FinanceCategory.food:
      case FinanceCategory.grocery:
        return 'Mutfak & Market';
      case FinanceCategory.homeBills:
      case FinanceCategory.home:
      case FinanceCategory.rent:
      case FinanceCategory.bill:
        return 'Ev & Faturalar';
      case FinanceCategory.shoppingPersonal:
      case FinanceCategory.shopping:
      case FinanceCategory.health:
        return 'Alışveriş & Kişisel';
      case FinanceCategory.transport:
        return 'Ulaşım';
      case FinanceCategory.entertainmentSubscriptions:
      case FinanceCategory.entertainment:
      case FinanceCategory.subscription:
      case FinanceCategory.pet:
        return 'Eğlence & Abonelikler';
      case FinanceCategory.other:
      case FinanceCategory.general:
        return 'Diğer';
      case FinanceCategory.walletTotal:
        return 'Ev Cüzdanı Toplamı';
    }
  }

  IconData get icon {
    switch (this) {
      case FinanceCategory.diningOut:
        return Icons.flatware_rounded;
      case FinanceCategory.kitchenGrocery:
      case FinanceCategory.food:
      case FinanceCategory.grocery:
        return Icons.restaurant_outlined;
      case FinanceCategory.homeBills:
      case FinanceCategory.home:
      case FinanceCategory.rent:
      case FinanceCategory.bill:
        return Icons.home_work_outlined;
      case FinanceCategory.shoppingPersonal:
      case FinanceCategory.shopping:
      case FinanceCategory.health:
        return Icons.shopping_bag_outlined;
      case FinanceCategory.transport:
        return Icons.directions_car_outlined;
      case FinanceCategory.entertainmentSubscriptions:
      case FinanceCategory.entertainment:
      case FinanceCategory.subscription:
      case FinanceCategory.pet:
        return Icons.local_activity_outlined;
      case FinanceCategory.other:
      case FinanceCategory.general:
        return Icons.more_horiz_outlined;
      case FinanceCategory.walletTotal:
        return Icons.account_balance_wallet_outlined;
    }
  }

  static FinanceCategory fromString(String? value) {
    if (value == null) return FinanceCategory.other;
    switch (value.toLowerCase()) {
      case 'diningout':
      case 'dining':
        return FinanceCategory.diningOut;
      case 'kitchengrocery':
      case 'food':
      case 'grocery':
        return FinanceCategory.kitchenGrocery;
      case 'homebills':
      case 'rent':
      case 'bill':
      case 'home':
        return FinanceCategory.homeBills;
      case 'shoppingpersonal':
      case 'shopping':
      case 'health':
        return FinanceCategory.shoppingPersonal;
      case 'transport':
        return FinanceCategory.transport;
      case 'entertainmentsubscriptions':
      case 'entertainment':
      case 'subscription':
      case 'pet':
        return FinanceCategory.entertainmentSubscriptions;
      case 'other':
      case 'general':
      default:
        return FinanceCategory.other;
    }
  }
}

/// Firestore `families/{familyId}/financeItems` döküman modeli.
class FinanceItemModel {
  final String id;
  final String familyId;
  final String title;
  final double amount;
  final FinanceType type;
  final FinanceCategory category;
  final DateTime? dueDate;
  final bool isRecurring;
  final bool isPaid;
  final bool isWalletExpense;
  final String createdBy;
  final DateTime? createdAt;

  const FinanceItemModel({
    required this.id,
    required this.familyId,
    required this.title,
    required this.amount,
    required this.type,
    this.category = FinanceCategory.general,
    this.dueDate,
    this.isRecurring = false,
    this.isPaid = false,
    this.isWalletExpense = false,
    required this.createdBy,
    this.createdAt,
  });

  /// Kalan gün sayısı metni (örn: "3 Gün Kaldı", "Bugün", "Günü Geçti").
  String get remainingDaysText {
    if (dueDate == null) return 'Tarih Yok';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);

    final difference = due.difference(today).inDays;

    if (difference < 0) {
      return '${difference.abs()} Gün Geçti';
    } else if (difference == 0) {
      return 'Bugün Son';
    } else {
      return '$difference Gün Kaldı';
    }
  }

  /// DD MMM YYYY formatında net tarih metni (örn: "10 Ağu 2026").
  String get formattedDueDate {
    if (dueDate == null) return 'Tarih Yok';
    const months = [
      'Oca',
      'Şub',
      'Mar',
      'Nıs',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Ekim',
      'Kas',
      'Ara'
    ];
    return '${dueDate!.day} ${months[dueDate!.month - 1]} ${dueDate!.year}';
  }

  /// Net tarih ve kalan gün kombinasyonu (örn: "10 Ağu 2026 (7 Gün Kaldı)").
  String get formattedDueDateWithRemaining {
    if (dueDate == null) return 'Tarih Yok';
    return '$formattedDueDate ($remainingDaysText)';
  }

  factory FinanceItemModel.fromMap(Map<String, dynamic> map, String docId) {
    return FinanceItemModel(
      id: docId,
      familyId: (map['familyId'] as String?) ?? '',
      title: (map['title'] as String?) ?? '',
      amount: ((map['amount'] as num?) ?? 0).toDouble(),
      type: FinanceType.fromString(map['type'] as String?),
      category: FinanceCategory.fromString(map['category'] as String?),
      dueDate: (map['dueDate'] as Timestamp?)?.toDate(),
      isRecurring: (map['isRecurring'] as bool?) ?? false,
      isPaid: (map['isPaid'] as bool?) ?? false,
      isWalletExpense: (map['isWalletExpense'] as bool?) ?? false,
      createdBy: (map['createdBy'] as String?) ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'familyId': familyId,
      'title': title,
      'amount': amount,
      'type': type.name,
      'category': category.name,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'isRecurring': isRecurring,
      'isPaid': isPaid,
      'isWalletExpense': isWalletExpense,
      'createdBy': createdBy,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  FinanceItemModel copyWith({
    String? id,
    String? familyId,
    String? title,
    double? amount,
    FinanceType? type,
    FinanceCategory? category,
    DateTime? dueDate,
    bool? isRecurring,
    bool? isPaid,
    bool? isWalletExpense,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return FinanceItemModel(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      isRecurring: isRecurring ?? this.isRecurring,
      isPaid: isPaid ?? this.isPaid,
      isWalletExpense: isWalletExpense ?? this.isWalletExpense,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
