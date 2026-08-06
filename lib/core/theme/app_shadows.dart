import 'package:flutter/material.dart';

/// Uygulamanın gölge (shadow/elevation) sabitleri.
/// Mockup'taki glass-card ve surface gölge stillerini baz alır.
/// Hardcoded BoxShadow değeri yerine bu sabitler kullanılır.
abstract final class AppShadows {
  AppShadows._();

  // ── Kart Gölgeleri ────────────────────────────────────────────────────────
  /// Yok — Düz yüzey, elevation: 0
  static const List<BoxShadow> none = [];

  /// Çok hafif — Liste öğeleri, küçük kartlar
  static const List<BoxShadow> xs = [
    BoxShadow(
      color: Color(0x0A000000), // %4 siyah
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  /// Hafif — Standart kart (mockup: glass-card benzeri)
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0A000000), // %4 siyah
      blurRadius: 20,
      offset: Offset(0, 4),
    ),
  ];

  /// Orta — Yüksek kartlar, FAB
  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x14000000), // %8 siyah
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  /// Güçlü — Modal, bottom sheet
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x1F000000), // %12 siyah
      blurRadius: 32,
      offset: Offset(0, 12),
    ),
  ];

  // ── Navigation Bar Gölgesi ────────────────────────────────────────────────
  /// Bottom navigation bar üst gölgesi (mockup: shadow-[0_-4px_20px_0_rgba(0,0,0,0.04)])
  static const List<BoxShadow> navigationBar = [
    BoxShadow(
      color: Color(0x0A000000), // %4 siyah
      blurRadius: 20,
      offset: Offset(0, -4),
    ),
  ];

  // ── FAB Gölgesi ───────────────────────────────────────────────────────────
  /// Floating Action Button için (mockup: shadow-lg)
  static const List<BoxShadow> fab = [
    BoxShadow(
      color: Color(0x29000000), // %16 siyah
      blurRadius: 24,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
  ];
}
