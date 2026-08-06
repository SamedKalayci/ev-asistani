import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../features/premium/widgets/paywall_bottom_sheet.dart';
import 'primary_button.dart';

/// İçeriği bulanıklaştırıp (blur) üzerinde şık bir 👑 PRO kilit kartı gösteren overlay bileşeni.
class ProBlurOverlay extends StatelessWidget {
  /// Kilitli olup olmadığını belirtir (`!isPremium`).
  final bool isLocked;

  /// Kilitlenecek/bulanıklaştırılacak içerik widget'ı.
  final Widget child;

  /// Kilit kartında görünecek başlık metni (örn: "Dijital Ev Kasası PRO").
  final String title;

  /// Kilit kartında görünecek açıklama metni.
  final String subtitle;

  /// Kilit açma / Paywall butonuna tıklandığında çalışacak callback.
  final VoidCallback? onTap;

  /// Bulanıklık derecesi (varsayılan: 5.0)
  final double sigmaX;
  final double sigmaY;

  const ProBlurOverlay({
    super.key,
    required this.isLocked,
    required this.child,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.sigmaX = 5.0,
    this.sigmaY = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLocked) {
      return child;
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      alignment: Alignment.center,
      children: [
        // 1. Bulanıklaştırılmış alt içerik (tıklamalar engellenir)
        IgnorePointer(
          ignoring: true,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: sigmaX,
              sigmaY: sigmaY,
            ),
            child: child,
          ),
        ),

        // 2. Yarı saydam karartma katmanı
        Positioned.fill(
          child: Container(
            color: colorScheme.surface.withValues(alpha: 0.35),
          ),
        ),

        // 3. Şık 👑 PRO Kilit Bilgilendirme Kartı
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 380),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest.withValues(alpha: 0.95),
              borderRadius: AppRadius.borderXl,
              boxShadow: AppShadows.lg,
              border: Border.all(
                color: const Color(0xFF60A5FA).withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Başlık
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTypography.titleMedium.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                // Açıklama
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // CTA Butonu
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: '👑 PRO\'ya Yükselt',
                    onPressed: onTap ?? () => PaywallBottomSheet.show(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
