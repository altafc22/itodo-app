import 'package:flutter/material.dart';

const primaryColor = Color(0xFF458AE5);
const secondaryColor = Color(0xFFFFFFFF);
const accentColor = Color(0xFFFFA500);

const lightBackgroundColor = Color(0xFFFFFFFF);
const darkBackgroundColor = Color(0xFF1E1E1E);

const cardBackgroundColor = Color(0xFFFFFFFF);

const whiteColor = Color(0xFFFFFFFF);
const blackColor = Color(0xFF000000);

const lightCardColor = Color(0xFFFFFFFF);
const darkCardColor = Color.fromARGB(255, 46, 46, 46);
const darkGray = Color.fromARGB(255, 23, 23, 23);

const titleTextColor = Color(0xFF0D062D);
const textColor = Color(0xFF787486);

const darkTitleTextColor = Colors.white;
const darkTextColor = Colors.white60;

const grayColor500 = Color(0xFFE0E0E0);
const grayColor200 = Color(0xFFF5F5F5);

const purpleColor = Color(0xFF5030E5);
const orangeColor = Color(0xFFFFA500);
const greenColor = Color(0xFF8BC48A);
const fusciaColor = Color(0xFFE4CCFD);

// project colors
const Map<String, Color> colorMap = {
  'berry_red': Color(0xFFb8256f),
  'red': Color(0xFFdb4035),
  'orange': Color(0xFFff9933),
  'yellow': Color(0xFFfad000),
  'olive_green': Color(0xFFafb83b),
  'lime_green': Color(0xFF7ecc49),
  'green': Color(0xFF299438),
  'mint_green': Color(0xFF6accbc),
  'teal': Color(0xFF158fad),
  'sky_blue': Color(0xFF14aaf5),
  'light_blue': Color(0xFF96c3eb),
  'blue': Color(0xFF4073ff),
  'grape': Color(0xFF884dff),
  'violet': Color(0xFFaf38eb),
  'lavender': Color(0xFFeb96eb),
  'magenta': Color(0xFFe05194),
  'salmon': Color(0xFFff8d85),
  'charcoal': Color(0xFF808080),
  'grey': Color(0xFFb8b8b8),
  'taupe': Color(0xFFccac93),
};

Color getColorByName(String? name) {
  return colorMap[name] ?? Colors.black;
}
