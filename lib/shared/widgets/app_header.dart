import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import '../../router/app_router.dart';

/// Her ekranda kullanılacak ortak üst başlık (AppHeader) bileşeni.
/// Minimalist tasarım dili, dairesel profil avatarı ve bildirim zili/badge desteğine sahip.
class AppHeader extends ConsumerWidget implements PreferredSizeWidget {
  /// Başlık metni (null veya varsayılan ise localized appName kullanılır)
  final String? title;

  /// Özel başlık widget'ı (title metni yerine geçer)
  final Widget? titleWidget;

  /// Sol taraf widget'ı (profil resmi, logo veya geri butonu vb.)
  final Widget? leading;

  /// Profil resminin otomatik yüklenip yüklenmeyeceği (leading null ise geçerli)
  final bool showUserAvatar;

  /// Profil avatarına tıklandığında çalışacak callback
  final VoidCallback? onAvatarTap;

  /// Sağ taraf aksiyon widget'ları (bildirim butonu vb.)
  final List<Widget>? actions;

  /// Bildirim ikonunun otomatik gösterilip gösterilmeyeceği
  final bool showNotificationBell;

  /// Bildirimlerde okunmamış işareti/rozet gösterilsin mi?
  final bool hasNotificationBadge;

  /// Bildirim ikonuna tıklandığında çalışacak callback
  final VoidCallback? onNotificationTap;

  /// Başlığı ortalama durumu
  final bool centerTitle;

  /// Arka plan rengi
  final Color? backgroundColor;

  /// Alt kenarlık gösterilip gösterilmeyeceği
  final bool showBorder;

  /// Yükseklik offset/ekstra alan için alt widget (ör. TabBar, SearchBar)
  final PreferredSizeWidget? bottom;

  /// Geri butonu otomatik gösterilsin mi?
  final bool automaticallyImplyLeading;

  /// Geri butonuna tıklandığında çalışacak callback
  final VoidCallback? onBackPressed;

  const AppHeader({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.showUserAvatar = true,
    this.onAvatarTap,
    this.actions,
    this.showNotificationBell = false,
    this.hasNotificationBadge = false,
    this.onNotificationTap,
    this.centerTitle = false,
    this.backgroundColor,
    this.showBorder = false,
    this.bottom,
    this.automaticallyImplyLeading = true,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    // ── Sol Taraf (Leading) ──────────────────────────────────────────────────
    Widget? effectiveLeading = leading;

    if (effectiveLeading == null &&
        automaticallyImplyLeading &&
        Navigator.canPop(context)) {
      effectiveLeading = IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        color: colorScheme.onSurface,
        iconSize: 20,
        onPressed: onBackPressed ?? () => Navigator.maybePop(context),
      );
    } else if (effectiveLeading == null && showUserAvatar) {
      effectiveLeading = GestureDetector(
        onTap: onAvatarTap ?? () => context.go(AppRoutes.home),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: AppShadows.xs,
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/icon/app_logo.png',
              width: 36,
              height: 36,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    // ── Başlık ───────────────────────────────────────────────────────────────
    Widget? effectiveTitle;
    if (titleWidget != null) {
      effectiveTitle = titleWidget;
    } else {
      final String displayTitle = (title != null && title != 'Ev Asistanı')
          ? title!
          : (l10n?.appName ?? 'Ev Asistanı');

      effectiveTitle = Text(
        displayTitle,
        style: AppTypography.titleLarge.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      );
    }

    // ── Sağ Taraf (Actions) ──────────────────────────────────────────────────
    List<Widget> effectiveActions = [];
    if (actions != null) {
      effectiveActions.addAll(actions!);
      effectiveActions.add(const SizedBox(width: AppSpacing.sm));
    }

    return AppBar(
      title: effectiveTitle,
      centerTitle: centerTitle,
      leading: effectiveLeading != null
          ? Padding(
              padding: const EdgeInsets.only(left: AppSpacing.md),
              child: Center(child: effectiveLeading),
            )
          : null,
      leadingWidth: effectiveLeading != null ? 52 : null,
      actions: effectiveActions,
      backgroundColor: backgroundColor ?? colorScheme.surface.withValues(alpha: 0.95),
      elevation: 0,
      scrolledUnderElevation: 1,
      titleSpacing: effectiveLeading != null ? AppSpacing.sm : AppSpacing.pageHorizontal,
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: bottom!.preferredSize,
              child: Container(
                decoration: showBorder
                    ? BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                      )
                    : null,
                child: bottom,
              ),
            )
          : (showBorder
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(1.0),
                  child: Divider(
                    height: 1.0,
                    thickness: 1.0,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                )
              : null),
    );
  }
}
