import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/app_search_bar.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/no_family_empty_state.dart';
import '../../../shared/widgets/reminder_card.dart';
import '../../shopping/providers/shopping_provider.dart';
import '../models/expiration_model.dart';
import '../providers/expiration_provider.dart';
import 'expiration_form_screen.dart';

/// Son Kullanma Tarihleri Ekranı — Firestore real-time StreamProvider bağlantılı.
/// UI tasarımı orijinal mock yapıyla aynıdır; veri kaynağı Firestore'a taşındı.
class ExpirationScreen extends ConsumerStatefulWidget {
  const ExpirationScreen({super.key});

  @override
  ConsumerState<ExpirationScreen> createState() => _ExpirationScreenState();
}

class _ExpirationScreenState extends ConsumerState<ExpirationScreen> {
  String _searchQuery = '';
  ExpirationStatusFilter _selectedFilter = ExpirationStatusFilter.all;

  // ── Filtre + Arama Mantığı ────────────────────────────────────────────────

  List<ExpirationModel> _applyFilters(List<ExpirationModel> items) {
    return items.where((item) {
      final matchesFilter = switch (_selectedFilter) {
        ExpirationStatusFilter.all => true,
        ExpirationStatusFilter.expired =>
          item.status == ExpirationStatus.expired,
        ExpirationStatusFilter.critical =>
          item.status == ExpirationStatus.critical,
        ExpirationStatusFilter.upcoming =>
          item.status == ExpirationStatus.upcoming,
        ExpirationStatusFilter.safe => item.status == ExpirationStatus.safe,
      };

      final matchesSearch = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.location.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();
  }

  int _countByStatus(List<ExpirationModel> all, ExpirationStatusFilter filter) {
    if (filter == ExpirationStatusFilter.all) return all.length;
    final targetStatus = switch (filter) {
      ExpirationStatusFilter.expired => ExpirationStatus.expired,
      ExpirationStatusFilter.critical => ExpirationStatus.critical,
      ExpirationStatusFilter.upcoming => ExpirationStatus.upcoming,
      ExpirationStatusFilter.safe => ExpirationStatus.safe,
      ExpirationStatusFilter.all => ExpirationStatus.safe,
    };
    return all.where((i) => i.status == targetStatus).length;
  }

  // ── Navigasyon Yardımcıları ───────────────────────────────────────────────

  void _openAddForm() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const ExpirationFormScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  void _openEditForm(ExpirationModel item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ExpirationFormScreen(editItem: item),
        fullscreenDialog: true,
      ),
    );
  }

  // ── Silme Onayı ───────────────────────────────────────────────────────────

  Future<void> _confirmDelete(ExpirationModel item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ürünü Sil'),
        content: Text('"${item.title}" adlı ürün kalıcı olarak silinecek.'),
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
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(expirationNotifierProvider.notifier).deleteItem(item.id);
    }
  }

  Future<void> _confirmBatchDelete() async {
    final items = ref.read(expirationItemsProvider).valueOrNull ?? [];
    final expiredCount = items.where((i) => i.status == ExpirationStatus.expired).length;
    
    if (expiredCount == 0) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Toplu Silme'),
        content: Text('Süresi dolmuş $expiredCount ürünü kalıcı olarak silmek istediğininize emin misiniz?'),
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
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(expirationNotifierProvider.notifier).batchDeleteExpiredItems();
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

    final itemsAsync = ref.watch(expirationItemsProvider);

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
                  'Ürün Ekle',
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
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cloud_off_rounded,
                    size: 56,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Veriler yüklenemedi.',
                    style: AppTypography.titleMedium.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    error.toString(),
                    style: AppTypography.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
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

  // ── Gövde (data geldiğinde) ───────────────────────────────────────────────

  Widget _buildBody(ColorScheme colorScheme, List<ExpirationModel> allItems) {
    final filteredList = _applyFilters(allItems);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontal,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Başlık Alanı ──────────────────────────────────────────────────
          Text(
            'Son Kullanma Tarihleri',
            style: AppTypography.headlineLarge.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Envanterinizdeki ürünlerin tazelik durumunu takip edin.',
            style: AppTypography.bodyLarge.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Arama Alanı ───────────────────────────────────────────────────
          AppSearchBar(
            hintText: 'Ürün adı veya konum ara...',
            onChanged: (query) => setState(() => _searchQuery = query),
            onClear: () => setState(() => _searchQuery = ''),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Filtre Çipleri ────────────────────────────────────────────────
          _buildFilterChips(colorScheme, allItems),

          const SizedBox(height: AppSpacing.xl),
          
          if (filteredList.any((i) => i.status == ExpirationStatus.expired))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _confirmBatchDelete(),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.errorContainer,
                    foregroundColor: AppColors.error,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.borderLg,
                    ),
                  ),
                  icon: const Icon(Icons.delete_sweep_rounded),
                  label: const Text(
                    'Süresi Dolanları Temizle',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

          // ── Ürün Listesi / Grid ───────────────────────────────────────────
          if (filteredList.isEmpty)
            EmptyState(
              title: allItems.isEmpty ? 'Henüz Ürün Yok' : 'Ürün Bulunamadı',
              description: allItems.isEmpty
                  ? 'İlk ürününüzü eklemek için "Ürün Ekle" butonuna basın.'
                  : 'Arama veya filtreleme kriterlerinize uygun ürün bulunmuyor.',
              icon: allItems.isEmpty
                  ? Icons.add_circle_outline_rounded
                  : Icons.search_off_rounded,
              actionLabel: allItems.isEmpty ? 'Ürün Ekle' : 'Filtreleri Temizle',
              onActionPressed: () {
                if (allItems.isEmpty) {
                  _openAddForm();
                } else {
                  setState(() {
                    _searchQuery = '';
                    _selectedFilter = ExpirationStatusFilter.all;
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
                    childAspectRatio: 1.6,
                  ),
                  itemCount: filteredList.length,
                  itemBuilder: (_, index) =>
                      _buildCard(filteredList[index], colorScheme),
                );
              },
            ),

          const SizedBox(height: AppSpacing.lg),


          // Alt boşluk (FAB'ın üstünü kapatmaması için)
          const SizedBox(height: AppSpacing.xxl * 2),
        ],
      ),
    );
  }

  // ── Kart ─────────────────────────────────────────────────────────────────

  Widget _buildCard(ExpirationModel item, ColorScheme colorScheme) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        await _confirmDelete(item);
        return false; // Dialog sonucunu bekliyoruz, Dismissible'ın silmesine izin verme
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
      child: ReminderCard(
        title: item.title,
        subtitle: item.location,
        dateText: item.expirationDateText,
        dateLabel: 'Son Kullanma',
        statusText: item.statusText,
        statusColor: item.statusColor,
        icon: item.icon,
        imageUrl: item.imageUrl,
        showStatusLine: true,
        onTap: () => _openEditForm(item),
        bottomAction: item.status == ExpirationStatus.expired
            ? OutlinedButton.icon(
                onPressed: () {
                  ref.read(shoppingNotifierProvider.notifier).addItem(
                    name: item.title,
                  );
                  ref.read(expirationNotifierProvider.notifier).deleteItem(item.id);
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('"${item.title}" alışveriş listesine eklendi.')),
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.5)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                label: const Text('Çöpe At & Alışverişe Ekle'),
              )
            : null,
      ),
    );
  }

  // ── Filtre Çipleri ────────────────────────────────────────────────────────

  Widget _buildFilterChips(
    ColorScheme colorScheme,
    List<ExpirationModel> allItems,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(
            filter: ExpirationStatusFilter.all,
            label: 'Tümü (${_countByStatus(allItems, ExpirationStatusFilter.all)})',
            colorScheme: colorScheme,
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildFilterChip(
            filter: ExpirationStatusFilter.expired,
            label:
                'Süresi Dolanlar (${_countByStatus(allItems, ExpirationStatusFilter.expired)})',
            colorScheme: colorScheme,
            accentColor: AppColors.error,
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildFilterChip(
            filter: ExpirationStatusFilter.critical,
            label:
                'Kritik (${_countByStatus(allItems, ExpirationStatusFilter.critical)})',
            colorScheme: colorScheme,
            accentColor: AppColors.error,
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildFilterChip(
            filter: ExpirationStatusFilter.upcoming,
            label:
                'Yaklaşan (${_countByStatus(allItems, ExpirationStatusFilter.upcoming)})',
            colorScheme: colorScheme,
            accentColor: AppColors.secondary,
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildFilterChip(
            filter: ExpirationStatusFilter.safe,
            label:
                'Güvenli (${_countByStatus(allItems, ExpirationStatusFilter.safe)})',
            colorScheme: colorScheme,
            accentColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required ExpirationStatusFilter filter,
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
