import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/ad_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/pro_blur_overlay.dart';
import 'vault_contacts_screen.dart';
import 'vault_documents_screen.dart';
import 'vault_guide_screen.dart';
import 'vault_maintenance_screen.dart';

/// Dijital Ev Kasası Ekranı.
class VaultScreen extends ConsumerWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isPremium = ref.watch(isPremiumProvider);

    final content = SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),

          // ── Üst Başlık & Açıklama ───────────────────────────────────────────
          Row(
            children: [
              Text(
                l10n.vaultTab,
                style: AppTypography.headlineSmall.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.digitalVaultSubtitle,
            style: AppTypography.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // ── 4 Ana Kategori Grid ────────────────────────────────────────────
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.0,
            children: [
              _buildVaultCard(
                context,
                colorScheme,
                title: l10n.documentsAndWarranties,
                icon: Icons.description_outlined,
                iconBgColor: const Color(0xFFDCFCE7),
                iconColor: AppColors.primary,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VaultDocumentsScreen(),
                    ),
                  );
                },
              ),
              _buildVaultCard(
                context,
                colorScheme,
                title: l10n.serviceAndEmergencyNumbers,
                icon: Icons.phone_in_talk_rounded,
                iconBgColor: const Color(0xFFFEE2E2),
                iconColor: const Color(0xFFDC2626),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VaultContactsScreen(),
                    ),
                  );
                },
              ),
              _buildVaultCard(
                context,
                colorScheme,
                title: l10n.periodicMaintenance,
                icon: Icons.build_circle_outlined,
                iconBgColor: const Color(0xFFDBEAFE),
                iconColor: const Color(0xFF2563EB),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VaultMaintenanceScreen(),
                    ),
                  );
                },
              ),
              _buildVaultCard(
                context,
                colorScheme,
                title: l10n.homeGuideWifi,
                icon: Icons.wifi_rounded,
                iconBgColor: const Color(0xFFFEF3C7),
                iconColor: const Color(0xFFD97706),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VaultGuideScreen(),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );

    return ProBlurOverlay(
      isLocked: !isPremium,
      title: l10n.vaultTab,
      subtitle:
          l10n.digitalVaultSubtitle,
      child: content,
    );
  }

  Widget _buildVaultCard(
    BuildContext context,
    ColorScheme colorScheme, {
    required String title,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.borderXl,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: AppRadius.borderXl,
          boxShadow: AppShadows.xs,
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.titleMedium.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
