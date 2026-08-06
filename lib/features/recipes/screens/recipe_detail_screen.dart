import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/services/shopping_list_service.dart';
import '../../../shared/widgets/primary_button.dart';
import '../models/recipe_model.dart';
import '../providers/recipe_provider.dart';
import 'recipe_form_screen.dart';

/// Yemek Tarifi Detay Ekranı.
///
/// **KRİTİK İŞLEV:** Seçilen malzemeleri tek tıkla Firestore `families/{familyId}/shoppingItems`
/// koleksiyonuna ekleyen "Malzemeleri Alışveriş Listesine Ekle" akışını içerir.
class RecipeDetailScreen extends ConsumerStatefulWidget {
  const RecipeDetailScreen({
    super.key,
    required this.recipeId,
  });

  final String recipeId;

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  /// Malzeme seçimi takibi (index -> secili mi)
  final Set<int> _selectedIngredientIndexes = {};

  bool _isAddingToShoppingList = false;

  void _initSelectedIngredients(List<RecipeIngredientModel> ingredients) {
    if (_selectedIngredientIndexes.isEmpty && ingredients.isNotEmpty) {
      for (var i = 0; i < ingredients.length; i++) {
        _selectedIngredientIndexes.add(i);
      }
    }
  }

  // ── KRİTİK İŞLEV: Malzemeleri Alışveriş Listesine Aktar ─────────────────────

  Future<void> _addIngredientsToShoppingList(
      List<RecipeIngredientModel> ingredients) async {
    if (_selectedIngredientIndexes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen alışveriş listesine eklenecek en az bir malzeme seçin.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isAddingToShoppingList = true);

    final selectedItems = _selectedIngredientIndexes
        .where((idx) => idx < ingredients.length)
        .map((idx) {
      final ing = ingredients[idx];
      final amountText = ing.displayAmount;
      return amountText.isNotEmpty ? '${ing.name} ($amountText)' : ing.name;
    }).toList();

    try {
      await ref
          .read(shoppingListServiceProvider)
          .addBulkItems(selectedItems);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${selectedItems.length} malzeme Alışveriş Listesine eklendi! 🛒',
            ),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata oluştu: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isAddingToShoppingList = false);
    }
  }

  // ── Tarif Silme ───────────────────────────────────────────────────────────

  Future<void> _confirmDelete(RecipeModel recipe) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tarifi Sil'),
        content: Text('"${recipe.title}" tarifini silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('İptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref
          .read(recipeNotifierProvider.notifier)
          .deleteRecipe(recipe.id);
      if (mounted) Navigator.of(context).pop();
    }
  }

  void _openEditForm(RecipeModel recipe) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RecipeFormScreen(editRecipe: recipe),
        fullscreenDialog: true,
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final recipeAsync = ref.watch(recipeDetailProvider(widget.recipeId));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: recipeAsync.when(
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (err, _) => Scaffold(
          appBar: AppBar(),
          body: Center(child: Text('Tarif bilgisi alınamadı: $err')),
        ),
        data: (recipe) {
          if (recipe == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text('Tarif bulunamadı.')),
            );
          }

          _initSelectedIngredients(recipe.ingredients);

          return CustomScrollView(
            slivers: [
              // ── Slivers: Görsel & Esnek AppBar ────────────────────────────
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                backgroundColor: colorScheme.surface,
                iconTheme: IconThemeData(
                  color: colorScheme.onSurface,
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit_rounded),
                    tooltip: 'Düzenle',
                    onPressed: () => _openEditForm(recipe),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded),
                    tooltip: 'Sil',
                    onPressed: () => _confirmDelete(recipe),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: recipe.imageUrl != null &&
                          recipe.imageUrl!.isNotEmpty
                      ? Image.network(
                          recipe.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _buildHeaderPlaceholder(colorScheme),
                        )
                      : _buildHeaderPlaceholder(colorScheme),
                ),
              ),

              // ── İçerik ──────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kategori & Hazırlık Bilgileri
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              borderRadius: AppRadius.borderSm,
                            ),
                            child: Text(
                              recipe.category,
                              style: AppTypography.labelMedium.copyWith(
                                color: colorScheme.onSecondaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Tarif Başlığı
                      Text(
                        recipe.title,
                        style: AppTypography.headlineMedium.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      if (recipe.description != null &&
                          recipe.description!.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          recipe.description!,
                          style: AppTypography.bodyLarge.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],

                      const SizedBox(height: AppSpacing.lg),

                      // ── Bilgi Rozetleri (Süreler & Porsiyon) ───────────────
                      _buildInfoCards(colorScheme, recipe),

                      const SizedBox(height: AppSpacing.xxl),

                      // ── Malzemeler Başlığı & Ekle Butonu ──────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Malzemeler (${recipe.ingredients.length})',
                            style: AppTypography.titleLarge.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                if (_selectedIngredientIndexes.length ==
                                    recipe.ingredients.length) {
                                  _selectedIngredientIndexes.clear();
                                } else {
                                  _selectedIngredientIndexes.clear();
                                  for (var i = 0;
                                      i < recipe.ingredients.length;
                                      i++) {
                                    _selectedIngredientIndexes.add(i);
                                  }
                                }
                              });
                            },
                            child: Text(
                              _selectedIngredientIndexes.length ==
                                      recipe.ingredients.length
                                  ? 'Seçimleri Kaldır'
                                  : 'Tümünü Seç',
                              style: AppTypography.labelMedium.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.sm),

                      // ── Malzemeler Listesi (Checkbox'lı) ─────────────────
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recipe.ingredients.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.xs),
                        itemBuilder: (context, index) {
                          final ing = recipe.ingredients[index];
                          final isSelected =
                              _selectedIngredientIndexes.contains(index);

                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedIngredientIndexes.remove(index);
                                } else {
                                  _selectedIngredientIndexes.add(index);
                                }
                              });
                            },
                            borderRadius: AppRadius.borderMd,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? colorScheme.primaryContainer
                                        .withValues(alpha: 0.2)
                                    : Colors.transparent,
                                borderRadius: AppRadius.borderMd,
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (val) {
                                      setState(() {
                                        if (val == true) {
                                          _selectedIngredientIndexes.add(index);
                                        } else {
                                          _selectedIngredientIndexes
                                              .remove(index);
                                        }
                                      });
                                    },
                                    activeColor: colorScheme.primary,
                                  ),
                                  Expanded(
                                    child: Text(
                                      ing.name,
                                      style: AppTypography.bodyLarge.copyWith(
                                        color: colorScheme.onSurface,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if (ing.displayAmount.isNotEmpty)
                                    Text(
                                      ing.displayAmount,
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  if (ing.isOptional) ...[
                                    const SizedBox(width: AppSpacing.xs),
                                    Text(
                                      '(İsteğe bağlı)',
                                      style: AppTypography.labelSmall.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // ── KRİTİK BUTON: Alışveriş Listesine Ekle ────────────
                      PrimaryButton(
                        text: 'Malzemeleri Alışveriş Listesine Ekle',
                        icon: Icons.add_shopping_cart_rounded,
                        isLoading: _isAddingToShoppingList,
                        onPressed: _isAddingToShoppingList
                            ? null
                            : () => _addIngredientsToShoppingList(
                                  recipe.ingredients,
                                ),
                      ),

                      const SizedBox(height: AppSpacing.xxl),

                      // ── Hazırlanışı / Adımlar ─────────────────────────────
                      Text(
                        'Hazırlanışı',
                        style: AppTypography.titleLarge.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      if (recipe.instructions.isEmpty)
                        Text(
                          'Hazırlanış adımları eklenmemiş.',
                          style: AppTypography.bodyMedium.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recipe.instructions.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: AppSpacing.md),
                          itemBuilder: (context, index) {
                            final stepText = recipe.instructions[index];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor:
                                      colorScheme.primaryContainer,
                                  child: Text(
                                    '${index + 1}',
                                    style: AppTypography.labelMedium.copyWith(
                                      color: colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Text(
                                    stepText,
                                    style: AppTypography.bodyLarge.copyWith(
                                      color: colorScheme.onSurface,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                      const SizedBox(height: AppSpacing.xxl * 2),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderPlaceholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.primaryContainer.withValues(alpha: 0.5),
      child: Center(
        child: Icon(
          Icons.restaurant_rounded,
          size: 72,
          color: colorScheme.primary.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _buildInfoCards(ColorScheme colorScheme, RecipeModel recipe) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoTile(
            colorScheme,
            icon: Icons.timer_outlined,
            label: 'Hazırlama',
            value: '${recipe.prepTimeMinutes} dk',
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildInfoTile(
            colorScheme,
            icon: Icons.soup_kitchen_rounded,
            label: 'Pişirme',
            value: '${recipe.cookTimeMinutes} dk',
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildInfoTile(
            colorScheme,
            icon: Icons.people_outline_rounded,
            label: 'Porsiyon',
            value: '${recipe.servings} Kişi',
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(
    ColorScheme colorScheme, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderMd,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
