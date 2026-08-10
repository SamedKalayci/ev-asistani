import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/empty_state.dart';
import '../models/vault_item_model.dart';
import '../providers/vault_provider.dart';
import '../widgets/vault_guide_form_bottom_sheet.dart';

/// 📶 Ev Rehberi & Wi-Fi Detay Ekranı.
class VaultGuideScreen extends ConsumerWidget {
  const VaultGuideScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final vaultItemsAsync = ref.watch(vaultItemsProvider);

    final items = (vaultItemsAsync.valueOrNull ?? [])
        .where((item) => item.category == 'guide')
        .toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppHeader(
        title: '📶 ${l10n.homeGuideWifi}',
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: l10n.addHomeInfo,
            onPressed: () => VaultGuideFormBottomSheet.show(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => VaultGuideFormBottomSheet.show(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          l10n.addHomeInfo,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          child: Column(
            children: [
              if (items.isEmpty)
                EmptyState(
                  icon: Icons.info_outline_rounded,
                  title: l10n.noGuideTitle,
                  description: l10n.noGuideDesc,
                  actionLabel: l10n.addHomeInfo,
                  onActionPressed: () => VaultGuideFormBottomSheet.show(context),
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
                    return _buildGuideTile(context, ref, colorScheme, item);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideTile(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
    VaultItemModel item,
  ) {
    final valueText = item.wifiPassword ?? '';
    final hasValueText = valueText.isNotEmpty;

    return InkWell(
      onTap: () => VaultGuideFormBottomSheet.show(context, item: item),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Kategoriye Göre Dinamik İkon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.icon,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // Başlık & Kategori Rozeti
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
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHigh,
                          borderRadius: AppRadius.borderSm,
                        ),
                        child: Text(
                          item.subCategoryLabel,
                          style: AppTypography.labelSmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Düzenle İkonu
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  tooltip: 'Düzenle',
                  onPressed: () =>
                      VaultGuideFormBottomSheet.show(context, item: item),
                ),

                // Sil Butonu
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: AppColors.error),
                  onPressed: () => ref
                      .read(vaultRepositoryProvider)
                      .deleteVaultItem(item.familyId, item.id),
                ),
              ],
            ),

            // Önemli Bilgi / Değer Kopyalama Kartı
            if (hasValueText) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: AppRadius.borderMd,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.copy_all_rounded,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Değer: ',
                      style: AppTypography.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        valueText,
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      tooltip: 'Kopyala',
                      color: AppColors.primary,
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: valueText));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Bilgi kopyalandı! 📋 ($valueText)'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],

            if (item.description.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                item.description,
                style: AppTypography.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
