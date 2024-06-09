import 'package:flutter/material.dart';
import 'package:itodo/const/constants.dart';

Widget getColorChip(String? colorName) {
  return Container(
    height: 10,
    width: 10,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: getColorByName(colorName)),
  );
}

Color getColorByIndex(int index) {
  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.teal,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.amber,
    Colors.cyan,
  ];
  return colors[index % colors.length];
}
