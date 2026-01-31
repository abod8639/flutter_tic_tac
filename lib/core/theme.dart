import 'package:flutter/material.dart';

// class MyTheme {
//   static Color orange = Color(0xfff58714);
//   static Color red = Color(0xfff54d63);
//   static Color green = Color(0xff88e339);
// }

class MyTheme {
  // 1. تعريف الألوان الأساسية (التي استخدمناها في X و O)
  static const Color red = Color(0xFFFF4B4B);
  static const Color orange = Color(0xFFFF9100);
  static const Color teal = Color(0xFF00E5FF);
  static const Color background = Color(0xFF1A1A2E); // أزرق ليلي عميق
  static const Color cardColor = Color(0xFF16213E);  // لون المربعات
  static const Color accentColor = Color(0xFFE94560);

  // 2. بناء الـ ThemeData
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: red,
    scaffoldBackgroundColor: background,
    
    // تنسيق البطاقات (مربعات اللعبة)
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),

    // تنسيق النصوص
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 1.2,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: Colors.white70,
      ),
    ),

    // تنسيق الأزرار
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 10,
        shadowColor: red.withOpacity(0.5),
      ),
    ),

    // تنسيق الـ AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}