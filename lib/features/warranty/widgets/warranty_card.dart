import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../models/warranty_model.dart';

/// Garanti Takibi ekranına özel cihaz/ürün garanti kartı bileşeni.
class WarrantyCard extends StatelessWidget {
  final WarrantyModel item;
  final VoidCallback? onTap;

  const WarrantyCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: AppRadius.borderLg,
        boxShadow: AppShadows.sm,
        border: Border.all(
          // ignore: deprecated_member_use
          color: colorScheme.outlineVariant.withOpacity(0.3),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status çizgi vurgusu
            Container(
              height: AppSpacing.xs,
              width: double.infinity,
              color: item.statusColor,
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Üst başlık satırı
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: item.statusColor.withOpacity(0.12),
                          borderRadius: AppRadius.borderMd,
                        ),
                        child: Icon(
                          item.icon,
                          color: item.statusColor,
                          size: AppSpacing.xl,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item.name} (${item.brand})',
                              style: AppTypography.titleMedium.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  Icons.storefront_rounded,
                                  size: 14,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item.store,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      // Durum Rozeti
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: item.statusColor.withOpacity(0.12),
                          borderRadius: AppRadius.borderSm,
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: item.statusColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.status == WarrantyStatus.active
                                  ? Icons.check_circle_rounded
                                  : (item.status == WarrantyStatus.upcoming
                                      ? Icons.schedule_rounded
                                      : Icons.warning_rounded),
                              size: 14,
                              color: item.statusColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.statusText,
                              style: AppTypography.labelSmall.copyWith(
                                color: item.statusColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Fatura & Belge Durum Göstergesi
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: item.hasInvoice
                              // ignore: deprecated_member_use
                              ? AppColors.primaryContainer.withOpacity(0.2)
                              // ignore: deprecated_member_use
                              : colorScheme.surfaceContainerHigh.withOpacity(0.5),
                          borderRadius: AppRadius.borderXs,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.hasInvoice
                                  ? Icons.receipt_long_rounded
                                  : Icons.description_outlined,
                              size: 14,
                              color: item.hasInvoice
                                  ? AppColors.onPrimaryContainer
                                  : colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.hasInvoice ? 'Fatura Mevcut' : 'Fatura Yok',
                              style: AppTypography.labelSmall.copyWith(
                                color: item.hasInvoice
                                    ? AppColors.onPrimaryContainer
                                    : colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (item.invoiceNumber != null) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'No: ${item.invoiceNumber}',
                          style: AppTypography.labelSmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      if (item.invoiceUrl != null && item.invoiceUrl!.isNotEmpty) ...[
                        const Spacer(),
                        InkWell(
                          onTap: () async {
                            final Uri uri = Uri.parse(item.invoiceUrl!);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer.withValues(alpha: 0.4),
                              borderRadius: AppRadius.borderXs,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.open_in_new_rounded, size: 12, color: AppColors.primary),
                                const SizedBox(width: 3),
                                Text(
                                  'Faturayı Aç',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),
                  Divider(
                    height: 1,
                    thickness: 1,
                    // ignore: deprecated_member_use
                    color: colorScheme.outlineVariant.withOpacity(0.3),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Tarihler ve Garanti İlerleme Çubuğu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ALIŞ TARİHİ',
                            style: AppTypography.labelSmall.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            item.purchaseDateText,
                            style: AppTypography.bodyMedium.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'GARANTİ BİTİŞ',
                            style: AppTypography.labelSmall.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            item.warrantyEndDateText,
                            style: AppTypography.bodyMedium.copyWith(
                              color: item.status == WarrantyStatus.expired
                                  ? AppColors.error
                                  : colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Garanti Süresi Progress Bar
                  ClipRRect(
                    borderRadius: AppRadius.borderFull,
                    child: LinearProgressIndicator(
                      value: item.progress,
                      minHeight: 6,
                      backgroundColor: colorScheme.surfaceContainerHigh,
                      valueColor: AlwaysStoppedAnimation<Color>(item.statusColor),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xs),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      item.remainingText,
                      style: AppTypography.labelSmall.copyWith(
                        color: item.statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
