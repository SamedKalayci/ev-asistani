import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/date_picker_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../core/utils/icon_helper.dart';
import '../models/expiration_model.dart';
import '../providers/expiration_provider.dart';

/// Son kullanma ürünü ekleme ve düzenleme formu.
class ExpirationFormScreen extends ConsumerStatefulWidget {
  const ExpirationFormScreen({super.key, this.editItem});

  final ExpirationModel? editItem;

  @override
  ConsumerState<ExpirationFormScreen> createState() =>
      _ExpirationFormScreenState();
}

class _ExpirationFormScreenState extends ConsumerState<ExpirationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _notesCtrl;

  DateTime? _selectedDate;
  int _selectedIconCodePoint = Icons.label_rounded.codePoint;

  bool get _isEditMode => widget.editItem != null;

  // ── İkon Seçenekleri ─────────────────────────────────────────────────────

  static const List<_IconOption> _iconOptions = [
    _IconOption(Icons.local_drink_rounded, 'İçecek'),
    _IconOption(Icons.kebab_dining_rounded, 'Et'),
    _IconOption(Icons.egg_rounded, 'Yumurta'),
    _IconOption(Icons.restaurant_rounded, 'Sos'),
    _IconOption(Icons.rice_bowl_rounded, 'Süt Ürünleri'),
    _IconOption(Icons.grass_rounded, 'Sebze'),
    _IconOption(Icons.bakery_dining_rounded, 'Ekmek'),
    _IconOption(Icons.breakfast_dining_rounded, 'Peynir'),
    _IconOption(Icons.apple_rounded, 'Meyve'),
    _IconOption(Icons.local_pizza_rounded, 'Hazır Yemek'),
    _IconOption(Icons.blender_rounded, 'İşlenmiş'),
    _IconOption(Icons.label_rounded, 'Diğer'),
  ];

  @override
  void initState() {
    super.initState();
    final item = widget.editItem;
    _titleCtrl = TextEditingController(text: item?.title ?? '');
    _locationCtrl = TextEditingController(text: item?.location ?? '');
    _notesCtrl = TextEditingController(text: item?.notes ?? '');
    _selectedDate = item?.expirationDate;
    _selectedIconCodePoint =
        item?.icon.codePoint ?? Icons.label_rounded.codePoint;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  // ── Form Gönderimi ────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      _showError('Lütfen son kullanma tarihini seçin.');
      return;
    }

    try {
      final notifier = ref.read(expirationNotifierProvider.notifier);

      if (_isEditMode) {
        final updated = widget.editItem!.copyWith(
          title: _titleCtrl.text.trim(),
          location: _locationCtrl.text.trim(),
          expirationDate: _selectedDate,
          icon: getSafeIconData(_selectedIconCodePoint),
          notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        );
        await notifier.updateItem(updated);
      } else {
        await notifier.addItem(
          title: _titleCtrl.text.trim(),
          location: _locationCtrl.text.trim(),
          expirationDate: _selectedDate!,
          iconCodePoint: _selectedIconCodePoint,
          notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        );
      }

      final state = ref.read(expirationNotifierProvider);
      if (state.hasError) {
        if (mounted) _showError(state.error.toString());
      } else {
        if (mounted) Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) _showError('İşlem sırasında hata oluştu: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLoading = ref.watch(expirationNotifierProvider).isLoading;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Ürünü Düzenle' : 'Ürün Ekle',
          style: AppTypography.titleLarge.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal,
            vertical: AppSpacing.lg,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Ürün Adı ────────────────────────────────────────────────
                AppTextField(
                  label: 'Ürün Adı',
                  hintText: 'Örn: Süt, Yumurta...',
                  controller: _titleCtrl,
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Ürün adı zorunludur.' : null,
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Konum ────────────────────────────────────────────────────
                AppTextField(
                  label: 'Konum',
                  hintText: 'Örn: Buzdolabı, Kiler...',
                  controller: _locationCtrl,
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Konum zorunludur.' : null,
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Son Kullanma Tarihi ───────────────────────────────────────
                DatePickerField(
                  label: 'Son Kullanma Tarihi',
                  hintText: 'Tarih Seçiniz',
                  selectedDate: _selectedDate,
                  onDateSelected: (date) =>
                      setState(() => _selectedDate = date),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── İkon Seçici ───────────────────────────────────────────────
                _buildIconPicker(colorScheme),
                const SizedBox(height: AppSpacing.lg),

                // ── Notlar (isteğe bağlı) ─────────────────────────────────────
                AppTextField(
                  label: 'Notlar (İsteğe Bağlı)',
                  hintText: 'Ek bilgi ekleyin...',
                  controller: _notesCtrl,
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: AppSpacing.xxl),

                // ── Kaydet Butonu ─────────────────────────────────────────────
                PrimaryButton(
                  text: _isEditMode ? 'Değişiklikleri Kaydet' : 'Ürünü Ekle',
                  icon: _isEditMode
                      ? Icons.check_rounded
                      : Icons.add_rounded,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _submit,
                ),

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── İkon Seçici Widget ────────────────────────────────────────────────────

  Widget _buildIconPicker(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'İkon',
          style: AppTypography.labelMedium.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: AppRadius.borderMd,
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _iconOptions.map((option) {
              final isSelected =
                  _selectedIconCodePoint == option.icon.codePoint;
              return Tooltip(
                message: option.label,
                child: InkWell(
                  onTap: () => setState(
                    () => _selectedIconCodePoint = option.icon.codePoint,
                  ),
                  borderRadius: AppRadius.borderSm,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primaryContainer
                          : Colors.transparent,
                      borderRadius: AppRadius.borderSm,
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      option.icon,
                      size: 28,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ── Yardımcı Veri Sınıfı ─────────────────────────────────────────────────────

class _IconOption {
  const _IconOption(this.icon, this.label);
  final IconData icon;
  final String label;
}
