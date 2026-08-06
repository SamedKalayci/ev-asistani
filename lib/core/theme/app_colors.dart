import 'package:flutter/material.dart';

/// Uygulamanın tüm renk sabitleri.
/// Mockup'tan alınan MD3 uyumlu renk paleti.
/// AppTheme bu sınıfı kullanır — hardcoded renk kullanılmaz.
abstract final class AppColors {
  AppColors._();

  // ── Light — Primary ───────────────────────────────────────────────────────
  static const Color primary = Color(0xFF006E28);
  static const Color success = Color(0xFF006E28);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF34C759);
  static const Color onPrimaryContainer = Color(0xFF004D1A);
  static const Color inversePrimary = Color(0xFF53E16F);

  // ── Light — Secondary ─────────────────────────────────────────────────────
  static const Color secondary = Color(0xFF5F5E60);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE2DFE1);
  static const Color onSecondaryContainer = Color(0xFF636264);

  // ── Light — Tertiary ──────────────────────────────────────────────────────
  static const Color tertiary = Color(0xFF005BC1);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF85AEFF);
  static const Color onTertiaryContainer = Color(0xFF003F8A);

  // ── Light — Error ─────────────────────────────────────────────────────────
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // ── Light — Surface ───────────────────────────────────────────────────────
  static const Color surface = Color(0xFFF9F9FE);
  static const Color onSurface = Color(0xFF1A1C1F);
  static const Color onSurfaceVariant = Color(0xFF3D4A3C);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF3F3F8);
  static const Color surfaceContainer = Color(0xFFEDEDF2);
  static const Color surfaceContainerHigh = Color(0xFFE8E8ED);
  static const Color surfaceContainerHighest = Color(0xFFE2E2E7);
  static const Color inverseSurface = Color(0xFF2E3034);
  static const Color inverseOnSurface = Color(0xFFF0F0F5);

  // ── Light — Outline ───────────────────────────────────────────────────────
  static const Color outline = Color(0xFF6D7B6B);
  static const Color outlineVariant = Color(0xFFBCCBB8);

  // ── Dark — Primary ────────────────────────────────────────────────────────
  static const Color darkPrimary = Color(0xFF53E16F);
  static const Color darkOnPrimary = Color(0xFF003913);
  static const Color darkPrimaryContainer = Color(0xFF00531C);
  static const Color darkOnPrimaryContainer = Color(0xFF72FE88);
  static const Color darkInversePrimary = Color(0xFF006E28);

  // ── Dark — Secondary ──────────────────────────────────────────────────────
  static const Color darkSecondary = Color(0xFFC8C6C8);
  static const Color darkOnSecondary = Color(0xFF313033);
  static const Color darkSecondaryContainer = Color(0xFF474649);
  static const Color darkOnSecondaryContainer = Color(0xFFE4E2E4);

  // ── Dark — Tertiary ───────────────────────────────────────────────────────
  static const Color darkTertiary = Color(0xFFADC6FF);
  static const Color darkOnTertiary = Color(0xFF002E6A);
  static const Color darkTertiaryContainer = Color(0xFF004493);
  static const Color darkOnTertiaryContainer = Color(0xFFD8E2FF);

  // ── Dark — Error ──────────────────────────────────────────────────────────
  static const Color darkError = Color(0xFFFFB4AB);
  static const Color darkOnError = Color(0xFF690005);
  static const Color darkErrorContainer = Color(0xFF93000A);
  static const Color darkOnErrorContainer = Color(0xFFFFDAD6);

  // ── Dark — Surface ────────────────────────────────────────────────────────
  static const Color darkSurface = Color(0xFF111318);
  static const Color darkOnSurface = Color(0xFFE2E2E9);
  static const Color darkOnSurfaceVariant = Color(0xFFC1CEBE);
  static const Color darkSurfaceContainerLowest = Color(0xFF0C0E13);
  static const Color darkSurfaceContainerLow = Color(0xFF1A1C1F);
  static const Color darkSurfaceContainer = Color(0xFF1E2022);
  static const Color darkSurfaceContainerHigh = Color(0xFF282A2D);
  static const Color darkSurfaceContainerHighest = Color(0xFF333537);
  static const Color darkInverseSurface = Color(0xFFE2E2E9);
  static const Color darkInverseOnSurface = Color(0xFF2E3034);

  // ── Dark — Outline ────────────────────────────────────────────────────────
  static const Color darkOutline = Color(0xFF8B9989);
  static const Color darkOutlineVariant = Color(0xFF424940);
}
