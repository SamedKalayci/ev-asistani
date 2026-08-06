import 'package:flutter/material.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Ana sayfadaki ve genel modüllerdeki istatistik kartları (StatCard) bileşeni.
/// Material Design 3 standartlarına uygun, responsive ve parametrik yapıda.
class StatCard extends StatelessWidget {
  /// İstatistik başlığı (ör. 'Evdeki Toplam Ürün')
  final String title;

  /// Ana değer / sayı (ör. '142', '5')
  final String value;

  /// İsteğe bağlı alt açıklama (ör. 'ürün takibinde')
  final String? subtitle;

  /// İkon
  final IconData? icon;

  /// Özel ikon widget'ı
  final Widget? iconWidget;

  /// Arka plan rengi özel tanımı
  final Color? backgroundColor;

  /// Metin ve içerik ana rengi özel tanımı
  final Color? foregroundColor;

  /// İkon rengi özel tanımı
  final Color? iconColor;

  /// Tıklama callback'i
  final VoidCallback? onTap;

  /// İç padding
  final EdgeInsetsGeometry? padding;

  /// Köşe yuvarlaklığı
  final BorderRadius? borderRadius;

  /// Gölge/Elevation stili
  final List<BoxShadow>? shadows;

  /// Kompakt (yatay) görünüm seçeneği
  final bool compact;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconWidget,
    this.backgroundColor,
    this.foregroundColor,
    this.iconColor,
    this.onTap,
    this.padding,
    this.borderRadius,
    this.shadows,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBgColor = backgroundColor ?? colorScheme.primaryContainer;
    final effectiveFgColor = foregroundColor ?? colorScheme.onPrimaryContainer;
    final effectiveIconColor = iconColor ?? effectiveFgColor;
    final effectiveRadius = borderRadius ?? AppRadius.borderLg;
    final effectiveShadows = shadows ?? AppShadows.sm;

    Widget? leadingIcon;
    if (iconWidget != null) {
      leadingIcon = iconWidget;
    } else if (icon != null) {
      leadingIcon = Icon(
        icon,
        size: compact ? AppSpacing.xl : (AppSpacing.xxl + AppSpacing.xs),
        color: effectiveIconColor,
      );
    }

    Widget content;
    if (compact) {
      content = Row(
        children: [
          if (leadingIcon != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: effectiveIconColor.withValues(alpha: 0.15),
                borderRadius: AppRadius.borderMd,
              ),
              child: leadingIcon,
            ),
            const SizedBox(width: AppSpacing.lg),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    color: effectiveFgColor.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  style: AppTypography.headlineMedium.copyWith(
                    color: effectiveFgColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    style: AppTypography.bodySmall.copyWith(
                      color: effectiveFgColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    } else {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leadingIcon != null) ...[
            leadingIcon,
            const SizedBox(height: AppSpacing.sm),
          ],
          Text(
            title,
            style: AppTypography.titleMedium.copyWith(
              color: effectiveFgColor.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.displayMedium.copyWith(
              color: effectiveFgColor,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle!,
              style: AppTypography.bodyMedium.copyWith(
                color: effectiveFgColor.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      );
    }

    Widget cardWidget = Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: effectiveRadius,
        boxShadow: effectiveShadows,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: content,
    );

    if (onTap != null) {
      cardWidget = InkWell(
        onTap: onTap,
        borderRadius: effectiveRadius,
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}
