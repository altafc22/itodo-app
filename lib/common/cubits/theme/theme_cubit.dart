import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'theme_state.dart';

const themePrefsKey = 'themePrefs';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.system)) {
    _loadTheme();
  }

  ThemeMode currentTheme = ThemeMode.system;

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeCode = prefs.getString(themePrefsKey);
    ThemeMode themeMode;
    if (themeCode != null && themeCode == 'dark') {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }
    emit(state.copyWith(themeMode: themeMode));
    currentTheme = themeMode;
  }

  void toggleTheme() async {
    ThemeMode newThemeMode =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _onThemeChange(newThemeMode);
  }

  void _onThemeChange(ThemeMode themeMode) async {
    if (currentTheme != themeMode) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          themePrefsKey, themeMode == ThemeMode.dark ? 'dark' : 'light');
      emit(state.copyWith(themeMode: themeMode));
      currentTheme = themeMode;
    }
  }
}
