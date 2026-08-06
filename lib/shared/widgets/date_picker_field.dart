import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import 'app_text_field.dart';

/// Son kullanma ve garanti ekranlarında ortak tarih seçici (DatePickerField) bileşeni.
/// Material Design 3 standartlarına uygun, responsive ve parametrik yapıda.
class DatePickerField extends StatelessWidget {
  /// Alan üzerindeki etiket metni
  final String? label;

  /// Seçim yapılmadığında gösterilecek ipucu metni
  final String? hintText;

  /// Seçili tarih
  final DateTime? selectedDate;

  /// Tarih seçildiğinde veya temizlendiğinde çalışacak callback
  final ValueChanged<DateTime?>? onDateSelected;

  /// Seçilebilecek en erken tarih
  final DateTime? firstDate;

  /// Seçilebilecek en geç tarih
  final DateTime? lastDate;

  /// Tarih seçici açıldığında varsayılan odaklanılacak tarih
  final DateTime? initialDate;

  /// Temizleme (silme) butonunun gösterilip gösterilmeyeceği
  final bool clearable;

  /// Etkinlik durumu
  final bool enabled;

  /// Hata metni
  final String? errorText;

  /// Yardımcı metin
  final String? helperText;

  /// Özel tarih formatlama fonksiyonu
  final String Function(DateTime)? dateFormat;

  const DatePickerField({
    super.key,
    this.label,
    this.hintText = 'Tarih Seçiniz',
    this.selectedDate,
    this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.clearable = true,
    this.enabled = true,
    this.errorText,
    this.helperText,
    this.dateFormat,
  });

  /// Varsayılan tarih formatlama (GG.AA.YYYY)
  String _defaultFormatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day.$month.$year';
  }

  Future<void> _pickDate(BuildContext context) async {
    if (!enabled) return;

    final now = DateTime.now();
    final effectiveInitialDate = selectedDate ?? initialDate ?? now;
    final effectiveFirstDate = firstDate ?? DateTime(now.year - 50);
    final effectiveLastDate = lastDate ?? DateTime(now.year + 50);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: effectiveInitialDate.isBefore(effectiveFirstDate)
          ? effectiveFirstDate
          : (effectiveInitialDate.isAfter(effectiveLastDate)
              ? effectiveLastDate
              : effectiveInitialDate),
      firstDate: effectiveFirstDate,
      lastDate: effectiveLastDate,
    );

    if (pickedDate != null && onDateSelected != null) {
      onDateSelected!(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final formattedText = selectedDate != null
        ? (dateFormat != null ? dateFormat!(selectedDate!) : _defaultFormatDate(selectedDate!))
        : '';

    Widget? suffixIcon;
    if (selectedDate != null && clearable && enabled) {
      suffixIcon = IconButton(
        icon: const Icon(Icons.close_rounded, size: AppSpacing.lg),
        color: colorScheme.onSurfaceVariant,
        onPressed: () {
          if (onDateSelected != null) {
            onDateSelected!(null);
          }
        },
      );
    } else {
      suffixIcon = Icon(
        Icons.calendar_today_rounded,
        size: AppSpacing.lg,
        color: enabled ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
      );
    }

    return AppTextField(
      label: label,
      hintText: hintText,
      controller: TextEditingController(text: formattedText),
      readOnly: true,
      enabled: enabled,
      errorText: errorText,
      helperText: helperText,
      suffixIcon: suffixIcon,
      onTap: () => _pickDate(context),
    );
  }
}
