import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../models/quick_note_model.dart';
import '../providers/quick_notes_provider.dart';

/// Harcama açıklaması için akıllı otomatik tamamlama alanı.
/// [quickNotesProvider]'dan gelen hazır notları yazar yazarken filtreler.
class QuickNotesAutocomplete extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? Function(String?)? validator;
  final ValueChanged<QuickNoteModel> onNoteSelected;

  const QuickNotesAutocomplete({
    super.key,
    required this.controller,
    this.label = 'Kısa Açıklama / Not',
    this.hintText,
    this.validator,
    required this.onNoteSelected,
  });

  @override
  ConsumerState<QuickNotesAutocomplete> createState() =>
      _QuickNotesAutocompleteState();
}

class _QuickNotesAutocompleteState
    extends ConsumerState<QuickNotesAutocomplete> {
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  List<QuickNoteModel> _suggestions = [];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onTextChanged() {
    if (!mounted) return;
    final text = widget.controller.text.trim().toLowerCase();
    final notes = ref.read(quickNotesProvider).valueOrNull ?? [];
    if (text.isEmpty || !_focusNode.hasFocus) {
      _suggestions = [];
      _removeOverlay();
      return;
    }
    _suggestions = notes
        .where((n) => n.title.toLowerCase().contains(text))
        .toList();

    if (_suggestions.isEmpty) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) _removeOverlay();
      });
    } else {
      _onTextChanged();
    }
  }

  void _selectSuggestion(QuickNoteModel suggestion) {
    widget.controller.text = suggestion.title;
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: suggestion.title.length),
    );
    widget.onNoteSelected(suggestion);
    _removeOverlay();
  }

  void _showOverlay() {
    if (!mounted) return;
    _removeOverlay();
    
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;
    
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (ctx) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: _SuggestionPopup(
            suggestions: _suggestions,
            onSelect: _selectSuggestion,
          ),
        ),
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          border: const OutlineInputBorder(borderRadius: AppRadius.borderMd),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 2,
          ),
          suffixIcon: Icon(
            Icons.tips_and_updates_outlined,
            size: 18,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
        ),
        validator: widget.validator,
        textInputAction: TextInputAction.next,
      ),
    );
  }
}

class _SuggestionPopup extends StatelessWidget {
  final List<QuickNoteModel> suggestions;
  final ValueChanged<QuickNoteModel> onSelect;

  const _SuggestionPopup({
    required this.suggestions,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 8,
      borderRadius: AppRadius.borderMd,
      color: colorScheme.surfaceContainerHigh,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 180),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          shrinkWrap: true,
          itemCount: suggestions.length,
          separatorBuilder: (_, __) =>
              Divider(height: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
          itemBuilder: (ctx, i) {
            final note = suggestions[i];
            return InkWell(
              onTap: () => onSelect(note),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Icon(note.category.icon,
                        size: 14,
                        color: colorScheme.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(note.title, style: AppTypography.bodyMedium),
                          Text(
                            note.category.getLocalizedLabel(context),
                            style: AppTypography.labelSmall.copyWith(
                              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

