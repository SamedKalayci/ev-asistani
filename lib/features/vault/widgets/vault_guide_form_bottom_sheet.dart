import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
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

  static const List<Map<String, String>> _categories = [
    {'id': 'wifi', 'label': '📶 Wi-Fi & Ağ'},
    {'id': 'installation', 'label': '⚡ Tesisat & Abonelik'},
    {'id': 'passwords', 'label': '🔑 Şifre & Kodlar'},
    {'id': 'general', 'label': 'ℹ️ Genel Ev Bilgisi'},
  ];

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ev bilgisi güncellendi! ✅')),
        );
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Yeni ev bilgisi eklendi! ✅')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
                  isEditing ? 'Ev Bilgisini Düzenle' : 'Yeni Ev Bilgisi Ekle',
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Kategori Seçimi Chips ──────────────────────────────────────
              Text(
                'Kategori Seçimi',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _categories.map((cat) {
                  final isSelected = _selectedSubCategory == cat['id'];
                  return ChoiceChip(
                    label: Text(cat['label']!),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedSubCategory = cat['id']!);
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
                label: 'Rehber Başlığı',
                hintText: 'Örn: Doğalgaz Aboneliği, Su Vanası, Wi-Fi Şifresi',
                controller: _titleController,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Başlık zorunludur.' : null,
              ),

              const SizedBox(height: AppSpacing.md),

              // ── Önemli Bilgi / Değer (Kopyalanabilir Alan) ──────────────────
              AppTextField(
                label: 'Önemli Bilgi / Değer (Tek Tıkla Kopyalanabilir)',
                hintText: 'Örn: Abone No: 123456, Şifre: xyz123, Mavi Vana',
                controller: _valueController,
              ),

              const SizedBox(height: AppSpacing.md),

              // ── Açıklama / Detaylı Not ─────────────────────────────────────
              AppTextField(
                label: 'Açıklama / Detaylı Not',
                hintText: 'Örn: Sayaç balkondaki dolabın sağ iç kısmındadır.',
                controller: _descController,
              ),

              const SizedBox(height: AppSpacing.xl),

              // ── Kaydet / Güncelle Butonu ──────────────────────────────────
              PrimaryButton(
                text: isEditing ? 'Bilgiyi Güncelle' : '+ Ev Bilgisi Ekle',
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
