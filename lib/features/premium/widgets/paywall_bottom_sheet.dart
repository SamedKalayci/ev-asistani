import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/services/ad_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../shared/widgets/primary_button.dart';

import '../../../core/controllers/purchase_controller.dart';

/// Modern ve yüksek dönüşüm odaklı Paywall BottomSheet bileşeni.
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
  int _selectedPlanIndex = 0; // 0: Yıllık, 1: Aylık
  bool _isLoading = false;

  Future<void> _handlePurchase() async {
    setState(() => _isLoading = true);

    try {
      final user = ref.read(userProvider).valueOrNull;

      // 1. AdService local flag güncelleme (isPremiumProvider Firestore'dan reaktif güncellenir)
      AdService.instance.setPremium(true);

      // 2. Firestore Kullanıcı Dökümanı Güncellemesi (families koleksiyonu da güncellenir)
      if (user != null) {
        final firestoreService = ref.read(firestoreServiceProvider);
        final familyId = ref.read(activeFamilyIdProvider);

        // 2a. users/{uid}.isPremium = true
        await firestoreService.updateUserProfile(user.uid, {
          'isPremium': true,
          'premiumPurchasedAt': DateTime.now().toIso8601String(),
        });

        // 2b. families/{familyId}.isPremium = true (Aile Boyu PRO)
        if (familyId.isNotEmpty) {
          await firestoreService.updateFamily(familyId, {
            'isPremium': true,
          });
        }
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Tebrikler! Ev Asistanı PRO üyeliğiniz aktif edildi!'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('İşlem gerçekleştirilemedi: $e'),
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
      final success = await ref.read(purchaseControllerProvider.notifier).restorePurchases();
      if (mounted) {
        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🎉 Satın alımlarınız başarıyla geri yüklendi!'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          // Firebase profilindeki isPremium durumunu kontrol et
          await _handlePurchase();
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isIOS = !kIsWeb && Platform.isIOS;
    final cancelNoticeText = isIOS
        ? 'İstediğiniz zaman App Store / Apple ID ayarlarınızdan iptal edebilirsiniz.'
        : 'İstediğiniz zaman Google Play Store ayarlarınızdan iptal edebilirsiniz.';

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.92,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: AppRadius.borderTopXl,
        boxShadow: AppShadows.lg,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Üst Bar & Kapat Butonu ────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40), // Dengeli hizalama
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

            // ── 👑 3D/Vektör Taç Rozeti ─────────────────────────────────────
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: AppShadows.md,
              ),
              child: const Center(
                child: Text(
                  '👑',
                  style: TextStyle(fontSize: 38),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // ── Başlık & Alt Başlık ──────────────────────────────────────────
            Text(
              'Ev Asistanı PRO\'ya Geçin',
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Evinizi akıllı, düzenli ve finansal açıdan güvende tutun.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // ── PRO Avantajları Listesi ───────────────────────────────────────
            _buildFeatureTile(
              colorScheme,
              emoji: '👑',
              title: 'Dijital Ev Kasası',
              subtitle: 'Belgeler, garantiler ve acil durum rehberi.',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildFeatureTile(
              colorScheme,
              emoji: '📊',
              title: 'Finans & Nakit Akışı',
              subtitle: 'Gelir/gider takibi ve kalan bütçe analizi.',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildFeatureTile(
              colorScheme,
              emoji: '🔔',
              title: 'Akıllı Hatırlatıcılar',
              subtitle: 'Sınırsız son kullanma tarihi ve garanti uyarısı.',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildFeatureTile(
              colorScheme,
              emoji: '👥',
              title: 'Sınırsız Aile Paylaşımı',
              subtitle: 'Tüm ev halkıyla anlık Firestore senkronizasyonu.',
            ),

            const SizedBox(height: AppSpacing.xl),

            // ── Plan Seçenekleri (Yıllık / Aylık) ───────────────────────────
            _buildPlanOptionTile(
              index: 0,
              title: 'Yıllık Plan (Önerilen)',
              priceText: '₺249.99 / Yıl',
              subPriceText: 'Sadece ₺20.83 / ay',
              badgeText: '%40 TASARRUF',
              colorScheme: colorScheme,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildPlanOptionTile(
              index: 1,
              title: 'Aylık Plan',
              priceText: '₺29.99 / Ay',
              subPriceText: 'İstediğin zaman iptal et',
              badgeText: null,
              colorScheme: colorScheme,
            ),

            const SizedBox(height: AppSpacing.xl),

            // ── CTA Butonu ───────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: _selectedPlanIndex == 0
                    ? 'PRO\'yu Ücretsiz Deneyin (7 Gün)'
                    : 'PRO Üyeliği Başlat',
                isLoading: _isLoading,
                onPressed: _handlePurchase,
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
                    final Uri url = Uri.parse('https://samedkalayci.github.io/ev-asistani-privacy/');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Text(
                    'Kullanım Koşulları (EULA)',
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
                    final Uri url = Uri.parse('https://samedkalayci.github.io/ev-asistani-privacy/');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Text(
                    'Gizlilik Politikası',
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
                'Satın Alımları Geri Yükle',
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
    );
  }

  Widget _buildFeatureTile(
    ColorScheme colorScheme, {
    required String emoji,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: AppRadius.borderMd,
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 20)),
          ),
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
    required ColorScheme colorScheme,
  }) {
    final isSelected = _selectedPlanIndex == index;

    return InkWell(
      onTap: () => setState(() => _selectedPlanIndex = index),
      borderRadius: AppRadius.borderLg,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer.withValues(alpha: 0.2)
              : colorScheme.surfaceContainerLow,
          borderRadius: AppRadius.borderLg,
          border: Border.all(
            color: isSelected ? AppColors.primary : colorScheme.outlineVariant.withValues(alpha: 0.4),
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
                  color: isSelected ? AppColors.primary : colorScheme.outlineVariant,
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
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: AppRadius.borderSm,
                          ),
                          child: Text(
                            badgeText,
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
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
