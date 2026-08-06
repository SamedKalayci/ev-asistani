import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/no_family_empty_state.dart';
import '../models/vault_item_model.dart';
import '../providers/vault_provider.dart';
import '../widgets/vault_document_form_bottom_sheet.dart';

/// 📄 Belgeler & Garantiler Detay Ekranı.
class VaultDocumentsScreen extends ConsumerWidget {
  const VaultDocumentsScreen({super.key});

  /// Belge paylaşma / indirme işlevi.
  Future<void> _handleShare(BuildContext context, VaultItemModel item) async {
    final fileUrl = item.fileUrl;

    // Yerel dosya yolu varsa direkt paylaş
    if (fileUrl != null && fileUrl.isNotEmpty) {
      final localFile = File(fileUrl);

      if (await localFile.exists()) {
        await Share.shareXFiles(
          [XFile(fileUrl)],
          text: '${item.title}\n${item.description}',
        );
        return;
      }

      // Uzak URL ise metin olarak paylaş
      if (fileUrl.startsWith('http')) {
        await Share.share(
          '${item.title}\n${item.description}\n\n$fileUrl',
        );
        return;
      }
    }

    // Dosya yoksa belge bilgilerini kopyala ve bildir
    await Clipboard.setData(
      ClipboardData(text: '📄 ${item.title}\n${item.description}'),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Belge bilgileri kopyalandı! 📋')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasFamily = ref.watch(hasRealFamilyProvider);
    final vaultItemsAsync = ref.watch(vaultItemsProvider);

    if (!hasFamily) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: const AppHeader(title: 'Ev Asistanı'),
        body: const SafeArea(child: NoFamilyEmptyState()),
      );
    }

    final items = (vaultItemsAsync.valueOrNull ?? [])
        .where((item) => item.category == 'documents')
        .toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppHeader(
        title: '📄 Belgeler & Garantiler',
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => VaultDocumentFormBottomSheet.show(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => VaultDocumentFormBottomSheet.show(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.upload_file_rounded, color: Colors.white),
        label: const Text(
          'Belge Yükle',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          child: Column(
            children: [
              if (items.isEmpty)
                EmptyState(
                  icon: Icons.folder_open_rounded,
                  title: 'Belge Bulunmuyor',
                  description:
                      'Tapu, sigorta poliçesi veya önemli evraklarınızı Dijital Ev Kasası\'na güvenle kaydedin.',
                  actionLabel: 'İlk Belgeyi Yükle',
                  onActionPressed: () => VaultDocumentFormBottomSheet.show(context),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildDocumentTile(context, ref, colorScheme, item);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentTile(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
    VaultItemModel item,
  ) {
    final fileUrl = item.fileUrl;
    final isLocalImage = fileUrl != null &&
        !fileUrl.startsWith('http') &&
        (fileUrl.endsWith('.jpg') ||
            fileUrl.endsWith('.jpeg') ||
            fileUrl.endsWith('.png') ||
            fileUrl.endsWith('.webp'));

    return InkWell(
      onTap: () => VaultDocumentFormBottomSheet.show(context, item: item),
      borderRadius: AppRadius.borderLg,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: AppRadius.borderLg,
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            // Belge İkonu ya da Küçük Görsel Önizleme
            ClipRRect(
              borderRadius: AppRadius.borderMd,
              child: isLocalImage
                  ? Image.file(
                      File(fileUrl),
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withValues(alpha: 0.4),
                        borderRadius: AppRadius.borderMd,
                      ),
                      child: Icon(
                        fileUrl != null && fileUrl.endsWith('.pdf')
                            ? Icons.picture_as_pdf_rounded
                            : Icons.article_outlined,
                        color: AppColors.primary,
                        size: 26,
                      ),
                    ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Başlık & Açıklama
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (item.description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if (fileUrl != null && fileUrl.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.attach_file_rounded,
                            size: 12, color: AppColors.primary),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            fileUrl.split('/').last,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Paylaş / İndir Butonu
            IconButton(
              icon: const Icon(Icons.share_rounded, size: 20),
              tooltip: 'Paylaş / İndir',
              onPressed: () => _handleShare(context, item),
            ),

            // Sil Butonu
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.error, size: 20),
              tooltip: 'Sil',
              onPressed: () => ref
                  .read(vaultRepositoryProvider)
                  .deleteVaultItem(item.familyId, item.id),
            ),
          ],
        ),
      ),
    );
  }
}
