import 'package:cloud_firestore/cloud_firestore.dart';

/// Kullanıcı rolünü temsil eden enum.
enum UserRole {
  owner,
  admin,
  member;

  String get label {
    switch (this) {
      case UserRole.owner:
        return 'Ev Sahibi';
      case UserRole.admin:
        return 'Yönetici';
      case UserRole.member:
        return 'Üye';
    }
  }
}

/// Kullanıcı profil avatar türü.
enum AvatarType {
  presetAvatar,
  emoji,
  customImage;

  /// Null-safe ve esnek string/dynamic parser.
  static AvatarType fromString(dynamic value) {
    if (value == null) return AvatarType.presetAvatar;
    final str = value.toString();
    return AvatarType.values.firstWhere(
      (e) => e.name == str || e.toString() == str || e.toString() == 'AvatarType.$str',
      orElse: () => AvatarType.presetAvatar,
    );
  }
}

/// Firestore `users/{uid}` dökümanını temsil eden model.
class UserModel {
  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.avatarUrl,
    this.avatarType = AvatarType.presetAvatar,
    this.familyId,
    this.role = UserRole.member,
    this.createdAt,
    this.isPremium = false,
    this.familyRole,
  });

  /// Firebase Auth UID'si — döküman kimliği ile aynı.
  final String uid;

  /// Kullanıcı adı (display name).
  final String name;

  /// Kullanıcıya ait e-posta adresi.
  final String email;

  /// Kullanıcının legacy Google/Firebase profil fotoğrafı URL'si.
  final String? photoUrl;

  /// Kullanıcının seçtiği yeni avatar/görsel/emoji verisi.
  final String? avatarUrl;

  /// Profil görseli türü: presetAvatar, emoji veya customImage (Nullable yapıldı).
  final AvatarType? avatarType;

  /// Kullanıcının ait olduğu aile ID'si. Henüz aile oluşturulmamışsa `null`.
  final String? familyId;

  /// Ailede üstlenilen rol: `owner`, `admin` veya `member`.
  final UserRole role;

  /// Hesap oluşturulma zamanı.
  final DateTime? createdAt;

  /// Kullanıcının bireysel PRO üyelik durumu.
  final bool isPremium;

  /// Aile içi rol seçimi (Örn: Anne, Baba, Çocuk, Ev Sahibi vb.)
  final String? familyRole;

  // ── Takma adlar / Getters ──────────────────────────────────────────────────

  String get id => uid;
  String get displayName => name.isNotEmpty ? name : (email.isNotEmpty ? email.split('@').first : '');
  bool get isAnonymous => name.isEmpty && email.isEmpty;
  bool get isOwner => role == UserRole.owner || role == UserRole.admin;

  /// Kesinlikle null dönmeyen güvenli avatarType getter'ı.
  AvatarType get safeAvatarType => avatarType ?? AvatarType.presetAvatar;

  /// Görüntülenecek en etkili profil görseli / avatar URL'si veya emoji string'i.
  String? get effectiveAvatarUrl =>
      (avatarUrl != null && avatarUrl!.isNotEmpty) ? avatarUrl : photoUrl;

  // ── Fabrika Metodları ─────────────────────────────────────────────────────

  /// Firestore dökümanından model oluşturur (Kesin null-safety korumalı).
  factory UserModel.fromMap(Map<String, dynamic> map, String docId) {
    return UserModel(
      uid: docId,
      name: (map['name'] as String?) ?? (map['displayName'] as String?) ?? '',
      email: (map['email'] as String?) ?? '',
      photoUrl: map['photoUrl'] as String?,
      avatarUrl: map['avatarUrl'] as String?,
      avatarType: _parseAvatarType(map['avatarType']),
      familyId: map['familyId'] as String?,
      role: _roleFromString(map['role'] as String?),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      isPremium: (map['isPremium'] as bool?) ?? false,
      familyRole: map['familyRole'] as String?,
    );
  }

  /// Güvenli AvatarType parser yardımcı metodu.
  static AvatarType _parseAvatarType(dynamic value) {
    if (value == null) return AvatarType.presetAvatar;
    final str = value.toString();
    return AvatarType.values.firstWhere(
      (e) => e.name == str || e.toString() == str || e.toString() == 'AvatarType.$str',
      orElse: () => AvatarType.presetAvatar,
    );
  }

  /// Firebase Auth kullanıcısından minimal bir UserModel oluşturur.
  factory UserModel.fromAuth({
    required String uid,
    String name = '',
    String email = '',
    String? photoUrl,
    String? avatarUrl,
    AvatarType avatarType = AvatarType.presetAvatar,
  }) {
    return UserModel(
      uid: uid,
      name: name,
      email: email,
      photoUrl: photoUrl,
      avatarUrl: avatarUrl,
      avatarType: avatarType,
    );
  }

  // ── Serialization ─────────────────────────────────────────────────────────

  /// Firestore'a yazılacak `Map<String, dynamic>` döner.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'displayName': name,
      'email': email,
      'photoUrl': photoUrl,
      'avatarUrl': avatarUrl,
      'avatarType': safeAvatarType.name,
      'familyId': familyId,
      'role': role.name,
      'isPremium': isPremium,
      'familyRole': familyRole,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  // ── CopyWith ──────────────────────────────────────────────────────────────

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
    String? avatarUrl,
    AvatarType? avatarType,
    String? familyId,
    UserRole? role,
    DateTime? createdAt,
    bool? isPremium,
    String? familyRole,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarType: avatarType ?? this.avatarType,
      familyId: familyId ?? this.familyId,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      isPremium: isPremium ?? this.isPremium,
      familyRole: familyRole ?? this.familyRole,
    );
  }

  // ── Yardımcılar ───────────────────────────────────────────────────────────

  /// Kullanıcının gerçek bir aileye üye olup olmadığını döner.
  bool get hasFamilyId => familyId != null && familyId!.isNotEmpty;

  @override
  String toString() =>
      'UserModel(uid: $uid, name: $name, email: $email, avatarType: ${safeAvatarType.name}, familyId: $familyId)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel && runtimeType == other.runtimeType && uid == other.uid;

  @override
  int get hashCode => uid.hashCode;
}

UserRole _roleFromString(String? value) {
  if (value == null) return UserRole.member;
  switch (value.toLowerCase()) {
    case 'owner':
      return UserRole.owner;
    case 'admin':
      return UserRole.admin;
    case 'member':
    default:
      return UserRole.member;
  }
}
