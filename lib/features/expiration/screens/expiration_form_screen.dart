import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/date_picker_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../core/utils/permission_utils.dart';
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

  String? _pickedFilePath;
  Uint8List? _pickedFileBytes;
  String? _pickedFileName;
  bool _isUploading = false;

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

  Future<void> _showPermissionDeniedDialog(String title, String content) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              openAppSettings();
            },
            child: const Text('Ayarlara Git'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (!kIsWeb) {
        final status = await PermissionUtils.requestImagePermission(source);

        if (status.isPermanentlyDenied) {
          if (mounted) {
            await _showPermissionDeniedDialog(
              'İzin Gerekli',
              source == ImageSource.camera
                  ? 'Fotoğraf çekebilmek için kamera izni kalıcı olarak reddedilmiş. Lütfen ayarlardan izin verin.'
                  : 'Galeriye erişim izni kalıcı olarak reddedilmiş. Lütfen ayarlardan izin verin.',
            );
          }
          return;
        } else if (!status.isGranted && !status.isLimited) {
          return;
        }
      }
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _pickedFileBytes = bytes;
          _pickedFilePath = picked.path;
          _pickedFileName = picked.name;
        });
      }
    } catch (e) {
      if (mounted) _showError('Görsel seçilirken hata oluştu: $e');
    }
  }

  void _showImageOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final cs = Theme.of(ctx).colorScheme;
        return Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            borderRadius: AppRadius.borderTopXl,
          ),
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: AppRadius.borderFull,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Ürün Görseli Ekle',
                style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.lg),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: AppRadius.borderMd,
                  ),
                  child: const Icon(Icons.camera_alt_rounded, color: AppColors.primary),
                ),
                title: const Text('📸 Kamera ile Fotoğraf Çek'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBEAFE),
                    borderRadius: AppRadius.borderMd,
                  ),
                  child: const Icon(Icons.photo_library_rounded, color: Color(0xFF2563EB)),
                ),
                title: const Text('🖼️ Galeriden Fotoğraf Seç'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Form Gönderimi ────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      _showError('Lütfen son kullanma tarihini seçin.');
      return;
    }

    setState(() => _isUploading = true);

    try {
      final notifier = ref.read(expirationNotifierProvider.notifier);
      final familyId = ref.read(activeFamilyIdProvider);
      final storageService = ref.read(storageServiceProvider);

      String? imageUrl = widget.editItem?.imageUrl;

      if (_pickedFilePath != null || _pickedFileBytes != null) {
        final docId = _isEditMode
            ? widget.editItem!.id
            : DateTime.now().millisecondsSinceEpoch.toString();

        imageUrl = await storageService.uploadExpirationImage(
          familyId: familyId,
          docId: docId,
          fileName: _pickedFileName ?? 'product.jpg',
          file: kIsWeb || _pickedFilePath == null ? null : File(_pickedFilePath!),
          bytes: _pickedFileBytes,
        );
      }

      if (_isEditMode) {
        final updated = widget.editItem!.copyWith(
          title: _titleCtrl.text.trim(),
          location: _locationCtrl.text.trim(),
          expirationDate: _selectedDate,
          // ignore: non_const_argument_for_const_parameter
          icon: IconData(_selectedIconCodePoint, fontFamily: 'MaterialIcons'),
          imageUrl: imageUrl,
          notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        );
        await notifier.updateItem(updated);
      } else {
        await notifier.addItem(
          title: _titleCtrl.text.trim(),
          location: _locationCtrl.text.trim(),
          expirationDate: _selectedDate!,
          iconCodePoint: _selectedIconCodePoint,
          imageUrl: imageUrl,
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
      if (mounted) _showError('Görsel yüklenirken hata oluştu: $e');
    } finally {
      if (mounted) setState(() => _isUploading = false);
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

                // ── Ürün Görseli ─────────────────────────────────────────────
                Text(
                  'Ürün Görseli (İsteğe Bağlı)',
                  style: AppTypography.labelMedium.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                if (_pickedFileName != null || (widget.editItem?.imageUrl != null && widget.editItem!.imageUrl!.isNotEmpty)) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHigh,
                      borderRadius: AppRadius.borderMd,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.image_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            _pickedFileName ?? widget.editItem!.imageUrl!.split('/').last,
                            style: AppTypography.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18),
                          onPressed: () => setState(() {
                            _pickedFilePath = null;
                            _pickedFileBytes = null;
                            _pickedFileName = null;
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
                OutlinedButton.icon(
                  onPressed: _showImageOptions,
                  icon: const Icon(Icons.add_a_photo_rounded),
                  label: Text(_pickedFileName != null || widget.editItem?.imageUrl != null
                      ? 'Ürün Görselini Değiştir'
                      : '📸 Ürün Görseli Ekle'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 44),
                    side: BorderSide(color: colorScheme.outlineVariant),
                  ),
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
                  isLoading: isLoading || _isUploading,
                  onPressed: (isLoading || _isUploading) ? null : _submit,
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
