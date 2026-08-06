/// Uygulamanın boşluk (spacing) sabitleri.
/// Mockup'taki spacing skalası baz alınmıştır.
/// Hardcoded sayısal değer yerine bu sabitler kullanılır.
abstract final class AppSpacing {
  AppSpacing._();

  // ── Temel birim: 4px grid ─────────────────────────────────────────────────
  /// 4px — En küçük boşluk (mockup: xs)
  static const double xs = 4;

  /// 8px — Küçük boşluk (mockup: base)
  static const double sm = 8;

  /// 12px — Orta-küçük (mockup: sm)
  static const double md = 12;

  /// 16px — Standart boşluk (mockup: md / gutter)
  static const double lg = 16;

  /// 20px — Sayfa kenar boşluğu (mockup: container-margin)
  static const double pageHorizontal = 20;

  /// 24px — Büyük boşluk (mockup: lg)
  static const double xl = 24;

  /// 32px — Çok büyük boşluk (mockup: xl)
  static const double xxl = 32;

  // ── Özel kullanım alanları ────────────────────────────────────────────────
  /// İçerik alanı yatay padding
  static const double contentPaddingH = lg;

  /// İçerik alanı dikey padding
  static const double contentPaddingV = md;

  /// Kart iç boşluğu
  static const double cardPadding = lg;

  /// Liste öğeleri arası boşluk
  static const double listItemGap = sm;

  /// Bölümler arası boşluk
  static const double sectionGap = xxl;

  /// Icon ile metin arası boşluk
  static const double iconTextGap = sm;

  /// Buton yatay padding
  static const double buttonPaddingH = xl;

  /// Buton dikey padding
  static const double buttonPaddingV = lg;

  /// TextField yatay padding
  static const double inputPaddingH = lg;

  /// TextField dikey padding
  static const double inputPaddingV = 14;
}
