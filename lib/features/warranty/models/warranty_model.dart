import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

// ── Enums ─────────────────────────────────────────────────────────────────────

enum WarrantyStatusFilter { all, active, upcoming, expired }

enum WarrantyStatus { active, upcoming, expired }

// ── Status Hesaplama ──────────────────────────────────────────────────────────

class WarrantyStatusInfo {
  const WarrantyStatusInfo({
    required this.status,
    required this.statusText,
    required this.statusColor,
    required this.remainingText,
    required this.progress,
  });

  final WarrantyStatus status;
  final String statusText;
  final Color statusColor;

  /// Kalan süreyi türkçe metin olarak döner.
  final String remainingText;

  /// Garanti kullanım yüzdesi (0.0 → 1.0).
  final double progress;
}

/// [purchaseDate] ve [warrantyEndDate] farkından durum hesaplar.
WarrantyStatusInfo computeWarrantyStatus(
  DateTime purchaseDate,
  DateTime warrantyEndDate,
) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final pDate = DateTime(purchaseDate.year, purchaseDate.month, purchaseDate.day);
  final wDate = DateTime(warrantyEndDate.year, warrantyEndDate.month, warrantyEndDate.day);

  final totalDays = wDate.difference(pDate).inDays;
  final elapsedDays = today.difference(pDate).inDays;
  final remainingDays = wDate.difference(today).inDays;

  final progress =
      (totalDays > 0 ? (elapsedDays / totalDays).clamp(0.0, 1.0) : 1.0)
          .toDouble();

  if (remainingDays < 0) {
    return WarrantyStatusInfo(
      status: WarrantyStatus.expired,
      statusText: 'Süresi Doldu',
      statusColor: AppColors.error,
      remainingText: 'Süresi Doldu',
      progress: 1.0,
    );
  } else if (remainingDays <= 60) {
    final months = (remainingDays / 30).floor();
    final days = remainingDays % 30;
    final text = months > 0
        ? '$months Ay${days > 0 ? ', $days Gün' : ''} Kaldı'
        : '$days Gün Kaldı';
    return WarrantyStatusInfo(
      status: WarrantyStatus.upcoming,
      statusText: 'Yaklaşıyor',
      statusColor: AppColors.tertiary,
      remainingText: text,
      progress: progress,
    );
  } else {
    final years = (remainingDays / 365).floor();
    final months = ((remainingDays % 365) / 30).floor();
    final text = years > 0
        ? '$years Yıl${months > 0 ? ', $months Ay' : ''} Kaldı'
        : '$months Ay Kaldı';
    return WarrantyStatusInfo(
      status: WarrantyStatus.active,
      statusText: 'Aktif',
      statusColor: AppColors.primary,
      remainingText: text,
      progress: progress,
    );
  }
}

// ── WarrantyModel ─────────────────────────────────────────────────────────────

/// Firestore `families/{familyId}/warrantyItems/{docId}` dökümanını temsil eder.
class WarrantyModel {
  const WarrantyModel({
    required this.id,
    required this.familyId,
    required this.name,
    required this.brand,
    required this.store,
    required this.purchaseDate,
    required this.warrantyEndDate,
    required this.icon,
    required this.createdBy,
    this.hasInvoice = false,
    this.invoiceNumber,
    this.invoiceUrl,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String familyId;
  final String name;
  final String brand;
  final String store;
  final DateTime purchaseDate;
  final DateTime warrantyEndDate;
  final IconData icon;
  final String createdBy;
  final bool hasInvoice;
  final String? invoiceNumber;
  final String? invoiceUrl;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // ── Türetilmiş Alanlar ────────────────────────────────────────────────────

  WarrantyStatusInfo get statusInfo =>
      computeWarrantyStatus(purchaseDate, warrantyEndDate);

  WarrantyStatus get status => statusInfo.status;
  String get statusText => statusInfo.statusText;
  Color get statusColor => statusInfo.statusColor;
  String get remainingText => statusInfo.remainingText;
  double get progress => statusInfo.progress;

  String get purchaseDateText => _formatDate(purchaseDate);
  String get warrantyEndDateText => _formatDate(warrantyEndDate);

  static String _formatDate(DateTime d) {
    const months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  // ── Serialization ─────────────────────────────────────────────────────────

  factory WarrantyModel.fromMap(Map<String, dynamic> map, String docId) {
    return WarrantyModel(
      id: docId,
      familyId: (map['familyId'] as String?) ?? '',
      name: (map['name'] as String?) ?? '',
      brand: (map['brand'] as String?) ?? '',
      store: (map['store'] as String?) ?? '',
      purchaseDate:
          (map['purchaseDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      warrantyEndDate:
          (map['warrantyEndDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      // ignore: non_const_argument_for_const_parameter
      icon: IconData(
        // ignore: non_const_argument_for_const_parameter
        (map['iconCodePoint'] as int?) ?? Icons.devices_rounded.codePoint,
        fontFamily: 'MaterialIcons',
      ),
      createdBy: (map['createdBy'] as String?) ?? '',
      hasInvoice: (map['hasInvoice'] as bool?) ?? false,
      invoiceNumber: map['invoiceNumber'] as String?,
      invoiceUrl: map['invoiceUrl'] as String?,
      notes: map['notes'] as String?,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'familyId': familyId,
      'name': name,
      'brand': brand,
      'store': store,
      'purchaseDate': Timestamp.fromDate(purchaseDate),
      'warrantyEndDate': Timestamp.fromDate(warrantyEndDate),
      'iconCodePoint': icon.codePoint,
      'createdBy': createdBy,
      'hasInvoice': hasInvoice,
      'invoiceNumber': invoiceNumber,
      'invoiceUrl': invoiceUrl,
      'notes': notes,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // ── CopyWith ──────────────────────────────────────────────────────────────

  WarrantyModel copyWith({
    String? id,
    String? familyId,
    String? name,
    String? brand,
    String? store,
    DateTime? purchaseDate,
    DateTime? warrantyEndDate,
    IconData? icon,
    String? createdBy,
    bool? hasInvoice,
    String? invoiceNumber,
    String? invoiceUrl,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WarrantyModel(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      store: store ?? this.store,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      warrantyEndDate: warrantyEndDate ?? this.warrantyEndDate,
      icon: icon ?? this.icon,
      createdBy: createdBy ?? this.createdBy,
      hasInvoice: hasInvoice ?? this.hasInvoice,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      invoiceUrl: invoiceUrl ?? this.invoiceUrl,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WarrantyModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'WarrantyModel(id: $id, name: $name, brand: $brand, '
      'status: ${status.name}, familyId: $familyId)';
}
