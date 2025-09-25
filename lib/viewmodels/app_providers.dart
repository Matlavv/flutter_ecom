import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Export all providers from features
export '../../viewmodels/auth_providers.dart';
export '../../viewmodels/cart_providers.dart';
export '../../viewmodels/order_providers.dart';
export '../../viewmodels/product_providers.dart';

const _kThemeModeKey = 'theme_mode';

ThemeMode _parseThemeMode(String? value) {
  switch (value) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    case 'system':
    default:
      return ThemeMode.system;
  }
}

String _stringifyThemeMode(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.light:
      return 'light';
    case ThemeMode.dark:
      return 'dark';
    case ThemeMode.system:
      return 'system';
  }
}

final sharedPrefsProvider = FutureProvider<SharedPreferences>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs;
});

final themeModeProvider =
    StateNotifierProvider<ThemeModeController, ThemeMode>((ref) {
  return ThemeModeController(ref);
});

class ThemeModeController extends StateNotifier<ThemeMode> {
  final Ref _ref;
  ThemeModeController(this._ref) : super(ThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await _ref.read(sharedPrefsProvider.future);
    state = _parseThemeMode(prefs.getString(_kThemeModeKey));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await _ref.read(sharedPrefsProvider.future);
    await prefs.setString(_kThemeModeKey, _stringifyThemeMode(mode));
  }
}
