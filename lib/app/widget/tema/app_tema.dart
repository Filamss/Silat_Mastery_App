import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Poppins'),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: const Color(0xFFCF0014),
      secondary: const Color(0xFF710913),
    ),
  );
}
