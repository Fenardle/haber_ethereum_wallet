import 'dart:math';
import 'package:flutter/material.dart';

class RandomColorGenerator {
  static final List<Color> colors = [
    Color.fromRGBO(28, 174, 170, 1.0),
    Color.fromRGBO(75, 124, 146, 1.0),
    Color.fromRGBO(214, 150, 45, 1.0),
    Color.fromRGBO(236, 230, 199, 1.0),
    Color.fromRGBO(119, 174, 45, 1.0),
    Color.fromRGBO(94, 207, 210, 1.0),
    Color.fromRGBO(56, 189, 105, 1.0),
    Color.fromRGBO(221, 199, 109, 1.0),
    Color.fromRGBO(234, 171, 21, 1.0),
    Color.fromRGBO(212, 92, 92, 1.0),
  ];

  static final Random random = Random();

  static Color generateRandomColor() {
    return colors[random.nextInt(colors.length)];
  }
}
