import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/date_picker_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../core/utils/permission_utils.dart';
import '../../../core/utils/icon_helper.dart';
import '../../../l10n/app_localizations.dart';
import '../../vault/models/vault_item_model.dart';
import '../../vault/providers/vault_provider.dart';
import '../models/warranty_model.dart';
import '../providers/warranty_provider.dart';

/// Garanti kaydı ekleme ve düzenleme formu.
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

  String? _pickedFilePath;
  Uint8List? _pickedFileBytes;
  String? _pickedFileName;
  bool _isUploading = false;
  bool _isInvoiceRemoved = false;

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

    if (item?.invoiceUrl != null && item!.invoiceUrl!.isNotEmpty) {
      try {
        final uri = Uri.parse(item.invoiceUrl!);
        final pathSegments = uri.pathSegments;
        if (pathSegments.isNotEmpty) {
          final rawName = Uri.decodeComponent(pathSegments.last);
          _pickedFileName = rawName.contains('/') ? rawName.split('/').last : rawName;
        } else {
          _pickedFileName = 'Fatura / Belge';
        }
      } catch (_) {
        _pickedFileName = 'Fatura / Belge';
      }
    }
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

  Future<void> _openInvoiceDocument() async {
    final url = _pickedFilePath ?? widget.editItem?.invoiceUrl;
    if (url == null || url.isEmpty) {
      _showError('Görüntülenecek dosya veya bağlantı bulunamadı.');
      return;
    }

    try {
      if (url.startsWith('http://') || url.startsWith('https://')) {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (mounted) {
            _showError('Fatura / Belge bağlantısı açılamadı.');
          }
        }
      } else {
        final file = File(url);
        if (await file.exists()) {
          final uri = Uri.file(file.path);
          await launchUrl(uri);
        } else {
          if (mounted) {
            _showError('Cihazdaki dosya bulunamadı veya silinmiş.');
          }
        }
      }
    } catch (e) {
      if (mounted) _showError('Dosya açılırken hata oluştu: $e');
    }
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
          if (source == ImageSource.gallery && status.isRestricted) {
            // isRestricted durumunda galeri erişimine izin ver — devam et
          } else {
            return;
          }
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
          _hasInvoice = true;
          _isInvoiceRemoved = false;
        });
      }
    } catch (e) {
      if (mounted) _showError('Görsel seçilirken hata oluştu: $e');
    }
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final picked = result.files.single;
        setState(() {
          _pickedFileBytes = picked.bytes;
          _pickedFilePath = picked.path;
          _pickedFileName = picked.name;
          _hasInvoice = true;
          _isInvoiceRemoved = false;
        });
      }
    } catch (e) {
      if (mounted) _showError('Dosya seçilirken hata oluştu: $e');
    }
  }

  void _showFilePickerOptions() {
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
                'Fatura / Belge Görseli Seç',
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
                title: const Text('📸 Kamera ile Çek'),
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
                title: const Text('🖼️ Galeriden Seç'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: AppRadius.borderMd,
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFDC2626)),
                ),
                title: const Text('📄 PDF / Belge Seç'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickFile();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Submit ────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_purchaseDate == null) {
      _showError(l10n.selectPurchaseDateWarning);
      return;
    }
    if (_warrantyEndDate == null) {
      _showError(l10n.selectWarrantyEndDateWarning);
      return;
    }

    setState(() => _isUploading = true);

    try {
      final notifier = ref.read(warrantyNotifierProvider.notifier);
      final familyId = ref.read(activeFamilyIdProvider);
      final uid = ref.read(firebaseAuthProvider).currentUser?.uid ?? '';
      final storageService = ref.read(storageServiceProvider);

      String? invoiceUrl = _hasInvoice
          ? (_isInvoiceRemoved ? null : widget.editItem?.invoiceUrl)
          : null;

      final bool isNewFileUploaded = _pickedFilePath != null || _pickedFileBytes != null;

      if (_hasInvoice && isNewFileUploaded) {
        final docId = _isEditMode
            ? widget.editItem!.id
            : DateTime.now().millisecondsSinceEpoch.toString();

        invoiceUrl = await storageService.uploadWarrantyDocument(
          familyId: familyId,
          docId: docId,
          fileName: _pickedFileName ?? 'invoice',
          file: kIsWeb || _pickedFilePath == null ? null : File(_pickedFilePath!),
          bytes: _pickedFileBytes,
        );
      }

      if (_isEditMode) {
        final updated = widget.editItem!.copyWith(
          name: _nameCtrl.text.trim(),
          brand: _brandCtrl.text.trim(),
          store: _storeCtrl.text.trim(),
          purchaseDate: _purchaseDate,
          warrantyEndDate: _warrantyEndDate,
          icon: getSafeIconData(_selectedIconCodePoint),
          hasInvoice: _hasInvoice,
          invoiceNumber: _hasInvoice && _invoiceCtrl.text.trim().isNotEmpty
              ? _invoiceCtrl.text.trim()
              : null,
          invoiceUrl: invoiceUrl,
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
          icon: getSafeIconData(_selectedIconCodePoint),
          createdBy: uid,
          hasInvoice: _hasInvoice,
          invoiceNumber: _hasInvoice && _invoiceCtrl.text.trim().isNotEmpty
              ? _invoiceCtrl.text.trim()
              : null,
          invoiceUrl: invoiceUrl,
          notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        );
        await notifier.addItem(item);
      }

      // ── Ev Kasası (Vault) Otomatik Belge Senkronizasyonu ─────────────
      if (invoiceUrl != null && invoiceUrl.isNotEmpty && (!_isEditMode || isNewFileUploaded)) {
        try {
          final vaultRepo = ref.read(vaultRepositoryProvider);
          final nameStr = _nameCtrl.text.trim();
          final brandStr = _brandCtrl.text.trim();
          final storeStr = _storeCtrl.text.trim();

          final vaultTitle = brandStr.isNotEmpty ? '$nameStr ($brandStr)' : nameStr;
          String descStr = 'Garanti takibinden otomatik eklendi';
          if (brandStr.isNotEmpty || storeStr.isNotEmpty) {
            descStr += ' - ${[brandStr, storeStr].where((s) => s.isNotEmpty).join(' / ')}';
          }

          final vaultItem = VaultItemModel(
            id: '',
            familyId: familyId,
            category: 'documents',
            subCategory: 'general',
            title: vaultTitle,
            description: descStr,
            fileUrl: invoiceUrl,
            iconCode: _selectedIconCodePoint,
            createdBy: uid,
            createdAt: DateTime.now(),
          );

          await vaultRepo.addVaultItem(familyId, vaultItem);
        } catch (e) {
          debugPrint('Ev Kasası senkronizasyon hatası: $e');
        }
      }

      final state = ref.read(warrantyNotifierProvider);
      if (state.hasError) {
        if (mounted) _showError(state.error.toString());
      } else {
        if (mounted) Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) _showError('$e');
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
    final l10n = AppLocalizations.of(context)!;
    final isLoading = ref.watch(warrantyNotifierProvider).isLoading;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          _isEditMode ? l10n.editWarranty : l10n.addWarranty,
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
                  label: l10n.productDeviceName,
                  hintText: l10n.productDeviceNameHint,
                  controller: _nameCtrl,
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.productNameRequired
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),

                AppTextField(
                  label: l10n.brand,
                  hintText: l10n.brandHint,
                  controller: _brandCtrl,
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.brandRequired
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),

                AppTextField(
                  label: l10n.store,
                  hintText: l10n.storeHint,
                  controller: _storeCtrl,
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.storeRequired
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),

                DatePickerField(
                  label: l10n.purchaseDate,
                  hintText: l10n.selectDateHint,
                  selectedDate: _purchaseDate,
                  onDateSelected: (d) => setState(() => _purchaseDate = d),
                  lastDate: DateTime.now(),
                ),
                const SizedBox(height: AppSpacing.lg),

                DatePickerField(
                  label: l10n.warrantyEndDate,
                  hintText: l10n.selectDateHint,
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
                      l10n.hasInvoice,
                      style: AppTypography.bodyLarge.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),

                if (_hasInvoice) ...[
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: l10n.invoiceNumberOptional,
                    hintText: l10n.invoiceNumberHint,
                    controller: _invoiceCtrl,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (_pickedFileName != null || (widget.editItem?.invoiceUrl != null && widget.editItem!.invoiceUrl!.isNotEmpty && !_isInvoiceRemoved)) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh,
                        borderRadius: AppRadius.borderMd,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: AppRadius.borderSm,
                                ),
                                child: const Icon(
                                  Icons.receipt_long_rounded,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Fatura / Belge',
                                      style: AppTypography.labelSmall.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    Text(
                                      _pickedFileName ?? 'Fatura Belgesi',
                                      style: AppTypography.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                tooltip: 'Kaldır',
                                icon: const Icon(Icons.close_rounded, size: 20),
                                onPressed: () => setState(() {
                                  _pickedFilePath = null;
                                  _pickedFileBytes = null;
                                  _pickedFileName = null;
                                  _isInvoiceRemoved = true;
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: _openInvoiceDocument,
                                  icon: const Icon(Icons.visibility_rounded, size: 18),
                                  label: const Text('Görüntüle'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(0, 38),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _showFilePickerOptions,
                                  icon: const Icon(Icons.sync_rounded, size: 18),
                                  label: const Text('Değiştir'),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(0, 38),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    side: BorderSide(color: colorScheme.outlineVariant),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                  ] else ...[
                    OutlinedButton.icon(
                      onPressed: _showFilePickerOptions,
                      icon: const Icon(Icons.upload_file_rounded),
                      label: Text(l10n.uploadInvoiceFile),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                        side: BorderSide(color: colorScheme.outlineVariant),
                      ),
                    ),
                  ],
                ],

                const SizedBox(height: AppSpacing.lg),

                // ── İkon Seçici ───────────────────────────────────────────
                _buildIconPicker(colorScheme, l10n),

                const SizedBox(height: AppSpacing.lg),

                AppTextField(
                  label: l10n.optionalNotes,
                  hintText: l10n.optionalNotesHint,
                  controller: _notesCtrl,
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                ),

                const SizedBox(height: AppSpacing.xxl),

                PrimaryButton(
                  text: _isEditMode ? l10n.saveChanges : l10n.addWarranty,
                  icon: _isEditMode
                      ? Icons.check_rounded
                      : Icons.verified_outlined,
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

  // ── İkon Seçici ───────────────────────────────────────────────────────────

  Widget _buildIconPicker(ColorScheme colorScheme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.icon,
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
