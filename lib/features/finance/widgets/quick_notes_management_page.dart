import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/l10n_helper.dart';
import '../../../l10n/app_localizations.dart';
import '../models/finance_item_model.dart';
import '../models/quick_note_model.dart';
import '../providers/quick_notes_provider.dart';

/// Tekrarlayan Harcamalar / Hazır Not Şablon Yönetim Sayfası.
/// Profil ekranından bottom sheet olarak gösterilir.
class QuickNotesManagementPage extends ConsumerStatefulWidget {
  const QuickNotesManagementPage({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const QuickNotesManagementPage(),
    );
  }

  @override
  ConsumerState<QuickNotesManagementPage> createState() =>
      _QuickNotesManagementPageState();
}

class _QuickNotesManagementPageState
    extends ConsumerState<QuickNotesManagementPage> {
  final _controller = TextEditingController();
  FinanceCategory _selectedCategory = FinanceCategory.kitchenGrocery;
  bool _isSaving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addNote() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _isSaving = true);
    try {
      final familyId = ref.read(activeFamilyIdProvider);
      await addQuickNote(familyId, text, _selectedCategory);
      _controller.clear();
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteNote(String noteId) async {
    final familyId = ref.read(activeFamilyIdProvider);
    await deleteQuickNote(familyId, noteId);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final notesAsync = ref.watch(quickNotesProvider);
    final List<QuickNoteModel> notes = notesAsync.valueOrNull ?? [];
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xl + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sürükleme çubuğu
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: AppRadius.borderFull,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Başlık
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: AppRadius.borderMd,
                ),
                child: Icon(Icons.tips_and_updates_rounded,
                    color: colorScheme.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                l10n.recurringExpenses,
                style: AppTypography.headlineSmall
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.only(left: 52),
            child: Text(
              l10n.recurringExpensesDesc,
              style: AppTypography.bodySmall
                  .copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Yeni not ekleme alanı
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: l10n.templateNameLabel,
                  hintText: l10n.templateNameHint,
                  border: OutlineInputBorder(
                      borderRadius: AppRadius.borderMd),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<FinanceCategory>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: l10n.categoryLabel,
                        border: OutlineInputBorder(
                            borderRadius: AppRadius.borderMd),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      ),
                      items: FinanceCategory.walletCategories.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Row(
                            children: [
                              Icon(cat.icon, size: 16, color: colorScheme.onSurfaceVariant),
                              const SizedBox(width: AppSpacing.sm),
                              Text(cat.localizedName(context), style: AppTypography.bodyMedium),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedCategory = val);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  FilledButton(
                    onPressed: _isSaving ? null : _addNote,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      minimumSize: const Size(48, 48),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.add_rounded),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Not listesi
          if (notes.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.note_add_outlined,
                        size: 40, color: colorScheme.onSurfaceVariant),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.noTemplatesYet,
                      style: AppTypography.bodyMedium
                          .copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: notes.length,
                separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
                itemBuilder: (ctx, i) {
                  final note = notes[i];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: AppRadius.borderSm,
                      ),
                      child: Icon(note.category.icon,
                          size: 18, color: colorScheme.primary),
                    ),
                    title: Text(note.title, style: AppTypography.bodyMedium),
                    subtitle: Text(
                      note.category.localizedName(context),
                      style: AppTypography.labelSmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline_rounded,
                          size: 20, color: AppColors.error),
                      onPressed: () => _deleteNote(note.id),
                      tooltip: l10n.delete,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

