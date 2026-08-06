import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../models/shopping_item_model.dart';

/// Alışveriş listesi öğesi bileşeni (ShoppingItemTile).
/// [ShoppingItemModel] ile çalışır; mock bağımlılığı yoktur.
class ShoppingItemTile extends StatelessWidget {
  final ShoppingItemModel item;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onDelete;

  const ShoppingItemTile({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isCompleted = item.isCompleted;

    return Container(
      decoration: BoxDecoration(
        color: isCompleted
            ? colorScheme.surfaceContainer.withValues(alpha: 0.5)
            : colorScheme.surfaceContainerLowest,
        borderRadius: AppRadius.borderLg,
        boxShadow: isCompleted ? AppShadows.none : AppShadows.xs,
        border: Border.all(
          color: isCompleted
              ? Colors.transparent
              : colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.borderLg,
        child: InkWell(
          onTap: () => onToggle(!isCompleted),
          borderRadius: AppRadius.borderLg,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                // Checkbox
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: isCompleted,
                    onChanged: onToggle,
                    activeColor: colorScheme.primary,
                    checkColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.borderXs,
                    ),
                    side: BorderSide(
                      color:
                          isCompleted ? colorScheme.primary : colorScheme.outline,
                      width: 2,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // Metin ve detaylar
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: AppTypography.bodyLarge.copyWith(
                          color: isCompleted
                              ? colorScheme.onSurfaceVariant
                              : colorScheme.onSurface,
                          fontWeight: isCompleted
                              ? FontWeight.w400
                              : FontWeight.w600,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (item.note != null && item.note!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.note!,
                          style: AppTypography.bodySmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Kategori Rozeti (varsa ve tamamlanmamışsa)
                if (item.category != null && !isCompleted) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: AppRadius.borderSm,
                    ),
                    child: Text(
                      item.category!,
                      style: AppTypography.labelSmall.copyWith(
                        color: colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],

                // Silme Butonu
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  iconSize: 20,
                  color: colorScheme.onSurfaceVariant,
                  tooltip: 'Sil',
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
