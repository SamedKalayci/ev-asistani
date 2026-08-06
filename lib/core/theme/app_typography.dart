import 'package:flutter/material.dart';

/// Uygulamanın tipografi sabitleri.
/// Mockup'taki Inter font ailesi ve MD3 type scale baz alınmıştır.
/// AppTheme bu sınıfı kullanır — hardcoded TextStyle kullanılmaz.
abstract final class AppTypography {
  AppTypography._();

  static const String _fontFamily = 'Inter';

  // ── Display ───────────────────────────────────────────────────────────────
  /// 57px / Regular — Büyük karşılama metinleri
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    height: 1.12,
  );

  /// 45px / Regular
  static const TextStyle displayMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 45,
    fontWeight: FontWeight.w400,
    height: 1.15,
  );

  /// 36px / Regular
  static const TextStyle displaySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1.22,
  );

  // ── Headline ──────────────────────────────────────────────────────────────
  /// 32px / SemiBold — Sayfa başlıkları (mockup: headline-lg)
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.32,
    height: 1.25,
  );

  /// 28px / SemiBold
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.28,
  );

  /// 24px / SemiBold — Mobil sayfa başlıkları (mockup: headline-lg-mobile)
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
  );

  // ── Title ─────────────────────────────────────────────────────────────────
  /// 22px / SemiBold — AppBar başlıkları
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.27,
  );

  /// 20px / SemiBold — Kart başlıkları (mockup: title-md)
  static const TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.40,
  );

  /// 14px / Medium
  static const TextStyle titleSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.42,
  );

  // ── Body ──────────────────────────────────────────────────────────────────
  /// 16px / Regular — Ana içerik metni (mockup: body-lg)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
  );

  /// 14px / Regular — İkincil içerik metni (mockup: body-md)
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.42,
  );

  /// 12px / Regular
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
  );

  // ── Label ─────────────────────────────────────────────────────────────────
  /// 14px / Medium — Buton etiketleri
  static const TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.42,
  );

  /// 12px / Medium — Navigasyon etiketleri (mockup: label-md)
  static const TextStyle labelMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.60,
    height: 1.33,
  );

  /// 11px / Medium — Küçük etiketler
  static const TextStyle labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.45,
  );

  // ── Yardımcı — Renk uygulanmış varyantlar ────────────────────────────────
  /// Renk parametresi ile TextStyle oluşturur.
  /// AppTheme TextTheme'inde kullanılır.
  static TextStyle withColor(TextStyle style, Color color) =>
      style.copyWith(color: color);
}
