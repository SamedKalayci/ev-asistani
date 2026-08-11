import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kThemeModeKey = 'selected_theme_mode';

/// Uygulama genelinde tema modunu (System, Light, Dark) yöneten provider.
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _initThemeMode();
  }

  Future<void> _initThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(_kThemeModeKey);

      if (savedMode == 'light') {
        state = ThemeMode.light;
      } else if (savedMode == 'dark') {
        state = ThemeMode.dark;
      } else {
        state = ThemeMode.system;
      }
    } catch (_) {
      state = ThemeMode.system;
    }
  }

  /// Tema modunu günceller ve SharedPreferences ile kaydeder.
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      String modeStr = 'system';
      if (mode == ThemeMode.light) {
        modeStr = 'light';
      } else if (mode == ThemeMode.dark) {
        modeStr = 'dark';
      }
      await prefs.setString(_kThemeModeKey, modeStr);
    } catch (_) {}
  }
}
