import 'package:flutter/material.dart';
import '../models/user_model.dart';

/// Kullanıcı profil avatarını (Network Görsel, Asset PNG, Emoji veya İsim Baş harfi)
/// güvenli ve düzgün bir şekilde gösteren dairesel avatar bileşeni.
class UserAvatar extends StatelessWidget {
  final UserModel? user;
  final String? avatarUrl;
  final AvatarType? avatarType;
  final String? photoUrl;
  final String? displayName;
  final double radius;
  final Color? backgroundColor;

  const UserAvatar({
    super.key,
    this.user,
    this.avatarUrl,
    this.avatarType,
    this.photoUrl,
    this.displayName,
    this.radius = 24.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveUser = user;

    final String url = effectiveUser?.effectiveAvatarUrl ??
        (avatarUrl != null && avatarUrl!.isNotEmpty
            ? avatarUrl!
            : (photoUrl ?? ''));

    final AvatarType type = effectiveUser?.safeAvatarType ??
        (avatarType ?? AvatarType.presetAvatar);

    final String name = effectiveUser?.displayName ?? (displayName ?? '');
    final String initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    final bool isEmoji = type == AvatarType.emoji && url.isNotEmpty;
    final bool isNetworkImage =
        (url.startsWith('http://') || url.startsWith('https://')) && !isEmoji;
    final bool isLocalAsset = url.startsWith('assets/') && !isEmoji;

    final double diameter = radius * 2;
    final Color bgColor = backgroundColor ?? colorScheme.primaryContainer;

    if (isNetworkImage) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: bgColor,
        backgroundImage: NetworkImage(url),
        onBackgroundImageError: (exception, stackTrace) {},
      );
    }

    if (isLocalAsset) {
      return Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor,
        ),
        child: ClipOval(
          child: Image.asset(
            url,
            width: diameter,
            height: diameter,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Center(
              child: Text(
                initial,
                style: TextStyle(
                  fontSize: radius * 0.8,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (isEmoji) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: bgColor,
        child: Text(
          url,
          style: TextStyle(fontSize: radius * 0.9),
        ),
      );
    }

    // Varsayılan İsim Baş Harfi Gösterimi
    return CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      child: Text(
        initial,
        style: TextStyle(
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
