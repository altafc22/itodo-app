import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itodo/common/models/language_model.dart';
import 'package:itodo/common/utils/log_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';
part 'locale_state.dart';

const languagePrefsKey = 'languagePrefs';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(LocaleState()) {
    _defaultLocale();
  }

  Locale currentLocale = Language.english.value;
  _defaultLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(
      languagePrefsKey,
    );
    Locale locale;
    if (localeCode != null) {
      locale = Locale(localeCode);
    } else {
      locale = Language.english.value;
    }
    currentLocale = locale;
    emit(state.copyWith(locale: locale));
  }

  void getCurrentLocale() async {
    emit(state.copyWith(locale: currentLocale));
  }

  void changeLanguage(Locale locale) async {
    print("Locale: $locale");
    _onLocaleChange(locale);
  }

  void toArabic() async {
    var locale = const Locale('ar');
    _onLocaleChange(locale);
  }

  void toGerman() async {
    var locale = const Locale('de');
    _onLocaleChange(locale);
  }

  void toEnglish() async {
    var locale = Language.english.value;
    _onLocaleChange(locale);
  }

  void _onLocaleChange(Locale locale) async {
    if (currentLocale != locale) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(languagePrefsKey, locale.languageCode);
      emit(LocaleState(locale: locale));
      currentLocale = locale;
      logInfo(currentLocale.languageCode);
    }
  }
}
