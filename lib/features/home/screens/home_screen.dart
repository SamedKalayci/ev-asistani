import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/ad_provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../router/app_router.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/no_family_empty_state.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/pro_blur_overlay.dart';
import '../../expiration/models/expiration_model.dart';
import '../../expiration/providers/expiration_provider.dart';
import '../../expiration/screens/expiration_form_screen.dart';
import '../../profile/providers/family_provider.dart';
import '../../shopping/providers/shopping_provider.dart';
import '../../warranty/models/warranty_model.dart';
import '../../warranty/providers/warranty_provider.dart';
import '../../finance/widgets/quick_add_expense_bottom_sheet.dart';
import '../../finance/providers/finance_provider.dart';
import '../../finance/models/payment_schedule_model.dart';
import '../../vault/providers/vault_provider.dart';
import '../../vault/models/vault_item_model.dart';

/// Ana Sayfa ekranı — Freemium kısıtları, Serbest Bütçe Banner'ı ve Hızlı Ekle FAB entegreli.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static String _formatCurrency(double amount) {
    final isNegative = amount < 0;
    final absAmount = amount.abs().toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < absAmount.length; i++) {
      if (i > 0 && (absAmount.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(absAmount[i]);
    }
    return '${isNegative ? '-' : ''}₺${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasFamily = ref.watch(hasRealFamilyProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final freeBudget = ref.watch(monthlyFreeBudgetProvider);

    if (!hasFamily) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: const AppHeader(title: 'Ev Asistanı'),
        body: const SafeArea(child: NoFamilyEmptyState()),
      );
    }

    // ── Real-time Veri Bağlantıları ───────────────────────────────────────────
    final userAsync = ref.watch(userProvider);
    final familyAsync = ref.watch(currentFamilyProvider);
    final expAsync = ref.watch(expirationItemsProvider);
    final warAsync = ref.watch(warrantyItemsProvider);
    final shopAsync = ref.watch(shoppingItemsProvider);
    final schedulesAsync = ref.watch(paymentSchedulesProvider);
    final vaultAsync = ref.watch(vaultItemsProvider);

    final user = userAsync.valueOrNull;
    final family = familyAsync.valueOrNull;
    final expItems = expAsync.valueOrNull ?? [];
    final warItems = warAsync.valueOrNull ?? [];
    final shopItems = shopAsync.valueOrNull ?? [];
    final schedules = schedulesAsync.valueOrNull ?? [];
    final vaultItems = vaultAsync.valueOrNull ?? [];

    final maintenanceItems = vaultItems
        .where((i) => i.category == 'maintenance' && !i.isCompleted && i.dueDate != null)
        .toList();
    maintenanceItems.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

    final userName = (user?.displayName.isNotEmpty == true)
        ? user!.displayName.split(' ').first
        : 'Samed';

    final familyName = (family?.name.isNotEmpty == true)
        ? family!.name
        : 'Kalaycı Home';

    // ── İstatistik Hesaplamaları ─────────────────────────────────────────────
    final inventoryCount = expItems.length + warItems.length;
    final upcomingExpirations = expItems
        .where((i) =>
            i.status == ExpirationStatus.expired ||
            i.status == ExpirationStatus.critical ||
            i.status == ExpirationStatus.upcoming)
        .toList();
    final upcomingWarranties = warItems
        .where((i) =>
            i.status == WarrantyStatus.upcoming ||
            i.status == WarrantyStatus.expired)
        .toList();

    // Ücretsiz kullanıcı kısıtı: isPremium == false ise sadece 1 acil ürün
    final displayExpirations = isPremium
        ? upcomingExpirations.take(4).toList()
        : upcomingExpirations.take(1).toList();

    final displayWarranties = isPremium
        ? upcomingWarranties.take(4).toList()
        : upcomingWarranties.take(1).toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const AppHeader(title: 'Ev Asistanı'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQuickAddBottomSheet(context, ref),
        elevation: 4,
        highlightElevation: 8,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderFull,
        ),
        icon: const Icon(Icons.add_rounded, size: 22),
        label: Text(
          'Hızlı Ekle',
          style: AppTypography.titleSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Üst Başlık & Ev İsmi ───────────────────────────────────────
              _buildGreetingHeader(colorScheme, userName, familyName),

              const SizedBox(height: AppSpacing.xl),

              // ── Bento Stat Kartları (2x2 Grid) ───────────────────────────
              _buildBentoStatGrid(
                context,
                colorScheme,
                inventoryCount: inventoryCount,
                expirationCount: expItems.length,
                warrantyCount: warItems.length,
                shoppingCount: shopItems.length,
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Kalan Serbest Bütçe (Nakit Akışı) Özet Kartı ─────────────
              _buildBudgetOverviewBanner(context, colorScheme, isPremium, freeBudget),

              const SizedBox(height: AppSpacing.xxl),

              // ── Son Kullanma Tarihleri Yaklaşıyor ──────────────────────────
              _buildUpcomingExpirationsSection(
                context,
                colorScheme,
                displayExpirations,
              ),

              const SizedBox(height: AppSpacing.xxl),

              // ── Garanti Süresi Yaklaşıyor ─────────────────────────────────
              _buildUpcomingWarrantiesSection(
                context,
                colorScheme,
                displayWarranties,
              ),

              const SizedBox(height: AppSpacing.xxl),

              // ── Yaklaşan Periyodik Bakımlar ──────────────────────────────
              _buildUpcomingMaintenanceSection(context, colorScheme, maintenanceItems),

              if (maintenanceItems.isNotEmpty) const SizedBox(height: AppSpacing.xxl),

              // ── Yaklaşan Ödemeler Mini Kartı ──────────────────────────────
              _buildUpcomingPaymentsSection(context, colorScheme, schedules),

              // Alt FAB boşluğu
              const SizedBox(height: AppSpacing.xxl * 2.5),
            ],
          ),
        ),
      ),
    );
  }

  // ── 1. Üst Başlık & Karşılama ─────────────────────────────────────────────

  Widget _buildGreetingHeader(
    ColorScheme colorScheme,
    String userName,
    String familyName,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Merhaba $userName',
          style: AppTypography.headlineLarge.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Evindeki her şey yolunda görünüyor.',
          style: AppTypography.bodyMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: Text(
                '$familyName 👋',
                style: AppTypography.displayMedium.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── 2. Bento Stat Kartları (4'lü 2x2 Grid) ────────────────────────────────

  Widget _buildBentoStatGrid(
    BuildContext context,
    ColorScheme colorScheme, {
    required int inventoryCount,
    required int expirationCount,
    required int warrantyCount,
    required int shoppingCount,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: AppRadius.borderXl,
        boxShadow: AppShadows.xs,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Üst Satır: Envanter & Son Kullanma
          Row(
            children: [
              Expanded(
                child: _buildMiniStatCard(
                  context,
                  colorScheme,
                  title: 'Envanter',
                  value: '$inventoryCount',
                  iconWidget: const Icon(
                    Icons.inventory_2_rounded,
                    color: Color(0xFFD97706),
                    size: 26,
                  ),
                  onTap: () => context.go(AppRoutes.inventory),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildMiniStatCard(
                  context,
                  colorScheme,
                  title: 'Son Kullanma',
                  value: '$expirationCount',
                  iconWidget: const Icon(
                    Icons.alarm_rounded,
                    color: Color(0xFFEF4444),
                    size: 26,
                  ),
                  onTap: () => context.go(AppRoutes.inventory),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Alt Satır: Garanti & Alışveriş
          Row(
            children: [
              Expanded(
                child: _buildMiniStatCard(
                  context,
                  colorScheme,
                  title: 'Garanti',
                  value: '$warrantyCount',
                  iconWidget: const Icon(
                    Icons.shield_outlined,
                    color: Color(0xFF2563EB),
                    size: 26,
                  ),
                  onTap: () => context.go(AppRoutes.inventory),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildMiniStatCard(
                  context,
                  colorScheme,
                  title: 'Alışveriş',
                  value: '$shoppingCount',
                  iconWidget: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Color(0xFF7C3AED),
                    size: 26,
                  ),
                  onTap: () => context.go(AppRoutes.shopping),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStatCard(
    BuildContext context,
    ColorScheme colorScheme, {
    required String title,
    required String value,
    required Widget iconWidget,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.borderLg,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow.withValues(alpha: 0.6),
          borderRadius: AppRadius.borderLg,
        ),
        child: Row(
          children: [
            iconWidget,
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelSmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: AppTypography.titleLarge.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
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

  // ── 3. Kalan Serbest Bütçe (Nakit Akışı) Özet Kartı ────────────────────────

  Widget _buildBudgetOverviewBanner(
    BuildContext context,
    ColorScheme colorScheme,
    bool isPremium,
    double freeBudget,
  ) {
    final innerContent = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8F5E9),
            Color(0xFFDCFCE7),
          ],
        ),
        borderRadius: AppRadius.borderXl,
        boxShadow: AppShadows.xs,
        border: Border.all(
          color: AppColors.primaryContainer.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Kalan Serbest Bütçe',
                    style: AppTypography.titleMedium.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF60A5FA), Color(0xFF3B82F6)],
                  ),
                  borderRadius: AppRadius.borderFull,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('👑', style: TextStyle(fontSize: 10)),
                    const SizedBox(width: 3),
                    Text(
                      'PRO',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _formatCurrency(freeBudget),
                style: AppTypography.displayMedium.copyWith(
                  color: freeBudget >= 0 ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w800,
                  fontSize: 30,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '/ bu ay',
                style: AppTypography.titleMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Aylık net gelirden sabit giderler düşüldükten sonra kalan tutar.',
            style: AppTypography.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: 'İncele',
                    onPressed: () => context.go(AppRoutes.finance),
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => QuickAddExpenseBottomSheet.show(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.borderLg,
                      ),
                    ),
                    icon: const Icon(Icons.flash_on_rounded, size: 18),
                    label: const Text(
                      'Harcama Gir',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return ProBlurOverlay(
      isLocked: !isPremium,
      title: 'Serbest Nakit Akışını Görmek İçin PRO\'ya Geç',
      subtitle: 'Aylık net nakit akışınızı ve kullanılabilir bütçenizi anlık grafiklerle takip edin.',
      child: innerContent,
    );
  }

  // ── 4. Son Kullanma Tarihleri Yaklaşıyor ───────────────────────────────────

  Widget _buildUpcomingExpirationsSection(
    BuildContext context,
    ColorScheme colorScheme,
    List<ExpirationModel> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Başlık & Tümünü Gör
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Son Kullanma Tarihleri\nYaklaşıyor',
              style: AppTypography.titleLarge.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            TextButton(
              onPressed: () => context.go(AppRoutes.inventory),
              child: Text(
                'Tümünü\nGör',
                textAlign: TextAlign.right,
                style: AppTypography.labelLarge.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        if (items.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: AppRadius.borderLg,
            ),
            child: Text(
              'Yaklaşan son kullanma tarihi bulunan ürün yok. 👍',
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
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildExpirationCardTile(context, colorScheme, item);
            },
          ),
      ],
    );
  }

  Widget _buildExpirationCardTile(
    BuildContext context,
    ColorScheme colorScheme,
    ExpirationModel item,
  ) {
    return InkWell(
      onTap: () => context.go(AppRoutes.inventory),
      borderRadius: AppRadius.borderLg,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: AppRadius.borderLg,
          boxShadow: AppShadows.xs,
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTypography.titleMedium.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.location.isNotEmpty ? item.location : 'Buzdolabı'} • 1 Adet',
                    style: AppTypography.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFDE8E8),
                borderRadius: AppRadius.borderFull,
              ),
              child: Text(
                item.remainingDaysText,
                style: AppTypography.labelMedium.copyWith(
                  color: const Color(0xFFE53935),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 5. Garanti Süresi Yaklaşıyor ──────────────────────────────────────────

  Widget _buildUpcomingWarrantiesSection(
    BuildContext context,
    ColorScheme colorScheme,
    List<WarrantyModel> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Garanti Süresi Yaklaşıyor',
              style: AppTypography.titleLarge.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.go(AppRoutes.inventory),
              child: Text(
                'Tümünü Gör',
                style: AppTypography.labelLarge.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        if (items.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: AppRadius.borderLg,
            ),
            child: Text(
              'Yaklaşan garanti bitişi bulunmuyor. 👍',
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
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildWarrantyCardTile(context, colorScheme, item);
            },
          ),
      ],
    );
  }

  Widget _buildWarrantyCardTile(
    BuildContext context,
    ColorScheme colorScheme,
    WarrantyModel item,
  ) {
    return InkWell(
      onTap: () => context.go(AppRoutes.inventory),
      borderRadius: AppRadius.borderLg,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: AppRadius.borderLg,
          boxShadow: AppShadows.xs,
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFE3F2FD),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: const Color(0xFF1976D2),
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AppTypography.titleMedium.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.brand.isNotEmpty ? item.brand : 'Genel'} • ${item.store.isNotEmpty ? item.store : 'Mağaza'}',
                    style: AppTypography.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: AppRadius.borderFull,
              ),
              child: Text(
                item.remainingText,
                style: AppTypography.labelMedium.copyWith(
                  color: const Color(0xFF1E88E5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 6. Yaklaşan Ödemeler Mini Kartı ────────────────────────────────────────

  Widget _buildUpcomingPaymentsSection(
    BuildContext context,
    ColorScheme colorScheme,
    List<PaymentScheduleModel> schedules,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final upcomingExpenses = schedules
        .where((s) => !s.isPaid && !s.isIncome)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Yaklaşan Ödemeler',
              style: AppTypography.titleLarge.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.go(AppRoutes.finance),
              child: Text(
                'Tümünü Gör',
                style: AppTypography.labelLarge.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (upcomingExpenses.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: AppRadius.borderLg,
            ),
            child: Text(
              'Yaklaşan ödeme bulunmuyor. 👍',
              style: AppTypography.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          )
        else
          _buildPaymentScheduleCardTile(
            context,
            colorScheme,
            upcomingExpenses.first,
            today,
          ),
      ],
    );
  }

  Widget _buildPaymentScheduleCardTile(
    BuildContext context,
    ColorScheme colorScheme,
    PaymentScheduleModel schedule,
    DateTime today,
  ) {
    final scheduleDate = DateTime(schedule.date.year, schedule.date.month, schedule.date.day);
    final differenceInDays = scheduleDate.difference(today).inDays;
    final String remainingText;
    final Color tagBgColor;
    final Color tagTextColor;

    if (differenceInDays < 0) {
      remainingText = '${differenceInDays.abs()} Günü Geçti';
      tagBgColor = const Color(0xFFFDE8E8);
      tagTextColor = const Color(0xFFE53935);
    } else if (differenceInDays == 0) {
      remainingText = 'Bugün!';
      tagBgColor = const Color(0xFFFDE8E8);
      tagTextColor = const Color(0xFFE53935);
    } else {
      remainingText = '$differenceInDays Gün Kaldı';
      tagBgColor = const Color(0xFFFEF3C7);
      tagTextColor = const Color(0xFFD97706);
    }

    final monthName = _getTurkishMonthName(schedule.date.month);
    final accountText = (schedule.accountName != null && schedule.accountName!.isNotEmpty)
        ? ' • ${schedule.accountName}'
        : '';
    final subtitleText = '${schedule.date.day} $monthName$accountText';

    return InkWell(
      onTap: () => context.go(AppRoutes.finance),
      borderRadius: AppRadius.borderLg,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: AppRadius.borderLg,
          boxShadow: AppShadows.xs,
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: tagBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_month_rounded,
                color: tagTextColor,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.title,
                    style: AppTypography.titleMedium.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitleText,
                    style: AppTypography.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatCurrency(schedule.amount),
                  style: AppTypography.titleMedium.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: tagBgColor,
                    borderRadius: AppRadius.borderFull,
                  ),
                  child: Text(
                    remainingText,
                    style: AppTypography.labelSmall.copyWith(
                      color: tagTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _getTurkishMonthName(int month) {
    const months = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık'
    ];
    return months[month - 1];
  }

  // ── 7. Hızlı Ekle Bottom Sheet ──────────────────────────────────────────────

  Widget _buildUpcomingMaintenanceSection(
    BuildContext context,
    ColorScheme colorScheme,
    List<VaultItemModel> maintenanceItems,
  ) {
    if (maintenanceItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.build_circle_outlined, size: 20, color: Color(0xFF2563EB)),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Yaklaşan Periyodik Bakımlar',
                  style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              '${maintenanceItems.length} Görev',
              style: AppTypography.labelSmall.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: maintenanceItems.take(3).length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final item = maintenanceItems[index];
            return Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: AppRadius.borderLg,
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      borderRadius: AppRadius.borderMd,
                    ),
                    child: const Icon(Icons.build_rounded, size: 20, color: Color(0xFF2563EB)),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.description.isNotEmpty)
                          Text(
                            item.description,
                            style: AppTypography.labelSmall.copyWith(color: colorScheme.onSurfaceVariant),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.borderFull,
                      border: Border.all(color: const Color(0xFF93C5FD)),
                    ),
                    child: Text(
                      item.remainingDaysText,
                      style: AppTypography.labelSmall.copyWith(
                        color: const Color(0xFF1E40AF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _showQuickAddBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: AppRadius.borderTopXl,
          ),
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: AppRadius.borderFull,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Hızlı Ekle',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFDE8E8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.alarm_add_rounded, color: Color(0xFFE53935)),
                ),
                title: Text(
                  'Son Kullanma Tarihli Ürün',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Buzdolabı veya kilerdeki gıda/ilaç takibi'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ExpirationFormScreen()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE3F2FD),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF1E88E5)),
                ),
                title: Text(
                  'Alışveriş Listesine Ürün Ekle',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Eksilen gıda, temizlik ve ev ihtiyaçları'),
                onTap: () {
                  Navigator.pop(context);
                  _showShoppingQuickAddBottomSheet(context, ref);
                },
              ),
              const Divider(),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.flash_on_rounded, color: AppColors.primary),
                ),
                title: Text(
                  'Hızlı Harcama Ekle',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Ev cüzdanına hızlı harcama kaydı'),
                onTap: () {
                  Navigator.pop(context);
                  QuickAddExpenseBottomSheet.show(context);
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    );
  }

  void _showShoppingQuickAddBottomSheet(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(ctx).colorScheme.surfaceContainerLowest,
            borderRadius: AppRadius.borderTopXl,
          ),
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.xl + bottomInset,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(ctx).colorScheme.outlineVariant,
                    borderRadius: AppRadius.borderFull,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '🛒 Alışveriş Listesine Ürün Ekle',
                style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: controller,
                label: 'Ürün Adı',
                hintText: 'Örn: Süt, Ekmek, Yumurta...',
                autofocus: true,
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                text: 'Listeye Ekle',
                icon: Icons.add_shopping_cart_rounded,
                onPressed: () async {
                  final text = controller.text.trim();
                  if (text.isEmpty) return;
                  Navigator.pop(ctx);
                  await ref.read(shoppingNotifierProvider.notifier).addItem(name: text);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('"$text" alışveriş listesine eklendi! 🛒')),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
