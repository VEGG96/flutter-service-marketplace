import 'package:flutter/material.dart';

class AppTheme {
  
  static const Color primaryColor = Color(0xFF0D253F); 
  static const Color accentColor = Color(0xFFFF7A00); 
  static const Color errorColor = Color(0xFFD32F2F);

  // 🌞 light
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Colors.white;
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF757575);

  // 🌙 dark 
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFAAAAAA);

 
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        error: errorColor,
        surface: lightSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: _elevatedButtonTheme,
      inputDecorationTheme: _lightInputDecorationTheme,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: accentColor,
        unselectedItemColor: lightTextSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        error: errorColor,
        surface: darkSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface, // En modo oscuro el appbar suele ser del color de la superficie
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: _elevatedButtonTheme,
      inputDecorationTheme: _darkInputDecorationTheme,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: accentColor,
        unselectedItemColor: darkTextSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  // ==========================================
  // 🔧 shared
  // ==========================================
  static final ElevatedButtonThemeData _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: accentColor, // Los botones principales van en naranja
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Bordes redondeados como en tu diseño
    ),
  );

  static final InputDecorationTheme _lightInputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: lightSurface,
    prefixIconColor: lightTextSecondary,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primaryColor, width: 2)),
  );

  static final InputDecorationTheme _darkInputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: darkSurface,
    prefixIconColor: darkTextSecondary,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: accentColor, width: 2)),
  );
}