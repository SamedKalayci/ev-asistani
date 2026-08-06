import 'package:flutter/material.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Son kullanma ve garanti ekranlarında kullanılacak ortak hatırlatma kartı (ReminderCard).
/// Material Design 3 standartlarına uygun, responsive ve parametrik yapıda.
class ReminderCard extends StatelessWidget {
  /// Ürün veya kayıt başlığı (ör. 'Yarım Yağlı Süt', 'Çamaşır Makinesi')
  final String title;

  /// İkincil alt başlık (ör. 'Buzdolabı', 'Bosch')
  final String? subtitle;

  /// Tarih gösterim metni (ör. '12 Eki 2023')
  final String? dateText;

  /// Tarih etiket başlığı (ör. 'Son Kullanma', 'Garanti Bitiş')
  final String? dateLabel;

  /// Durum etiket metni (ör. '2 Gün Kaldı', 'Süresi Doldu', 'Güvenli')
  final String? statusText;

  /// Durum rengi (rozet ve vurgu çizgisi rengi)
  final Color? statusColor;

  /// Sol tarafta gösterilecek ikon
  final IconData? icon;

  /// Sol tarafta gösterilecek resim URL'i (varsa)
  final String? imageUrl;

  /// Sol tarafta gösterilecek özel resim/ikon widget'ı
  final Widget? imageWidget;

  /// Tıklama callback'i
  final VoidCallback? onTap;

  /// İsteğe bağlı seçenekler / daha fazla butonu callback'i
  final VoidCallback? onMoreTap;

  /// Üst kısımda renkli vurgu çizgisinin gösterilip gösterilmeyeceği
  final bool showStatusLine;

  /// Kartın en altında eklenecek özel aksiyon widget'ı
  final Widget? bottomAction;

  const ReminderCard({
    super.key,
    required this.title,
    this.subtitle,
    this.dateText,
    this.dateLabel,
    this.statusText,
    this.statusColor,
    this.icon,
    this.imageUrl,
    this.imageWidget,
    this.onTap,
    this.onMoreTap,
    this.showStatusLine = true,
    this.bottomAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveStatusColor = statusColor ?? colorScheme.primary;

    Widget? leadingContent;
    if (imageWidget != null) {
      leadingContent = imageWidget;
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      leadingContent = ClipRRect(
        borderRadius: AppRadius.borderMd,
        child: Image.network(
          imageUrl!,
          width: AppSpacing.xxl + AppSpacing.lg,
          height: AppSpacing.xxl + AppSpacing.lg,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: AppSpacing.xxl + AppSpacing.lg,
            height: AppSpacing.xxl + AppSpacing.lg,
            color: colorScheme.surfaceContainerHigh,
            child: Icon(
              icon ?? Icons.inventory_2_outlined,
              color: colorScheme.onSurfaceVariant,
              size: AppSpacing.xl,
            ),
          ),
        ),
      );
    } else if (icon != null) {
      leadingContent = Container(
        width: AppSpacing.xxl + AppSpacing.lg,
        height: AppSpacing.xxl + AppSpacing.lg,
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: effectiveStatusColor.withOpacity(0.12),
          borderRadius: AppRadius.borderMd,
        ),
        child: Icon(
          icon,
          color: effectiveStatusColor,
          size: AppSpacing.xl,
        ),
      );
    }

    Widget cardChild = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showStatusLine)
          Container(
            height: AppSpacing.xs,
            width: double.infinity,
            decoration: BoxDecoration(
              color: effectiveStatusColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.lg),
                topRight: Radius.circular(AppRadius.lg),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (leadingContent != null) ...[
                    leadingContent,
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.titleMedium.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            subtitle!,
                            style: AppTypography.bodyMedium.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (onMoreTap != null)
                    IconButton(
                      icon: const Icon(Icons.more_vert_rounded),
                      iconSize: AppSpacing.lg,
                      color: colorScheme.onSurfaceVariant,
                      onPressed: onMoreTap,
                    ),
                ],
              ),
              if (dateText != null || statusText != null) ...[
                const SizedBox(height: AppSpacing.md),
                Divider(
                  height: 1,
                  thickness: 1,
                  // ignore: deprecated_member_use
                  color: colorScheme.outlineVariant.withOpacity(0.3),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (dateText != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (dateLabel != null)
                            Text(
                              dateLabel!.toUpperCase(),
                              style: AppTypography.labelSmall.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                letterSpacing: 0.5,
                              ),
                            ),
                          Text(
                            dateText!,
                            style: AppTypography.bodyMedium.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    if (statusText != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: effectiveStatusColor.withOpacity(0.12),
                          borderRadius: AppRadius.borderSm,
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: effectiveStatusColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          statusText!,
                          style: AppTypography.labelMedium.copyWith(
                            color: effectiveStatusColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
              if (bottomAction != null) ...[
                const SizedBox(height: AppSpacing.sm),
                bottomAction!,
              ],
            ],
          ),
        ),
      ],
    );

    Widget cardWidget = Container(
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
      child: cardChild,
    );

    if (onTap != null) {
      cardWidget = InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderLg,
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}
