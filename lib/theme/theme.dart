import 'package:flutter/material.dart';

// light mode
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: const Color.fromARGB(255, 248, 243, 235),
    primary: const Color.fromARGB(255, 242, 224, 195),
    secondary: Colors.grey.shade400,
    inversePrimary: Colors.grey.shade800,
  ),
);

// dark mode
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: const Color.fromARGB(255, 28, 28, 28),
    primary: const Color.fromARGB(255, 44, 43, 43),
    secondary: const Color.fromARGB(255, 165, 165, 165),
    inversePrimary: const Color.fromARGB(255, 210, 209, 209),
  ),
);