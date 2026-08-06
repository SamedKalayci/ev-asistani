import 'package:flutter/material.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Liste ekranlarında kullanılacak ortak arama alanı (AppSearchBar) bileşeni.
/// Material Design 3 standartlarına uygun, responsive ve parametrik yapıda.
class AppSearchBar extends StatefulWidget {
  /// İpucu metni
  final String hintText;

  /// Metin kontrolcüsü
  final TextEditingController? controller;

  /// Metin değiştiğinde çalışacak callback
  final ValueChanged<String>? onChanged;

  /// Arama gönderildiğinde çalışacak callback
  final ValueChanged<String>? onSubmitted;

  /// Temizlendiğinde çalışacak callback
  final VoidCallback? onClear;

  /// Filtre ikonuna tıklandığında çalışacak callback
  final VoidCallback? onFilterTap;

  /// Filtre butonunun gösterilip gösterilmeyeceği
  final bool showFilterButton;

  /// Etkinlik durumu
  final bool enabled;

  /// Yalnızca okunabilir durumu
  final bool readOnly;

  /// Otomatik odaklanma
  final bool autofocus;

  /// Alana tıklandığında çalışacak callback (readOnly durumunda kullanışlıdır)
  final VoidCallback? onTap;

  /// Arka plan rengi özel tanımı
  final Color? fillColor;

  /// Dış kenar boşluğu
  final EdgeInsetsGeometry? margin;

  const AppSearchBar({
    super.key,
    this.hintText = 'Ara...',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.onFilterTap,
    this.showFilterButton = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.onTap,
    this.fillColor,
    this.margin,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late TextEditingController _controller;
  bool _isInternalController = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _isInternalController = true;
    }
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_handleTextChange);
  }

  @override
  void didUpdateWidget(AppSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (_isInternalController) {
        _controller.removeListener(_handleTextChange);
        _controller.dispose();
      }
      if (widget.controller != null) {
        _controller = widget.controller!;
        _isInternalController = false;
      } else {
        _controller = TextEditingController();
        _isInternalController = true;
      }
      _hasText = _controller.text.isNotEmpty;
      _controller.addListener(_handleTextChange);
    }
  }

  void _handleTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    if (_isInternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveFillColor = widget.fillColor ?? colorScheme.surfaceContainerLow;

    final searchField = TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      onTap: widget.onTap,
      textInputAction: TextInputAction.search,
      style: AppTypography.bodyLarge.copyWith(
        color: widget.enabled
            ? colorScheme.onSurface
            // ignore: deprecated_member_use
            : colorScheme.onSurface.withOpacity(0.38),
      ),
      cursorColor: colorScheme.primary,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppTypography.bodyMedium.copyWith(
          // ignore: deprecated_member_use
          color: colorScheme.onSurfaceVariant.withOpacity(0.7),
        ),
        filled: true,
        fillColor: effectiveFillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: widget.enabled
              ? colorScheme.onSurfaceVariant
              // ignore: deprecated_member_use
              : colorScheme.onSurfaceVariant.withOpacity(0.38),
          size: AppSpacing.xl,
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_hasText && widget.enabled && !widget.readOnly)
              IconButton(
                icon: const Icon(Icons.close_rounded),
                iconSize: AppSpacing.lg,
                color: colorScheme.onSurfaceVariant,
                onPressed: _clearSearch,
              ),
            if (widget.showFilterButton)
              IconButton(
                icon: const Icon(Icons.tune_rounded),
                iconSize: AppSpacing.lg,
                color: widget.onFilterTap != null
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                onPressed: widget.enabled ? widget.onFilterTap : null,
              ),
          ],
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderFull,
          // ignore: deprecated_member_use
          borderSide: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderFull,
          // ignore: deprecated_member_use
          borderSide: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderFull,
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderFull,
          // ignore: deprecated_member_use
          borderSide: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.2)),
        ),
      ),
    );

    if (widget.margin != null) {
      return Padding(
        padding: widget.margin!,
        child: searchField,
      );
    }

    return searchField;
  }
}
