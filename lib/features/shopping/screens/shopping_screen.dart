import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/providers/user_provider.dart';

import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/no_family_empty_state.dart';
import '../providers/shopping_provider.dart';
import '../widgets/shopping_item_tile.dart';

/// Alışveriş Listesi Ekranı — Firestore real-time StreamProvider bağlantılı.
class ShoppingScreen extends ConsumerStatefulWidget {
  const ShoppingScreen({super.key});

  @override
  ConsumerState<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends ConsumerState<ShoppingScreen> {
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();

  @override
  void dispose() {
    _inputController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  // ── Aksiyon Metodları ─────────────────────────────────────────────────────

  Future<void> _addItem([String? customText]) async {
    final text = (customText ?? _inputController.text).trim();
    if (text.isEmpty) return;
    _inputController.clear();
    await ref.read(shoppingNotifierProvider.notifier).addItem(name: text);
  }

  Future<void> _toggleItem(String id, bool? isCompleted) async {
    if (isCompleted == null) return;
    await ref
        .read(shoppingNotifierProvider.notifier)
        .toggleItem(id, isCompleted: isCompleted);
  }

  Future<void> _deleteItem(String id) async {
    await ref.read(shoppingNotifierProvider.notifier).deleteItem(id);
  }

  Future<void> _clearCompleted() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Alınanları Temizle'),
        content:
            const Text('Alınan tüm ürünler listeden kaldırılacak. Devam et?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('İptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Temizle'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(shoppingNotifierProvider.notifier).clearCompleted();
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasFamily = ref.watch(hasRealFamilyProvider);

    if (!hasFamily) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: const AppHeader(title: 'Ev Asistanı'),
        body: const SafeArea(child: NoFamilyEmptyState()),
      );
    }
    final itemsAsync = ref.watch(shoppingItemsProvider);
    final allItems = itemsAsync.valueOrNull ?? [];
    final pendingItems = allItems.where((i) => !i.isCompleted).toList();
    final completedItems = allItems.where((i) => i.isCompleted).toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const AppHeader(title: 'Ev Asistanı'),
      body: SafeArea(
        child: itemsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cloud_off_rounded,
                      size: 56, color: colorScheme.onSurfaceVariant),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Liste yüklenemedi.',
                    style: AppTypography.titleMedium
                        .copyWith(color: colorScheme.onSurface),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          data: (_) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pageHorizontal,
              vertical: AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Başlık + Rozet ────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alışveriş Listesi',
                            style: AppTypography.headlineLarge.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Alınacak ve alınan ürünleri kolayca takip edin.',
                            style: AppTypography.bodyLarge.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.tertiaryContainer
                            .withValues(alpha: 0.3),
                        borderRadius: AppRadius.borderFull,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shopping_basket_rounded,
                            size: 16,
                            color: colorScheme.onTertiaryContainer,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${allItems.length} Ürün',
                            style: AppTypography.labelMedium.copyWith(
                              color: colorScheme.onTertiaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xl),

                // ── Hızlı Ekleme Çubuğu ──────────────────────────────────
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLowest,
                    borderRadius: AppRadius.borderFull,
                    boxShadow: AppShadows.xs,
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _inputController,
                    focusNode: _inputFocusNode,
                    onSubmitted: (_) => _addItem(),
                    textInputAction: TextInputAction.done,
                    style: AppTypography.bodyLarge.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    cursorColor: colorScheme.primary,
                    decoration: InputDecoration(
                      hintText: 'Yeni ürün ekle...',
                      hintStyle: AppTypography.bodyMedium.copyWith(
                        color: colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.7),
                      ),
                      prefixIcon: Icon(
                        Icons.add_circle_rounded,
                        color: colorScheme.primary,
                        size: AppSpacing.xl,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_upward_rounded),
                        color: colorScheme.primary,
                        onPressed: () => _addItem(),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // ── Liste boşsa EmptyState ────────────────────────────────
                if (allItems.isEmpty)
                  EmptyState(
                    title: 'Alışveriş Listeniz Boş',
                    description:
                        'Ekmek, süt, meyve gibi ihtiyacınız olan ürünleri yukarıdaki arama/ekleme alanından ekleyebilirsiniz.',
                    icon: Icons.shopping_cart_outlined,
                    actionLabel: 'İlk Ürünü Ekle',
                    onActionPressed: () => _inputFocusNode.requestFocus(),
                  )
                else ...[
                  // ── Alınacaklar ───────────────────────────────────────
                  Row(
                    children: [
                      Text(
                        'Alınacaklar',
                        style: AppTypography.titleMedium.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '(${pendingItems.length})',
                        style: AppTypography.titleMedium.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  if (pendingItems.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: AppRadius.borderLg,
                      ),
                      child: Text(
                        'Tüm ürünler alındı! 🎉',
                        style: AppTypography.bodyMedium.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pendingItems.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (_, index) {
                        final item = pendingItems[index];
                        return ShoppingItemTile(
                          item: item,
                          onToggle: (val) => _toggleItem(item.id, val),
                          onDelete: () => _deleteItem(item.id),
                        );
                      },
                    ),

                  const SizedBox(height: AppSpacing.xxl),

                  // ── Alınanlar ─────────────────────────────────────────
                  if (completedItems.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.history_rounded,
                          size: 20,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Alınanlar',
                          style: AppTypography.titleMedium.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          '(${completedItems.length})',
                          style: AppTypography.titleMedium.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: _clearCompleted,
                          icon: const Icon(Icons.delete_sweep_rounded,
                              size: 18),
                          label: const Text('Temizle'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: completedItems.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (_, index) {
                        final item = completedItems[index];
                        return ShoppingItemTile(
                          item: item,
                          onToggle: (val) => _toggleItem(item.id, val),
                          onDelete: () => _deleteItem(item.id),
                        );
                      },
                    ),
                  ],
                ],

                const SizedBox(height: AppSpacing.lg),


                // Alt boşluk (FAB)
                const SizedBox(height: AppSpacing.xxl * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
