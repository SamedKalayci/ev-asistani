import 'package:flutter/material.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Tüm formlarda kullanılacak ortak metin alanı (AppTextField) bileşeni.
/// Material Design 3 standartlarına uygun, responsive ve parametrik yapıda.
class AppTextField extends StatelessWidget {
  /// Alan üzerindeki etiket metni
  final String? label;

  /// Alan içindeki ipucu metni
  final String? hintText;

  /// Metin kontrolcüsü
  final TextEditingController? controller;

  /// Başlangıç değeri (controller kullanılmadığında)
  final String? initialValue;

  /// Metin değiştiğinde çalışacak callback
  final ValueChanged<String>? onChanged;

  /// Klavyeden gönder/tamam'a basıldığında çalışacak callback
  final ValueChanged<String>? onSubmitted;

  /// Form doğrulama fonksiyonu
  final FormFieldValidator<String>? validator;

  /// Klavye türü
  final TextInputType? keyboardType;

  /// Klavye aksiyonu
  final TextInputAction? textInputAction;

  /// Metnin gizlenip gizlenmeyeceği (şifre alanı için)
  final bool obscureText;

  /// Yalnızca okunabilir durumu
  final bool readOnly;

  /// Etkin durumu
  final bool enabled;

  /// Maksimum satır sayısı
  final int maxLines;

  /// Minimum satır sayısı
  final int? minLines;

  /// Maksimum karakter sayısı
  final int? maxLength;

  /// Sol iç ikon veya widget
  final Widget? prefixIcon;

  /// Sağ iç ikon veya widget
  final Widget? suffixIcon;

  /// Hata metni
  final String? errorText;

  /// Yardımcı metin
  final String? helperText;

  /// Otomatik odaklanma
  final bool autofocus;

  /// Odak düğümü
  final FocusNode? focusNode;

  /// Alana tıklandığında çalışacak callback
  final VoidCallback? onTap;

  /// Dolgu rengi özel tanımı
  final Color? fillColor;

  const AppTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.helperText,
    this.autofocus = false,
    this.focusNode,
    this.onTap,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveFillColor = fillColor ?? colorScheme.surfaceContainerLow;

    final inputDecoration = InputDecoration(
      hintText: hintText,
      hintStyle: AppTypography.bodyMedium.copyWith(
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
      ),
      filled: true,
      fillColor: effectiveFillColor,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: errorText,
      helperText: helperText,
      helperStyle: AppTypography.bodySmall.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      errorStyle: AppTypography.bodySmall.copyWith(
        color: colorScheme.error,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.inputPaddingH,
        vertical: AppSpacing.inputPaddingV,
      ),
      border: OutlineInputBorder(
        borderRadius: AppRadius.borderMd,
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.borderMd,
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.borderMd,
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.borderMd,
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.borderMd,
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.borderMd,
        borderSide: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
    );

    final textFieldWidget = TextFormField(
      controller: controller,
      initialValue: initialValue,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      autofocus: autofocus,
      focusNode: focusNode,
      onTap: onTap,
      style: AppTypography.bodyLarge.copyWith(
        color: enabled ? colorScheme.onSurface : colorScheme.onSurface.withValues(alpha: 0.38),
      ),
      cursorColor: colorScheme.primary,
      decoration: inputDecoration,
    );

    if (label != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label!,
            style: AppTypography.labelMedium.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          textFieldWidget,
        ],
      );
    }

    return textFieldWidget;
  }
}
