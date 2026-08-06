import 'package:flutter/material.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Uygulamadaki ana aksiyon butonu (PrimaryButton) bileşeni.
/// Material Design 3 standartlarına uygun, responsive ve parametrik yapıda.
class PrimaryButton extends StatelessWidget {
  /// Buton üzerindeki metin
  final String text;

  /// Butona tıklandığında çalışacak fonksiyon (null ise buton disabled olur)
  final VoidCallback? onPressed;

  /// Metnin solunda yer alacak isteğe bağlı ikon
  final IconData? icon;

  /// İkon için özel widget (icon parametresi yerine geçer)
  final Widget? iconWidget;

  /// Yüklenme durumu (true ise indicator gösterilir, tıklama engellenir)
  final bool isLoading;

  /// Tam genişlik kaplama durumu (varsayılan: true)
  final bool isFullWidth;

  /// Arka plan rengi özel tanımı
  final Color? backgroundColor;

  /// Metin/İkon rengi özel tanımı
  final Color? foregroundColor;

  /// Köşe yuvarlaklığı (varsayılan: AppRadius.borderFull - pill)
  final BorderRadius? borderRadius;

  /// İç boşluklar (padding)
  final EdgeInsetsGeometry? padding;

  /// Buton yüksekliği
  final double? height;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconWidget,
    this.isLoading = false,
    this.isFullWidth = true,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBackgroundColor = backgroundColor ?? colorScheme.primary;
    final effectiveForegroundColor = foregroundColor ?? colorScheme.onPrimary;
    final effectiveRadius = borderRadius ?? AppRadius.borderFull;

    final style = FilledButton.styleFrom(
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      disabledBackgroundColor: colorScheme.onSurface.withValues(alpha: 0.12),
      disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
      shape: RoundedRectangleBorder(borderRadius: effectiveRadius),
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingH,
            vertical: AppSpacing.buttonPaddingV,
          ),
      textStyle: AppTypography.labelLarge,
    );

    Widget childContent;
    if (isLoading) {
      childContent = SizedBox(
        width: AppSpacing.xl,
        height: AppSpacing.xl,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(effectiveForegroundColor),
        ),
      );
    } else {
      final leadingIcon = iconWidget ?? (icon != null ? Icon(icon, size: AppSpacing.lg) : null);
      if (leadingIcon != null) {
        childContent = Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leadingIcon,
            const SizedBox(width: AppSpacing.iconTextGap),
            Text(text),
          ],
        );
      } else {
        childContent = Text(text);
      }
    }

    final button = FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: childContent,
    );

    Widget result = height != null
        ? SizedBox(
            height: height,
            child: button,
          )
        : button;

    if (isFullWidth) {
      result = SizedBox(
        width: double.infinity,
        child: result,
      );
    }

    return result;
  }
}
