import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/app_search_bar.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/no_family_empty_state.dart';
import '../models/recipe_model.dart';
import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';
import 'recipe_form_screen.dart';

/// Yemek Tarifleri Ekranı — Firestore real-time StreamProvider bağlantılı.
class RecipesScreen extends ConsumerStatefulWidget {
  const RecipesScreen({super.key});

  @override
  ConsumerState<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends ConsumerState<RecipesScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'Tümü';

  static const List<String> _categories = [
    'Tümü',
    'Ana Yemek',
    'Çorba',
    'Tatlı',
    'Salata',
    'Kahvaltılık',
    'Hamur İşi',
  ];

  List<RecipeModel> _applyFilters(List<RecipeModel> recipes) {
    return recipes.where((r) {
      final matchesCategory =
          _selectedCategory == 'Tümü' || r.category == _selectedCategory;

      final query = _searchQuery.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          r.title.toLowerCase().contains(query) ||
          (r.description?.toLowerCase().contains(query) ?? false) ||
          r.ingredients.any((i) => i.name.toLowerCase().contains(query));

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _openAddForm() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const RecipeFormScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  void _openDetail(RecipeModel recipe) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RecipeDetailScreen(recipeId: recipe.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasFamily = ref.watch(hasRealFamilyProvider);
    final recipesAsync = ref.watch(recipesProvider);

    if (!hasFamily) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: const AppHeader(title: 'Ev Asistanı'),
        body: const SafeArea(child: NoFamilyEmptyState()),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const AppHeader(title: 'Ev Asistanı'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddForm,
        elevation: 4,
        highlightElevation: 8,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderFull,
        ),
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'Tarif Ekle',
          style: AppTypography.titleSmall.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: recipesAsync.when(
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
                    'Tarifler yüklenemedi.',
                    style: AppTypography.titleMedium
                        .copyWith(color: colorScheme.onSurface),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          data: (allRecipes) => _buildBody(colorScheme, allRecipes),
        ),
      ),
    );
  }

  Widget _buildBody(ColorScheme colorScheme, List<RecipeModel> allRecipes) {
    final filteredList = _applyFilters(allRecipes);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontal,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Ekran Başlığı ────────────────────────────────────────────────
          Text(
            'Yemek Tarifleri',
            style: AppTypography.headlineLarge.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Ailenizin tariflerini saklayın, tek tıkla malzemeleri alışveriş listesine aktarın.',
            style: AppTypography.bodyLarge.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Arama Alanı ──────────────────────────────────────────────────
          AppSearchBar(
            hintText: 'Tarif veya malzeme ara...',
            onChanged: (query) => setState(() => _searchQuery = query),
            onClear: () => setState(() => _searchQuery = ''),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Kategori Çipleri ─────────────────────────────────────────────
          _buildCategoryChips(colorScheme),

          const SizedBox(height: AppSpacing.xl),

          // ── Tarif Listesi / Grid ──────────────────────────────────────────
          if (filteredList.isEmpty)
            EmptyState(
              title: allRecipes.isEmpty
                  ? 'Henüz Tarif Eklenmedi'
                  : 'Tarif Bulunamadı',
              description: allRecipes.isEmpty
                  ? 'İlk aile tarifinizi eklemek için "Tarif Ekle" butonuna dokunun.'
                  : 'Arama veya filtreleme kriterlerinize uygun tarif bulunmuyor.',
              icon: allRecipes.isEmpty
                  ? Icons.menu_book_rounded
                  : Icons.search_off_rounded,
              actionLabel:
                  allRecipes.isEmpty ? 'Tarif Ekle' : 'Filtreleri Temizle',
              onActionPressed: () {
                if (allRecipes.isEmpty) {
                  _openAddForm();
                } else {
                  setState(() {
                    _searchQuery = '';
                    _selectedCategory = 'Tümü';
                  });
                }
              },
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount =
                    width > 900 ? 3 : (width > 600 ? 2 : 1);

                if (crossAxisCount == 1) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredList.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (_, index) {
                      final recipe = filteredList[index];
                      return RecipeCard(
                        recipe: recipe,
                        onTap: () => _openDetail(recipe),
                      );
                    },
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: filteredList.length,
                  itemBuilder: (_, index) {
                    final recipe = filteredList[index];
                    return RecipeCard(
                      recipe: recipe,
                      onTap: () => _openDetail(recipe),
                    );
                  },
                );
              },
            ),

          const SizedBox(height: AppSpacing.xxl * 2),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(ColorScheme colorScheme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((cat) {
          final isSelected = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: InkWell(
              onTap: () => setState(() => _selectedCategory = cat),
              borderRadius: AppRadius.borderFull,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHigh,
                  borderRadius: AppRadius.borderFull,
                  boxShadow: isSelected ? AppShadows.xs : AppShadows.none,
                ),
                child: Text(
                  cat,
                  style: AppTypography.labelMedium.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
