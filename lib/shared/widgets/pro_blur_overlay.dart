import 'package:flutter/material.dart';

/// İçeriği bulanıklaştırıp (blur) üzerinde şık bir 👑 PRO kilit kartı gösteren overlay bileşeni.
/// Tüm özellikler artık ücretsiz olduğu için bu overlay doğrudan alt bileşenini (child) döner.
class ProBlurOverlay extends StatelessWidget {
  final bool isLocked;
  final Widget child;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
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
    // Tüm özellik kilitleri kaldırıldığı için her zaman içeriği dönüyoruz.
    return child;
  }
}
