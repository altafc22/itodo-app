import 'package:flutter/material.dart';

enum Language {
  english(
    Locale('en', 'US'),
    'English',
  ),

  german(
    Locale('de', 'DE'),
    'Deutsch',
  );

  const Language(this.value, this.text);

  final Locale value;
  final String text;
}
