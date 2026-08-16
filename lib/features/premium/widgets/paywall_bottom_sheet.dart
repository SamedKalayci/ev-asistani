import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/controllers/purchase_controller.dart';
import '../../../core/providers/ad_provider.dart';
import '../../../core/providers/purchase_provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/l10n_helper.dart';
import '../../../shared/widgets/primary_button.dart';
import 'package:ev_asistani/l10n/app_localizations.dart';

/// RevenueCat üzerinden dynamic Offerings getiren provider.
final offeringsProvider = FutureProvider<Offerings?>((ref) async {
  if (kIsWeb) return null;
  try {
    final service = ref.read(purchaseServiceProvider);
    return await service.getOfferings();
  } catch (_) {
    return null;
  }
});

/// Şık ve dönüştürme odaklı Reklamsız Gösterim Paywall BottomSheet bileşeni.
class PaywallBottomSheet extends ConsumerStatefulWidget {
  const PaywallBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PaywallBottomSheet(),
    );
  }

  @override
  ConsumerState<PaywallBottomSheet> createState() => _PaywallBottomSheetState();
}

class _PaywallBottomSheetState extends ConsumerState<PaywallBottomSheet> {
  // 0: Yıllık Plan (Önerilen), 1: Aylık Plan
  int _selectedPlanIndex = 0;
  bool _isLoading = false;

  Future<void> _handlePurchase(Package? annualPkg, Package? monthlyPkg) async {
    setState(() => _isLoading = true);

    try {
      final selectedPackage = _selectedPlanIndex == 0 ? annualPkg : monthlyPkg;

      if (selectedPackage != null) {
        // Native App Store veya Google Play ödeme akışını tetikle
        final success = await ref
            .read(purchaseControllerProvider.notifier)
            .purchasePackage(selectedPackage);
        if (success) {
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.adFreeActivatedToast),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Paketler henüz yüklenmedi veya bulunamadı. Lütfen daha sonra tekrar deneyin.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ödeme gerçekleştirilemedi: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRestore() async {
    setState(() => _isLoading = true);
    try {
      final success = await ref
          .read(purchaseControllerProvider.notifier)
          .restorePurchases();
      if (mounted) {
        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.purchasesRestoredToast),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          // Firestore aktifliğini kontrol et ve gerekirse güncelle
          await ref.read(isAdFreeProvider.notifier).setAdFreeForFamily();
          if (mounted) Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Geri yükleme işlemi başarısız: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isIOS = !kIsWeb && Platform.isIOS;
    final cancelNoticeText = isIOS
        ? l10n.cancelNoticeIos
        : l10n.cancelNoticeAndroid;

    // RevenueCat dynamic offerings dinleme
    final offeringsAsync = ref.watch(offeringsProvider);
    final offerings = offeringsAsync.valueOrNull;

    Package? annualPkg;
    Package? monthlyPkg;

    if (offerings != null && offerings.current != null) {
      annualPkg = offerings.current!.annual;
      monthlyPkg = offerings.current!.monthly;
    }

    final annualPriceText = annualPkg?.storeProduct.priceString ?? '₺249.99 / Yıl';
    final monthlyPriceText = monthlyPkg?.storeProduct.priceString ?? '₺29.99 / Ay';

    final ctaLabel = _selectedPlanIndex == 0
        ? '${l10n.switchToAnnualPlan} ($annualPriceText)'
        : '${l10n.switchToMonthlyPlan} ($monthlyPriceText)';

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: AppRadius.borderTopXl,
        boxShadow: AppShadows.lg,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
            // Üst Bar & Kapat Butonu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.6),
                    borderRadius: AppRadius.borderFull,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xs),

            // Rozet İkonu
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: AppShadows.md,
              ),
              child: const Center(
                child: Icon(
                  Icons.block_rounded,
                  color: Colors.white,
                  size: 38,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Başlık & Alt Başlık
            Text(
              l10n.adFreeTitle,
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.adFreeHeaderSubtitle,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Avantajlar Listesi
            _buildFeatureTile(
              colorScheme,
              icon: Icons.flash_on_rounded,
              title: l10n.zeroAdsTitle,
              subtitle: l10n.zeroAdsSubtitle,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildFeatureTile(
              colorScheme,
              icon: Icons.groups_rounded,
              title: l10n.allFamilyIncludedTitle,
              subtitle: l10n.allFamilyIncludedSubtitle,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildFeatureTile(
              colorScheme,
              icon: Icons.speed_rounded,
              title: l10n.fasterPageTransitionsTitle,
              subtitle: l10n.fasterPageTransitionsSubtitle,
            ),

            const SizedBox(height: AppSpacing.xl),

            // Plan Seçenekleri
            _buildPlanOptionTile(
              index: 0,
              title: l10n.annualPlanRecommended,
              priceText: annualPriceText,
              subPriceText: l10n.annualPlanSubprice,
              badgeText: l10n.save30Percent,
              badgeIsGold: true,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildPlanOptionTile(
              index: 1,
              title: l10n.monthlyPlanTitle,
              priceText: monthlyPriceText,
              subPriceText: l10n.cancelAnytimeSubprice,
              badgeText: l10n.flexibleBadge,
              badgeIsGold: false,
              colorScheme: colorScheme,
            ),

            const SizedBox(height: AppSpacing.xl),

            // CTA Butonu
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: ctaLabel,
                isLoading: _isLoading,
                onPressed: () => _handlePurchase(annualPkg, monthlyPkg),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),
            Text(
              cancelNoticeText,
              textAlign: TextAlign.center,
              style: AppTypography.labelSmall.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final Uri url = Uri.parse(
                        'https://samedkalayci.github.io/ev-asistani-privacy/');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Text(
                    l10n.termsOfUseEula,
                    style: AppTypography.labelSmall.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Text(
                  ' • ',
                  style: AppTypography.labelSmall.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final Uri url = Uri.parse(
                        'https://samedkalayci.github.io/ev-asistani-privacy/');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Text(
                    l10n.privacyPolicy,
                    style: AppTypography.labelSmall.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            TextButton(
              onPressed: _isLoading ? null : _handleRestore,
              child: Text(
                l10n.restorePurchases,
                style: AppTypography.labelMedium.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    ),
  ),
);
}

  Widget _buildFeatureTile(
    ColorScheme colorScheme, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.25),
            borderRadius: AppRadius.borderMd,
          ),
          child: Icon(icon, color: colorScheme.primary, size: 22),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlanOptionTile({
    required int index,
    required String title,
    required String priceText,
    required String subPriceText,
    required String? badgeText,
    required bool badgeIsGold,
    required ColorScheme colorScheme,
  }) {
    final isSelected = _selectedPlanIndex == index;

    final badgeColors = badgeIsGold
        ? const [Color(0xFFF59E0B), Color(0xFFD97706)]
        : [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.85)];

    return InkWell(
      onTap: () => setState(() => _selectedPlanIndex = index),
      borderRadius: AppRadius.borderLg,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer.withValues(alpha: 0.2)
              : colorScheme.surfaceContainerLow,
          borderRadius: AppRadius.borderLg,
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant.withValues(alpha: 0.4),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: AppSpacing.sm),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? colorScheme.primary : colorScheme.outlineVariant,
                  width: isSelected ? 6 : 2,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (badgeText != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: badgeColors,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: AppRadius.borderSm,
                          ),
                          child: Text(
                            badgeText,
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subPriceText,
                    style: AppTypography.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              priceText,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
