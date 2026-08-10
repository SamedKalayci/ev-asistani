import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'locale_provider.dart';

const String _kCurrencyKey = 'selected_currency_code';

// ── Para Birimi Enum ──────────────────────────────────────────────────────────

enum AppCurrency {
  TRY('TRY', '₺', 'Türk Lirası'),
  USD('USD', '\$', 'US Dollar'),
  EUR('EUR', '€', 'Euro'),
  AZN('AZN', '₼', 'Azərbaycan Manatı'),
  BRL('BRL', 'R\$', 'Real Brasileiro'),
  GBP('GBP', '£', 'British Pound');

  const AppCurrency(this.code, this.symbol, this.label);

  /// ISO kodu (ör. 'TRY')
  final String code;

  /// Para birimi sembolü (ör. '₺')
  final String symbol;

  /// Kullanıcıya gösterilecek tam ad
  final String label;

  /// ISO kodundan enum bulur; bulamazsa TRY döner.
  static AppCurrency fromCode(String code) {
    return AppCurrency.values.firstWhere(
      (c) => c.code == code,
      orElse: () => AppCurrency.TRY,
    );
  }

  /// Dil kodundan varsayılan para birimini belirler.
  static AppCurrency defaultForLocale(String languageCode) {
    return switch (languageCode) {
      'tr' => AppCurrency.TRY,
      'en' => AppCurrency.USD,
      'de' || 'es' || 'fr' || 'el' => AppCurrency.EUR,
      'pt' => AppCurrency.BRL,
      'az' => AppCurrency.AZN,
      _ => AppCurrency.USD,
    };
  }
}

// ── Currency Notifier ─────────────────────────────────────────────────────────

class CurrencyNotifier extends StateNotifier<AppCurrency> {
  CurrencyNotifier(this._ref) : super(AppCurrency.TRY) {
    _init();
  }

  final Ref _ref;

  Future<void> _init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_kCurrencyKey);

      if (savedCode != null) {
        // Kullanıcı daha önce manuel seçim yapmış → o seçimi kullan
        state = AppCurrency.fromCode(savedCode);
      } else {
        // İlk açılış → dile göre varsayılan
        final locale = _ref.read(localeProvider);
        state = AppCurrency.defaultForLocale(locale.languageCode);
      }
    } catch (_) {
      state = AppCurrency.TRY;
    }
  }

  /// Kullanıcı manuel seçim yaptığında çağrılır; SharedPrefs'e kaydeder.
  Future<void> setCurrency(AppCurrency currency) async {
    state = currency;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kCurrencyKey, currency.code);
    } catch (_) {}
  }

  /// Dil değiştiğinde — eğer kullanıcı manuel seçim yapmamışsa — varsayılanı günceller.
  Future<void> syncWithLocale(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_kCurrencyKey);
      if (savedCode == null) {
        // Manuel tercih yok → dile göre güncelle
        state = AppCurrency.defaultForLocale(languageCode);
      }
    } catch (_) {}
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

/// Seçili para birimini yöneten provider.
final currencyProvider = StateNotifierProvider<CurrencyNotifier, AppCurrency>(
  (ref) {
    final notifier = CurrencyNotifier(ref);

    // Dil değiştiğinde locale provider'ı dinle
    ref.listen(localeProvider, (_, next) {
      notifier.syncWithLocale(next.languageCode);
    });

    return notifier;
  },
);

/// Sadece sembolü sunan kolaylık provider'ı (ör. '₺', '$', '€').
final currencySymbolProvider = Provider<String>((ref) {
  return ref.watch(currencyProvider).symbol;
});
