import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xff005F9C);
  static const Color accent = Color(0xff00C9A7);
  static const Color surface = Color(0xff121212);
  static const Color card = Color(0xff1E1E1E);
  static const Color cardLight = Color(0xff2A2A2A);
  static const Color goodForm = Color(0xff00C9A7);
  static const Color badForm = Color(0xffFF6B6B);
  static const Color warning = Color(0xffFFD93D);

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: surface,
        colorScheme: const ColorScheme.dark(
          primary: primary,
          secondary: accent,
          surface: card,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: surface,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardTheme: CardThemeData(
          color: card,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(color: Colors.white70),
          bodyMedium: TextStyle(color: Colors.white60),
        ),
      );
}
