import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

// ── Enums (UI katmanı da import eder) ────────────────────────────────────────

enum ExpirationStatusFilter { all, expired, critical, upcoming, safe }

enum ExpirationStatus { expired, critical, upcoming, safe }

// ── Status Hesaplama Yardımcısı ──────────────────────────────────────────────

/// Firestore'dan gelen [expirationDate] tarihine göre UI durum bilgilerini
/// hesaplar.
ExpirationStatusInfo computeStatus(DateTime expirationDate) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(expirationDate.year, expirationDate.month, expirationDate.day);
  final difference = target.difference(today).inDays;

  if (difference < 0) {
    return const ExpirationStatusInfo(
      status: ExpirationStatus.expired,
      statusText: 'Tarihi Geçti',
      statusColor: AppColors.error,
      daysRemaining: null,
    );
  } else if (difference == 0) {
    return const ExpirationStatusInfo(
      status: ExpirationStatus.critical,
      statusText: 'Bugün Son',
      statusColor: AppColors.error,
      daysRemaining: 0,
    );
  } else if (difference <= 7) {
    return ExpirationStatusInfo(
      status: ExpirationStatus.upcoming,
      statusText: '$difference Gün Kaldı',
      statusColor: AppColors.secondary,
      daysRemaining: difference,
    );
  } else {
    return ExpirationStatusInfo(
      status: ExpirationStatus.safe,
      statusText: '$difference Gün Kaldı',
      statusColor: AppColors.primary,
      daysRemaining: difference,
    );
  }
}

/// [computeStatus] çıktısını taşıyan immutable veri sınıfı.
class ExpirationStatusInfo {
  const ExpirationStatusInfo({
    required this.status,
    required this.statusText,
    required this.statusColor,
    this.daysRemaining,
  });

  final ExpirationStatus status;
  /// Geriye dönük uyumluluk için Türkçe fallback metin.
  final String statusText;
  final Color statusColor;
  /// null → tarihi geçmiş, 0 → bugün son, pozitif → kalan gün sayısı.
  final int? daysRemaining;
}

// ── ExpirationModel ───────────────────────────────────────────────────────────

/// Firestore `families/{familyId}/expiryItems/{docId}` dökümanını temsil eder.
///
/// [id]       → Firestore döküman ID'si (liste/edit işlemleri için zorunlu)
/// [familyId] → Dökümanın ait olduğu aile — tüm sorgular buna göre filtrelenir
/// [createdBy] → Ürünü ekleyen kullanıcının UID'si
class ExpirationModel {
  const ExpirationModel({
    required this.id,
    required this.familyId,
    required this.title,
    required this.location,
    required this.expirationDate,
    required this.icon,
    required this.createdBy,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.notes,
  });

  final String id;
  final String familyId;
  final String title;
  final String location;
  final DateTime expirationDate;

  /// [Icons] kod noktası (codePoint) olarak saklanır.
  final IconData icon;

  final String createdBy;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// İsteğe bağlı notlar.
  final String? notes;

  // ── Türetilmiş Alanlar ────────────────────────────────────────────────────

  ExpirationStatusInfo get statusInfo => computeStatus(expirationDate);
  ExpirationStatus get status => statusInfo.status;
  String get statusText => statusInfo.statusText;
  String get remainingDaysText => statusInfo.statusText;
  int get remainingDays => expirationDate.difference(DateTime.now()).inDays;
  Color get statusColor => statusInfo.statusColor;

  String get expirationDateText {
    final d = expirationDate;
    const months = [
      'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
      'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  // ── Serialization ─────────────────────────────────────────────────────────

  factory ExpirationModel.fromMap(Map<String, dynamic> map, String docId) {
    return ExpirationModel(
      id: docId,
      familyId: (map['familyId'] as String?) ?? '',
      title: (map['title'] as String?) ?? '',
      location: (map['location'] as String?) ?? '',
      expirationDate:
          (map['expirationDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      // ignore: non_const_argument_for_const_parameter
      icon: IconData(
        // ignore: non_const_argument_for_const_parameter
        (map['iconCodePoint'] as int?) ?? Icons.label_rounded.codePoint,
        fontFamily: 'MaterialIcons',
      ),
      createdBy: (map['createdBy'] as String?) ?? '',
      imageUrl: map['imageUrl'] as String?,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'familyId': familyId,
      'title': title,
      'location': location,
      'expirationDate': Timestamp.fromDate(expirationDate),
      'iconCodePoint': icon.codePoint,
      'createdBy': createdBy,
      'imageUrl': imageUrl,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'notes': notes,
    };
  }

  // ── CopyWith ──────────────────────────────────────────────────────────────

  ExpirationModel copyWith({
    String? id,
    String? familyId,
    String? title,
    String? location,
    DateTime? expirationDate,
    IconData? icon,
    String? createdBy,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
  }) {
    return ExpirationModel(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      title: title ?? this.title,
      location: location ?? this.location,
      expirationDate: expirationDate ?? this.expirationDate,
      icon: icon ?? this.icon,
      createdBy: createdBy ?? this.createdBy,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpirationModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ExpirationModel(id: $id, title: $title, familyId: $familyId, '
      'expirationDate: $expirationDate, status: ${status.name})';
}
