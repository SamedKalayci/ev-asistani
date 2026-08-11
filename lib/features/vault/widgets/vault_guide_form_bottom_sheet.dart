import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../models/vault_item_model.dart';
import '../providers/vault_provider.dart';

/// Ev Rehberi bilgi ekleme/düzenleme alt modali.
class VaultGuideFormBottomSheet extends ConsumerStatefulWidget {
  final VaultItemModel? item;

  const VaultGuideFormBottomSheet({
    super.key,
    this.item,
  });

  static Future<void> show(BuildContext context, {VaultItemModel? item}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VaultGuideFormBottomSheet(item: item),
    );
  }

  @override
  ConsumerState<VaultGuideFormBottomSheet> createState() =>
      _VaultGuideFormBottomSheetState();
}

class _VaultGuideFormBottomSheetState
    extends ConsumerState<VaultGuideFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _valueController;
  late TextEditingController _descController;
  late String _selectedSubCategory;

  static const List<String> _categoryIds = [
    'wifi',
    'installation',
    'passwords',
    'general',
  ];

  String _getCategoryLabel(String id, AppLocalizations l10n) {
    return switch (id) {
      'wifi' => l10n.categoryWifi,
      'installation' => l10n.categoryInstallation,
      'passwords' => l10n.categoryPasswords,
      'general' => l10n.categoryGeneralHome,
      _ => l10n.categoryGeneralHome,
    };
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item?.title ?? '');
    _valueController = TextEditingController(text: widget.item?.wifiPassword ?? '');
    _descController = TextEditingController(text: widget.item?.description ?? '');
    _selectedSubCategory = widget.item?.subCategory ?? 'wifi';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _valueController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final familyId = ref.read(activeFamilyIdProvider);
    final user = ref.read(userProvider).valueOrNull;

    if (familyId.isEmpty || user == null) return;

    final repo = ref.read(vaultRepositoryProvider);
    final isEditing = widget.item != null;

    if (isEditing) {
      await repo.updateVaultItem(familyId, widget.item!.id, {
        'title': _titleController.text.trim(),
        'subCategory': _selectedSubCategory,
        'wifiPassword': _valueController.text.trim().isNotEmpty
            ? _valueController.text.trim()
            : null,
        'description': _descController.text.trim(),
      });
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      final newItem = VaultItemModel(
        id: '',
        familyId: familyId,
        category: 'guide',
        subCategory: _selectedSubCategory,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        wifiPassword: _valueController.text.trim().isNotEmpty
            ? _valueController.text.trim()
            : null,
        createdBy: user.uid,
      );
      await repo.addVaultItem(familyId, newItem);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isEditing = widget.item != null;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: AppRadius.borderTopXl,
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xl + bottomInset,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Center(
                child: Text(
                  isEditing ? l10n.editHomeInfo : l10n.addNewHomeInfo,
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Kategori Seçimi Chips ──────────────────────────────────────
              Text(
                l10n.categorySelection,
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _categoryIds.map((catId) {
                  final isSelected = _selectedSubCategory == catId;
                  return ChoiceChip(
                    label: Text(_getCategoryLabel(catId, l10n)),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedSubCategory = catId);
                      }
                    },
                    selectedColor: AppColors.primaryContainer,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : colorScheme.onSurfaceVariant,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Başlık ─────────────────────────────────────────────────────
              AppTextField(
                label: l10n.guideTitle,
                hintText: l10n.guideTitleHint,
                controller: _titleController,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.titleRequired : null,
              ),

              const SizedBox(height: AppSpacing.md),

              // ── Önemli Bilgi / Değer (Kopyalanabilir Alan) ──────────────────
              AppTextField(
                label: l10n.importantValueLabel,
                hintText: l10n.importantValueHint,
                controller: _valueController,
              ),

              const SizedBox(height: AppSpacing.md),

              // ── Açıklama / Detaylı Not ─────────────────────────────────────
              AppTextField(
                label: l10n.detailedNotesLabel,
                hintText: l10n.detailedNotesHint,
                controller: _descController,
              ),

              const SizedBox(height: AppSpacing.xl),

              // ── Kaydet / Güncelle Butonu ──────────────────────────────────
              PrimaryButton(
                text: isEditing ? l10n.updateInfoBtn : l10n.addHomeInfo,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

