import 'package:flutter/material.dart';


abstract final class AppTheme {
  static ThemeData get dark {
    const backgroundColor = Color(0xFF000000);
    const primaryTextColor = Color(0xFFF2F2F2);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.dark(
        surface: backgroundColor,
        primary: primaryTextColor,
        onPrimary: backgroundColor,
        onSurface: primaryTextColor,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: primaryTextColor,
          fontFamily: 'CookieFont',
          fontSize: 25,
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}