import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/date_picker_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../core/providers/user_provider.dart';
import '../models/warranty_model.dart';
import '../providers/warranty_provider.dart';

/// Garanti kaydı ekleme ve düzenleme formu.
///
/// [editItem] null ise → "Ekle" modu.
/// [editItem] dolu ise → "Düzenle" modu.
class WarrantyFormScreen extends ConsumerStatefulWidget {
  const WarrantyFormScreen({super.key, this.editItem});

  final WarrantyModel? editItem;

  @override
  ConsumerState<WarrantyFormScreen> createState() => _WarrantyFormScreenState();
}

class _WarrantyFormScreenState extends ConsumerState<WarrantyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _brandCtrl;
  late final TextEditingController _storeCtrl;
  late final TextEditingController _invoiceCtrl;
  late final TextEditingController _notesCtrl;

  DateTime? _purchaseDate;
  DateTime? _warrantyEndDate;
  bool _hasInvoice = false;
  int _selectedIconCodePoint = Icons.devices_rounded.codePoint;

  bool get _isEditMode => widget.editItem != null;

  // ── İkon Seçenekleri ─────────────────────────────────────────────────────

  static const List<_IconOption> _iconOptions = [
    _IconOption(Icons.kitchen_rounded, 'Buzdolabı/Mutfak'),
    _IconOption(Icons.tv_rounded, 'TV'),
    _IconOption(Icons.laptop_mac_rounded, 'Laptop'),
    _IconOption(Icons.phone_android_rounded, 'Telefon'),
    _IconOption(Icons.local_laundry_service_rounded, 'Beyaz Eşya'),
    _IconOption(Icons.cleaning_services_rounded, 'Süpürge'),
    _IconOption(Icons.ac_unit_rounded, 'Klima'),
    _IconOption(Icons.blender_rounded, 'Küçük Ev Aleti'),
    _IconOption(Icons.camera_alt_rounded, 'Kamera'),
    _IconOption(Icons.headphones_rounded, 'Ses Sistemi'),
    _IconOption(Icons.watch_rounded, 'Saat/Wearable'),
    _IconOption(Icons.devices_rounded, 'Diğer'),
  ];

  @override
  void initState() {
    super.initState();
    final item = widget.editItem;
    _nameCtrl = TextEditingController(text: item?.name ?? '');
    _brandCtrl = TextEditingController(text: item?.brand ?? '');
    _storeCtrl = TextEditingController(text: item?.store ?? '');
    _invoiceCtrl = TextEditingController(text: item?.invoiceNumber ?? '');
    _notesCtrl = TextEditingController(text: item?.notes ?? '');
    _purchaseDate = item?.purchaseDate;
    _warrantyEndDate = item?.warrantyEndDate;
    _hasInvoice = item?.hasInvoice ?? false;
    _selectedIconCodePoint =
        item?.icon.codePoint ?? Icons.devices_rounded.codePoint;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _brandCtrl.dispose();
    _storeCtrl.dispose();
    _invoiceCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  // ── Submit ────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_purchaseDate == null) {
      _showError('Lütfen alış tarihini seçin.');
      return;
    }
    if (_warrantyEndDate == null) {
      _showError('Lütfen garanti bitiş tarihini seçin.');
      return;
    }

    final notifier = ref.read(warrantyNotifierProvider.notifier);
    final familyId = ref.read(activeFamilyIdProvider);
    final uid = ref.read(firebaseAuthProvider).currentUser?.uid ?? '';

    if (_isEditMode) {
      final updated = widget.editItem!.copyWith(
        name: _nameCtrl.text.trim(),
        brand: _brandCtrl.text.trim(),
        store: _storeCtrl.text.trim(),
        purchaseDate: _purchaseDate,
        warrantyEndDate: _warrantyEndDate,
        // ignore: non_const_argument_for_const_parameter
        icon: IconData(_selectedIconCodePoint, fontFamily: 'MaterialIcons'),
        hasInvoice: _hasInvoice,
        invoiceNumber: _hasInvoice && _invoiceCtrl.text.trim().isNotEmpty
            ? _invoiceCtrl.text.trim()
            : null,
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      );
      await notifier.updateItem(updated);
    } else {
      final item = WarrantyModel(
        id: '',
        familyId: familyId,
        name: _nameCtrl.text.trim(),
        brand: _brandCtrl.text.trim(),
        store: _storeCtrl.text.trim(),
        purchaseDate: _purchaseDate!,
        warrantyEndDate: _warrantyEndDate!,
        // ignore: non_const_argument_for_const_parameter
        icon: IconData(_selectedIconCodePoint, fontFamily: 'MaterialIcons'),
        createdBy: uid,
        hasInvoice: _hasInvoice,
        invoiceNumber: _hasInvoice && _invoiceCtrl.text.trim().isNotEmpty
            ? _invoiceCtrl.text.trim()
            : null,
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      );
      await notifier.addItem(item);
    }

    final state = ref.read(warrantyNotifierProvider);
    if (state.hasError) {
      if (mounted) _showError(state.error.toString());
    } else {
      if (mounted) Navigator.of(context).pop();
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
    final isLoading = ref.watch(warrantyNotifierProvider).isLoading;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Garanti Kaydını Düzenle' : 'Garanti Ekle',
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
                AppTextField(
                  label: 'Ürün / Cihaz Adı',
                  hintText: 'Örn: Buzdolabı, Laptop...',
                  controller: _nameCtrl,
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Ürün adı zorunludur.'
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),

                AppTextField(
                  label: 'Marka',
                  hintText: 'Örn: Samsung, Apple...',
                  controller: _brandCtrl,
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Marka zorunludur.'
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),

                AppTextField(
                  label: 'Satın Alınan Mağaza',
                  hintText: 'Örn: MediaMarkt, Trendyol...',
                  controller: _storeCtrl,
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Mağaza adı zorunludur.'
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),

                DatePickerField(
                  label: 'Alış Tarihi',
                  hintText: 'Tarih Seçiniz',
                  selectedDate: _purchaseDate,
                  onDateSelected: (d) => setState(() => _purchaseDate = d),
                  lastDate: DateTime.now(),
                ),
                const SizedBox(height: AppSpacing.lg),

                DatePickerField(
                  label: 'Garanti Bitiş Tarihi',
                  hintText: 'Tarih Seçiniz',
                  selectedDate: _warrantyEndDate,
                  onDateSelected: (d) => setState(() => _warrantyEndDate = d),
                  firstDate: DateTime.now().subtract(
                    const Duration(days: 365 * 10),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Fatura / Belge Durumu ─────────────────────────────────
                Row(
                  children: [
                    Checkbox(
                      value: _hasInvoice,
                      onChanged: (v) => setState(() => _hasInvoice = v!),
                      activeColor: colorScheme.primary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Fatura / Belge Mevcut',
                      style: AppTypography.bodyLarge.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),

                if (_hasInvoice) ...[
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Fatura Numarası (İsteğe Bağlı)',
                    hintText: 'Örn: AMZ-2024-12345',
                    controller: _invoiceCtrl,
                    textInputAction: TextInputAction.next,
                  ),
                ],

                const SizedBox(height: AppSpacing.lg),

                // ── İkon Seçici ───────────────────────────────────────────
                _buildIconPicker(colorScheme),

                const SizedBox(height: AppSpacing.lg),

                AppTextField(
                  label: 'Notlar (İsteğe Bağlı)',
                  hintText: 'Ek bilgi...',
                  controller: _notesCtrl,
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                ),

                const SizedBox(height: AppSpacing.xxl),

                PrimaryButton(
                  text:
                      _isEditMode ? 'Değişiklikleri Kaydet' : 'Garanti Ekle',
                  icon: _isEditMode
                      ? Icons.check_rounded
                      : Icons.verified_outlined,
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

  // ── İkon Seçici ───────────────────────────────────────────────────────────

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

class _IconOption {
  const _IconOption(this.icon, this.label);
  final IconData icon;
  final String label;
}
