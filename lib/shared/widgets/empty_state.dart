import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'primary_button.dart';

/// Liste boş olduğunda gösterilecek ortak bileşen (EmptyState).
/// Material Design 3 standartlarına uygun, responsive ve parametrik yapıda.
class EmptyState extends StatelessWidget {
  /// Ana başlık metni (ör. 'Henüz ürün eklenmedi')
  final String title;

  /// Açıklama metni (ör. 'Eklemek için aşağıdaki butona tıklayın.')
  final String? description;

  /// İkon
  final IconData? icon;

  /// İkon yerine gösterilecek özel widget
  final Widget? iconWidget;

  /// İsteğe bağlı aksiyon butonu etiket metni (ör. 'Ürün Ekle')
  final String? actionLabel;

  /// Aksiyon butonuna tıklandığında çalışacak callback
  final VoidCallback? onActionPressed;

  /// Aksiyon butonu ikonu
  final IconData? actionIcon;

  /// İkon boyutu
  final double? iconSize;

  /// İkon rengi
  final Color? iconColor;

  /// İkon kapsayıcı arka plan rengi
  final Color? iconBackgroundColor;

  /// Dış padding
  final EdgeInsetsGeometry? padding;

  const EmptyState({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.iconWidget,
    this.actionLabel,
    this.onActionPressed,
    this.actionIcon,
    this.iconSize,
    this.iconColor,
    this.iconBackgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveIconSize = iconSize ?? (AppSpacing.xxl + AppSpacing.lg);
    final effectiveIconColor = iconColor ?? colorScheme.primary;
    final effectiveIconBgColor =
        iconBackgroundColor ?? colorScheme.primaryContainer.withValues(alpha: 0.3);

    Widget? displayIcon;
    if (iconWidget != null) {
      displayIcon = iconWidget;
    } else if (icon != null) {
      displayIcon = Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: effectiveIconBgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: effectiveIconSize,
          color: effectiveIconColor,
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: AppSpacing.pageHorizontal,
              vertical: AppSpacing.xxl,
            ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (displayIcon != null) ...[
              displayIcon,
              const SizedBox(height: AppSpacing.xl),
            ],
            Text(
              title,
              style: AppTypography.titleLarge.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                description!,
                style: AppTypography.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                text: actionLabel!,
                onPressed: onActionPressed,
                icon: actionIcon,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
