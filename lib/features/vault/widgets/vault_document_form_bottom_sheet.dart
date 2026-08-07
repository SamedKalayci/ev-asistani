import 'dart:io';
import 'package:file_picker/file_picker.dart';
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
import '../../../shared/widgets/primary_button.dart';
import '../models/vault_item_model.dart';
import '../providers/vault_provider.dart';

/// 📄 Belge Ekle / Düzenle Alt Modalı.
class VaultDocumentFormBottomSheet extends ConsumerStatefulWidget {
  final VaultItemModel? item;

  const VaultDocumentFormBottomSheet({super.key, this.item});

  static Future<void> show(BuildContext context, {VaultItemModel? item}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => VaultDocumentFormBottomSheet(item: item),
    );
  }

  @override
  ConsumerState<VaultDocumentFormBottomSheet> createState() =>
      _VaultDocumentFormBottomSheetState();
}

class _VaultDocumentFormBottomSheetState
    extends ConsumerState<VaultDocumentFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;

  String? _pickedFilePath;
  Uint8List? _pickedFileBytes;
  String? _pickedFileName;
  bool _isLoading = false;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item?.title ?? '');
    _descController = TextEditingController(text: widget.item?.description ?? '');
    // Eğer düzenleme modundaysa mevcut dosya adını göster
    final existingUrl = widget.item?.fileUrl;
    if (existingUrl != null && existingUrl.isNotEmpty) {
      _pickedFileName = existingUrl.split('/').last;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (!kIsWeb && source == ImageSource.camera) {
        final status = await Permission.camera.request();
        if (status.isDenied || status.isPermanentlyDenied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Kamera izni verilmedi. Fotoğraf çekebilmek için lütfen kamera iznini onaylayın.',
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
          return;
        }
      }

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _pickedFileBytes = bytes;
          _pickedFilePath = pickedFile.path;
          _pickedFileName = pickedFile.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Görsel seçilirken hata oluştu: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt'],
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final picked = result.files.single;
        setState(() {
          _pickedFileBytes = picked.bytes;
          _pickedFilePath = picked.path;
          _pickedFileName = picked.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dosya seçilirken hata oluştu: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
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
                'Dosya / Görsel Seç',
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
                title: const Text('📸 Fotoğraf Çek'),
                subtitle: const Text('Kamera ile anlık fotoğraf'),
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
                subtitle: const Text('Telefondaki fotoğraf veya görsel'),
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
                subtitle: const Text('PDF, Word veya Excel dosyası'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickFile();
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final familyId = ref.read(activeFamilyIdProvider);
    final user = ref.read(userProvider).valueOrNull;
    if (familyId.isEmpty || user == null) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(vaultRepositoryProvider);
      final storageService = ref.read(storageServiceProvider);

      String? fileUrl = widget.item?.fileUrl;

      // Eğer yeni bir dosya seçildiyse Firebase Storage'a yükle
      if (_pickedFilePath != null || _pickedFileBytes != null) {
        final docId = _isEditing
            ? widget.item!.id
            : DateTime.now().millisecondsSinceEpoch.toString();

        fileUrl = await storageService.uploadVaultDocument(
          familyId: familyId,
          docId: docId,
          file: kIsWeb || _pickedFilePath == null ? null : File(_pickedFilePath!),
          bytes: _pickedFileBytes,
          fileName: _pickedFileName ?? 'document',
        );
      }

      if (_isEditing) {
        final updateData = <String, dynamic>{
          'title': _titleController.text.trim(),
          'description': _descController.text.trim(),
        };
        if (fileUrl != null) updateData['fileUrl'] = fileUrl;
        await repo.updateVaultItem(familyId, widget.item!.id, updateData);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Belge güncellendi! ✅')),
          );
        }
      } else {
        final newItem = VaultItemModel(
          id: '',
          familyId: familyId,
          category: 'documents',
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          fileUrl: fileUrl,
          createdBy: user.uid,
        );
        await repo.addVaultItem(familyId, newItem);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Belge kaydedildi! ✅')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dosya yükleme hatası: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final hasFile = _pickedFilePath != null || _pickedFileBytes != null;
    final fileName = _pickedFileName ?? '';
    final isImage = hasFile &&
        (fileName.toLowerCase().endsWith('.jpg') ||
            fileName.toLowerCase().endsWith('.jpeg') ||
            fileName.toLowerCase().endsWith('.png') ||
            fileName.toLowerCase().endsWith('.webp'));

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
                  _isEditing ? 'Belgeyi Düzenle' : 'Yeni Belge / Evrak Ekle',
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              AppTextField(
                label: 'Belge Başlığı',
                hintText: 'Örn: Tapu Senedi, Kira Sözleşmesi',
                controller: _titleController,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Başlık zorunludur.' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Açıklama / Notlar',
                hintText: 'Örn: Dosya dolabında 2. gözde saklanıyor.',
                controller: _descController,
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Dosya / Görsel Seçici ────────────────────────────────────
              Text(
                'Dosya / Görsel Ekle',
                style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.xs),

              // Seçilen Dosya Önizlemesi
              if (hasFile) ...[
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
                      if (isImage)
                        ClipRRect(
                          borderRadius: AppRadius.borderSm,
                          child: _pickedFileBytes != null
                              ? Image.memory(
                                  _pickedFileBytes!,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(_pickedFilePath!),
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                ),
                        )
                      else
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            borderRadius: AppRadius.borderMd,
                          ),
                          child: const Icon(Icons.picture_as_pdf_rounded,
                              color: Color(0xFFDC2626), size: 32),
                        ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          _pickedFileName ?? '',
                          style: AppTypography.bodySmall,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
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
              ] else if (_isEditing && widget.item?.fileUrl != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh,
                    borderRadius: AppRadius.borderMd,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.attach_file_rounded,
                          color: AppColors.primary, size: 20),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          _pickedFileName ?? 'Mevcut dosya',
                          style: AppTypography.bodySmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
              ],

              // Dosya Seçici Butonu
              OutlinedButton.icon(
                onPressed: _showFilePickerOptions,
                icon: const Icon(Icons.upload_file_rounded),
                label: Text(_pickedFilePath != null
                    ? 'Dosyayı Değiştir'
                    : '📸 Fotoğraf / Belge Seç'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: BorderSide(color: colorScheme.outlineVariant),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              PrimaryButton(
                text: _isEditing ? 'Belgeyi Güncelle' : 'Belgeyi Kaydet',
                isLoading: _isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
