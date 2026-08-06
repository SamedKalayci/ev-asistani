import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore `families/{familyId}` dökümanını temsil eden model.
class FamilyModel {
  const FamilyModel({
    required this.familyId,
    required this.familyName,
    required this.inviteCode,
    required this.memberUids,
    this.createdAt,
    this.createdBy,
    this.isPremium = false,
  });

  /// Firestore döküman ID'si.
  final String familyId;

  /// Ailenin görünen adı (örn. "Yılmaz Ailesi").
  final String familyName;

  /// Aileye katılım için paylaşılabilir 6 haneli benzersiz davet kodu (örn. "AB12CD").
  final String inviteCode;

  /// Aile üyelerinin UID listesi.
  final List<String> memberUids;

  /// Ailenin oluşturulma tarihi.
  final DateTime? createdAt;

  /// Aileyi oluşturan/ev sahibi kullanıcının UID'si.
  final String? createdBy;

  /// Ailedeki herhangi bir üyenin PRO üyelik durumu.
  /// Bir üye PRO satın aldığında tüm aile üyeleri PRO sayılır.
  final bool isPremium;

  // ── Takma adlar / Getters ──────────────────────────────────────────────────

  String get id => familyId;
  String get name => familyName;
  String get ownerId => createdBy ?? '';
  List<String> get memberIds => memberUids;
  int get memberCount => memberUids.length;

  bool isOwner(String uid) => createdBy == uid;

  // ── Fabrika Metodları ─────────────────────────────────────────────────────

  /// Firestore dökümanından model oluşturur.
  factory FamilyModel.fromMap(Map<String, dynamic> map, String docId) {
    final members = (map['memberUids'] as List<dynamic>?) ??
        (map['memberIds'] as List<dynamic>?) ??
        [];

    return FamilyModel(
      familyId: docId,
      familyName: (map['familyName'] as String?) ?? (map['name'] as String?) ?? 'Evim',
      inviteCode: (map['inviteCode'] as String?) ?? '',
      memberUids: members.map((e) => e.toString()).toList(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      createdBy: (map['createdBy'] as String?) ?? (map['ownerId'] as String?),
      isPremium: (map['isPremium'] as bool?) ?? false,
    );
  }

  /// 6 haneli rastgele benzersiz davet kodu üretir (örn: "X8K9P2").
  static String generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  // ── Serialization ─────────────────────────────────────────────────────────

  /// Firestore'a yazılacak `Map<String, dynamic>` döner.
  Map<String, dynamic> toMap() {
    return {
      'familyId': familyId,
      'familyName': familyName,
      'name': familyName,
      'inviteCode': inviteCode.toUpperCase(),
      'memberUids': memberUids,
      'memberIds': memberUids,
      'createdBy': createdBy,
      'ownerId': createdBy,
      'isPremium': isPremium,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  // ── CopyWith ──────────────────────────────────────────────────────────────

  FamilyModel copyWith({
    String? familyId,
    String? familyName,
    String? inviteCode,
    List<String>? memberUids,
    DateTime? createdAt,
    String? createdBy,
    bool? isPremium,
  }) {
    return FamilyModel(
      familyId: familyId ?? this.familyId,
      familyName: familyName ?? this.familyName,
      inviteCode: inviteCode ?? this.inviteCode,
      memberUids: memberUids ?? this.memberUids,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  // ── Yardımcılar ───────────────────────────────────────────────────────────

  /// Verilen UID'nin ailenin üyesi olup olmadığını döner.
  bool hasMember(String uid) => memberUids.contains(uid);

  @override
  String toString() =>
      'FamilyModel(familyId: $familyId, familyName: $familyName, '
      'inviteCode: $inviteCode, memberCount: $memberCount)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FamilyModel &&
          runtimeType == other.runtimeType &&
          familyId == other.familyId;

  @override
  int get hashCode => familyId.hashCode;
}
