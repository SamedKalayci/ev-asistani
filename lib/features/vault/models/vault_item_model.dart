import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Dijital Ev Kasası (Vault) döküman modeli.
class VaultItemModel {
  final String id;
  final String familyId;
  final String category; // 'documents', 'emergency', 'maintenance', 'guide'
  final String? subCategory; // 'wifi', 'installation', 'passwords', 'general'
  final String title;
  final String description;
  final String? fileUrl;
  final String? phoneNumber;
  final DateTime? dueDate;
  final bool isCompleted;
  final String? wifiName;
  final String? wifiPassword; // Kopyalanabilir Değer / Şifre / Abone No
  final int? iconCode;
  final String createdBy;
  final DateTime? createdAt;

  const VaultItemModel({
    required this.id,
    required this.familyId,
    required this.category,
    this.subCategory,
    required this.title,
    required this.description,
    this.fileUrl,
    this.phoneNumber,
    this.dueDate,
    this.isCompleted = false,
    this.wifiName,
    this.wifiPassword,
    this.iconCode,
    required this.createdBy,
    this.createdAt,
  });

  IconData get icon {
    if (iconCode != null) {
      // ignore: non_const_argument_for_const_parameter
      return IconData(iconCode!, fontFamily: 'MaterialIcons');
    }
    switch (category) {
      case 'emergency':
        return Icons.phone_in_talk_rounded;
      case 'maintenance':
        return Icons.build_circle_outlined;
      case 'guide':
        switch (subCategory) {
          case 'installation':
            return Icons.flash_on_rounded;
          case 'passwords':
            return Icons.key_rounded;
          case 'general':
            return Icons.home_rounded;
          case 'wifi':
          default:
            return Icons.wifi_rounded;
        }
      case 'documents':
      default:
        return Icons.description_outlined;
    }
  }

  /// Kategori etiket metni.
  String get subCategoryLabel {
    switch (subCategory) {
      case 'installation':
        return '⚡ Tesisat & Abonelik';
      case 'passwords':
        return '🔑 Şifre & Kodlar';
      case 'general':
        return 'ℹ️ Genel Ev Bilgisi';
      case 'wifi':
      default:
        return '📶 Wi-Fi & Ağ';
    }
  }

  /// Kalan gün sayısı metni.
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

  factory VaultItemModel.fromMap(Map<String, dynamic> map, String docId) {
    return VaultItemModel(
      id: docId,
      familyId: (map['familyId'] as String?) ?? '',
      category: (map['category'] as String?) ?? 'documents',
      subCategory: map['subCategory'] as String?,
      title: (map['title'] as String?) ?? '',
      description: (map['description'] as String?) ?? '',
      fileUrl: map['fileUrl'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      dueDate: (map['dueDate'] as Timestamp?)?.toDate(),
      isCompleted: (map['isCompleted'] as bool?) ?? false,
      wifiName: map['wifiName'] as String?,
      wifiPassword: map['wifiPassword'] as String?,
      iconCode: map['iconCode'] as int?,
      createdBy: (map['createdBy'] as String?) ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'familyId': familyId,
      'category': category,
      'subCategory': subCategory,
      'title': title,
      'description': description,
      'fileUrl': fileUrl,
      'phoneNumber': phoneNumber,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'isCompleted': isCompleted,
      'wifiName': wifiName,
      'wifiPassword': wifiPassword,
      'iconCode': iconCode,
      'createdBy': createdBy,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  VaultItemModel copyWith({
    String? id,
    String? familyId,
    String? category,
    String? subCategory,
    String? title,
    String? description,
    String? fileUrl,
    String? phoneNumber,
    DateTime? dueDate,
    bool? isCompleted,
    String? wifiName,
    String? wifiPassword,
    int? iconCode,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return VaultItemModel(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      title: title ?? this.title,
      description: description ?? this.description,
      fileUrl: fileUrl ?? this.fileUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      wifiName: wifiName ?? this.wifiName,
      wifiPassword: wifiPassword ?? this.wifiPassword,
      iconCode: iconCode ?? this.iconCode,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
