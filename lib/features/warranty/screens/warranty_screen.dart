import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/providers/user_provider.dart';

import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/app_search_bar.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/no_family_empty_state.dart';
import '../models/warranty_model.dart';
import '../providers/warranty_provider.dart';
import '../widgets/warranty_card.dart';
import 'warranty_form_screen.dart';

/// Garanti Takibi Ekranı — Firestore real-time StreamProvider bağlantılı.
/// Mock data kaldırıldı; UI tasarımı aynen korundu.
class WarrantyScreen extends ConsumerStatefulWidget {
  const WarrantyScreen({super.key});

  @override
  ConsumerState<WarrantyScreen> createState() => _WarrantyScreenState();
}

class _WarrantyScreenState extends ConsumerState<WarrantyScreen> {
  String _searchQuery = '';
  WarrantyStatusFilter _selectedFilter = WarrantyStatusFilter.all;

  // ── Filtre + Arama ────────────────────────────────────────────────────────

  List<WarrantyModel> _applyFilters(List<WarrantyModel> items) {
    return items.where((item) {
      final matchesFilter = switch (_selectedFilter) {
        WarrantyStatusFilter.all => true,
        WarrantyStatusFilter.active => item.status == WarrantyStatus.active,
        WarrantyStatusFilter.upcoming => item.status == WarrantyStatus.upcoming,
        WarrantyStatusFilter.expired => item.status == WarrantyStatus.expired,
      };

      final query = _searchQuery.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.brand.toLowerCase().contains(query) ||
          item.store.toLowerCase().contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  int _countByFilter(List<WarrantyModel> all, WarrantyStatusFilter filter) {
    if (filter == WarrantyStatusFilter.all) return all.length;
    final targetStatus = switch (filter) {
      WarrantyStatusFilter.active => WarrantyStatus.active,
      WarrantyStatusFilter.upcoming => WarrantyStatus.upcoming,
      WarrantyStatusFilter.expired => WarrantyStatus.expired,
      WarrantyStatusFilter.all => WarrantyStatus.active,
    };
    return all.where((i) => i.status == targetStatus).length;
  }

  // ── Navigasyon ────────────────────────────────────────────────────────────

  void _openAddForm() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const WarrantyFormScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  void _openEditForm(WarrantyModel item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WarrantyFormScreen(editItem: item),
        fullscreenDialog: true,
      ),
    );
  }

  // ── Silme Onayı ───────────────────────────────────────────────────────────

  Future<void> _confirmDelete(WarrantyModel item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Garanti Kaydını Sil'),
        content: Text('"${item.name}" adlı kayıt kalıcı olarak silinecek.'),
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
          .read(warrantyNotifierProvider.notifier)
          .deleteItem(item.id);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasFamily = ref.watch(hasRealFamilyProvider);
    final itemsAsync = ref.watch(warrantyItemsProvider);

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
      floatingActionButton: itemsAsync.maybeWhen(
        data: (allItems) => allItems.isEmpty
            ? null
            : FloatingActionButton.extended(
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
                  'Garanti Ekle',
                  style: AppTypography.titleSmall.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
        orElse: () => null,
      ),
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
                    'Garanti kayıtları yüklenemedi.',
                    style: AppTypography.titleMedium
                        .copyWith(color: colorScheme.onSurface),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          data: (allItems) => _buildBody(colorScheme, allItems),
        ),
      ),
    );
  }

  // ── Gövde ─────────────────────────────────────────────────────────────────

  Widget _buildBody(ColorScheme colorScheme, List<WarrantyModel> allItems) {
    final filteredList = _applyFilters(allItems);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontal,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Başlık ────────────────────────────────────────────────────────
          Text(
            'Garanti Takibi',
            style: AppTypography.headlineLarge.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Cihazlarınızın ve eşyalarınızın garanti sürelerini takip edin.',
            style: AppTypography.bodyLarge.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Arama ─────────────────────────────────────────────────────────
          AppSearchBar(
            hintText: 'Cihaz, marka veya mağaza ara...',
            onChanged: (query) => setState(() => _searchQuery = query),
            onClear: () => setState(() => _searchQuery = ''),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Filtreler ─────────────────────────────────────────────────────
          _buildFilterChips(colorScheme, allItems),

          const SizedBox(height: AppSpacing.xl),

          // ── Liste ─────────────────────────────────────────────────────────
          if (filteredList.isEmpty)
            EmptyState(
              title: allItems.isEmpty
                  ? 'Henüz Garanti Kaydı Yok'
                  : 'Garanti Kaydı Bulunamadı',
              description: allItems.isEmpty
                  ? 'İlk garanti kaydınızı eklemek için "Garanti Ekle" butonuna basın.'
                  : 'Arama veya filtreleme kriterlerinize uygun kayıt bulunmuyor.',
              icon: allItems.isEmpty
                  ? Icons.verified_outlined
                  : Icons.search_off_rounded,
              actionLabel:
                  allItems.isEmpty ? 'Garanti Ekle' : 'Filtreleri Temizle',
              onActionPressed: () {
                if (allItems.isEmpty) {
                  _openAddForm();
                } else {
                  setState(() {
                    _searchQuery = '';
                    _selectedFilter = WarrantyStatusFilter.all;
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
                    itemBuilder: (_, index) =>
                        _buildCard(filteredList[index], colorScheme),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.4,
                  ),
                  itemCount: filteredList.length,
                  itemBuilder: (_, index) =>
                      _buildCard(filteredList[index], colorScheme),
                );
              },
            ),

          const SizedBox(height: AppSpacing.lg),


          const SizedBox(height: AppSpacing.xxl * 2),
        ],
      ),
    );
  }

  // ── Kart ─────────────────────────────────────────────────────────────────

  Widget _buildCard(WarrantyModel item, ColorScheme colorScheme) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        await _confirmDelete(item);
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.15),
          borderRadius: AppRadius.borderLg,
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: AppColors.error,
          size: 28,
        ),
      ),
      child: WarrantyCard(
        item: item,
        onTap: () => _openEditForm(item),
      ),
    );
  }

  // ── Filtre Çipleri ────────────────────────────────────────────────────────

  Widget _buildFilterChips(
      ColorScheme colorScheme, List<WarrantyModel> allItems) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(
            filter: WarrantyStatusFilter.all,
            label:
                'Tümü (${_countByFilter(allItems, WarrantyStatusFilter.all)})',
            colorScheme: colorScheme,
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildFilterChip(
            filter: WarrantyStatusFilter.active,
            label:
                'Aktif (${_countByFilter(allItems, WarrantyStatusFilter.active)})',
            colorScheme: colorScheme,
            accentColor: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildFilterChip(
            filter: WarrantyStatusFilter.upcoming,
            label:
                'Yaklaşanlar (${_countByFilter(allItems, WarrantyStatusFilter.upcoming)})',
            colorScheme: colorScheme,
            accentColor: AppColors.tertiary,
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildFilterChip(
            filter: WarrantyStatusFilter.expired,
            label:
                'Süresi Dolanlar (${_countByFilter(allItems, WarrantyStatusFilter.expired)})',
            colorScheme: colorScheme,
            accentColor: AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required WarrantyStatusFilter filter,
    required String label,
    required ColorScheme colorScheme,
    Color? accentColor,
  }) {
    final isSelected = _selectedFilter == filter;
    final bgColor = isSelected
        ? (accentColor ?? colorScheme.primary)
        : colorScheme.surfaceContainerHigh;
    final fgColor = isSelected ? Colors.white : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: () => setState(() => _selectedFilter = filter),
      borderRadius: AppRadius.borderFull,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppRadius.borderFull,
          boxShadow: isSelected ? AppShadows.xs : AppShadows.none,
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: fgColor,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
