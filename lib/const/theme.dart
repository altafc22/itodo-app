import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:itodo/const/constants.dart';

class AppTheme {
  static var lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackgroundColor,
    fontFamily: 'Inter',
    textTheme: _lightTextTheme,
    cardColor: lightCardColor,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
    ),
    dropdownMenuTheme: _lightDropDownTheme,
    inputDecorationTheme: _lightInputDecoration,
    elevatedButtonTheme: _lightButtonTheme,
    canvasColor: lightBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: titleTextColor,
      titleTextStyle: TextStyle(fontFamily: 'Inter', color: titleTextColor),
    ),
  );

  static var darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackgroundColor,
    fontFamily: 'Inter',
    textTheme: _darkTextTheme,
    cardColor: darkCardColor,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: darkBackgroundColor,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
    ),
    inputDecorationTheme: _darkInputDecoration,
    elevatedButtonTheme: _darkButtonTheme,
    dropdownMenuTheme: _darkDropDownTheme,
    canvasColor: darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackgroundColor,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(fontFamily: 'Inter', color: Colors.white),
    ),
  );

  static const _textTheme = TextTheme(
    displayLarge: TextStyle(fontFamily: 'Inter'),
    displayMedium: TextStyle(fontFamily: 'Inter'),
    displaySmall: TextStyle(fontFamily: 'Inter'),
    headlineLarge: TextStyle(fontFamily: 'Inter'),
    headlineMedium: TextStyle(fontFamily: 'Inter'),
    headlineSmall: TextStyle(fontFamily: 'Inter'),
    titleLarge: TextStyle(fontFamily: 'Inter'),
    titleMedium: TextStyle(fontFamily: 'Inter'),
    titleSmall: TextStyle(fontFamily: 'Inter'),
    bodyLarge: TextStyle(fontFamily: 'Inter'),
    bodyMedium: TextStyle(fontFamily: 'Inter'),
    bodySmall: TextStyle(fontFamily: 'Inter'),
    labelLarge: TextStyle(fontFamily: 'Inter'),
    labelMedium: TextStyle(fontFamily: 'Inter'),
    labelSmall: TextStyle(fontFamily: 'Inter'),
  );

  static final _darkTextTheme = TextTheme(
    displayLarge: _textTheme.displayLarge?.copyWith(color: darkTitleTextColor),
    displayMedium:
        _textTheme.displayMedium?.copyWith(color: darkTitleTextColor),
    displaySmall: _textTheme.displaySmall?.copyWith(color: darkTitleTextColor),
    headlineLarge:
        _textTheme.headlineLarge?.copyWith(color: darkTitleTextColor),
    headlineMedium:
        _textTheme.headlineMedium?.copyWith(color: darkTitleTextColor),
    headlineSmall:
        _textTheme.headlineSmall?.copyWith(color: darkTitleTextColor),
    titleLarge: _textTheme.titleLarge?.copyWith(color: darkTitleTextColor),
    titleMedium: _textTheme.titleMedium?.copyWith(color: darkTitleTextColor),
    titleSmall: _textTheme.titleSmall?.copyWith(color: darkTitleTextColor),
    bodyLarge: _textTheme.bodyLarge?.copyWith(color: darkTextColor),
    bodyMedium: _textTheme.bodyMedium?.copyWith(color: darkTextColor),
    bodySmall: _textTheme.bodySmall?.copyWith(color: darkTextColor),
    labelLarge: _textTheme.labelLarge?.copyWith(color: darkTextColor),
    labelMedium: _textTheme.labelMedium?.copyWith(color: darkTextColor),
    labelSmall: _textTheme.labelSmall?.copyWith(color: darkTextColor),
  );

  static final _lightTextTheme = TextTheme(
    displayLarge: _textTheme.displayLarge?.copyWith(color: titleTextColor),
    displayMedium: _textTheme.displayMedium?.copyWith(color: titleTextColor),
    displaySmall: _textTheme.displaySmall?.copyWith(color: titleTextColor),
    headlineLarge: _textTheme.headlineLarge?.copyWith(color: titleTextColor),
    headlineMedium: _textTheme.headlineMedium?.copyWith(color: titleTextColor),
    headlineSmall: _textTheme.headlineSmall?.copyWith(color: titleTextColor),
    titleLarge: _textTheme.titleLarge?.copyWith(color: titleTextColor),
    titleMedium: _textTheme.titleMedium?.copyWith(color: titleTextColor),
    titleSmall: _textTheme.titleSmall?.copyWith(color: titleTextColor),
    bodyLarge: _textTheme.bodyLarge?.copyWith(color: textColor),
    bodyMedium: _textTheme.bodyMedium?.copyWith(color: textColor),
    bodySmall: _textTheme.bodySmall?.copyWith(color: textColor),
    labelLarge: _textTheme.labelLarge?.copyWith(color: textColor),
    labelMedium: _textTheme.labelMedium?.copyWith(color: textColor),
    labelSmall: _textTheme.labelSmall?.copyWith(color: textColor),
  );

  static final _lightInputDecoration = InputDecorationTheme(
    fillColor: grayColor200,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: grayColor200, width: 2),
      borderRadius: BorderRadius.circular(6),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black26, width: 2),
      borderRadius: BorderRadius.circular(6),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      borderRadius: BorderRadius.circular(6),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      borderRadius: BorderRadius.circular(6),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: primaryColor, width: 1.5),
      borderRadius: BorderRadius.circular(6),
    ),
  );

  static final _darkInputDecoration = InputDecorationTheme(
    fillColor: darkCardColor,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: grayColor200, width: 2),
      borderRadius: BorderRadius.circular(6),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white12, width: 2),
      borderRadius: BorderRadius.circular(6),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      borderRadius: BorderRadius.circular(6),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      borderRadius: BorderRadius.circular(6),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: primaryColor, width: 1.5),
      borderRadius: BorderRadius.circular(6),
    ),
  );

  static final _darkDropDownTheme = DropdownMenuThemeData(
    menuStyle: MenuStyle(
      backgroundColor: WidgetStateProperty.all(Colors.black),
      elevation: WidgetStateProperty.all(0),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 30, vertical: 8)),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      )),
    ),
  );

  static final _lightDropDownTheme = DropdownMenuThemeData(
    menuStyle: MenuStyle(
      backgroundColor: WidgetStateProperty.all(Colors.white),
      elevation: WidgetStateProperty.all(0),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      padding: WidgetStateProperty.all(const EdgeInsets.all(0.0)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );

  static final _darkButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      backgroundColor: WidgetStateProperty.all(primaryColor),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      elevation: WidgetStateProperty.all(2),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      )),
      fixedSize: WidgetStateProperty.all(const Size(200, 48)), // Set fixed size
    ),
  );

  static final _lightButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      backgroundColor: WidgetStateProperty.all(primaryColor),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      elevation: WidgetStateProperty.all(2),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      )),
      fixedSize: WidgetStateProperty.all(const Size(200, 48)), // Set fixed size
    ),
  );
}
