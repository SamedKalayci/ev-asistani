import 'package:flutter/material.dart';

/// Uygulamanın köşe yuvarlaklık (border radius) sabitleri.
/// Mockup'taki borderRadius skalası baz alınmıştır.
/// Hardcoded radius değeri yerine bu sabitler kullanılır.
abstract final class AppRadius {
  AppRadius._();

  // ── Sabit değerler ────────────────────────────────────────────────────────
  /// 4px — Çok küçük öğeler (chip, badge)
  static const double xs = 4;

  /// 8px — Küçük öğeler
  static const double sm = 8;

  /// 12px — TextField, input alanları
  static const double md = 12;

  /// 16px — Kartlar (mockup: DEFAULT = 1rem)
  static const double lg = 16;

  /// 24px — Büyük kartlar, sheet'ler (mockup: lg = 2rem)
  static const double xl = 24;

  /// 32px — Tam yuvarlak görünümlü öğeler (mockup: xl = 3rem)
  static const double xxl = 32;

  /// 100px (pill) — FAB, butonlar (mockup: full = 9999px)
  static const double full = 100;

  // ── BorderRadius hazır nesneler ───────────────────────────────────────────
  /// xs BorderRadius
  static const BorderRadius borderXs = BorderRadius.all(Radius.circular(xs));

  /// sm BorderRadius
  static const BorderRadius borderSm = BorderRadius.all(Radius.circular(sm));

  /// md BorderRadius — TextField
  static const BorderRadius borderMd = BorderRadius.all(Radius.circular(md));

  /// lg BorderRadius — Kart
  static const BorderRadius borderLg = BorderRadius.all(Radius.circular(lg));

  /// xl BorderRadius — Büyük kart, bottom sheet
  static const BorderRadius borderXl = BorderRadius.all(Radius.circular(xl));

  /// xxl BorderRadius
  static const BorderRadius borderXxl = BorderRadius.all(Radius.circular(xxl));

  /// Pill BorderRadius — FAB, primary button
  static const BorderRadius borderFull = BorderRadius.all(Radius.circular(full));

  /// Yalnızca üst köşeler yuvarlak — Bottom sheet için
  static const BorderRadius borderTopXl = BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
  );

  /// Yalnızca üst köşeler yuvarlak — Bottom navigation için
  static const BorderRadius borderTopLg = BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
  );
}
