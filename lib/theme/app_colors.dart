import 'package:flutter/material.dart';

/// All colours used in the app live in one place so the theme stays consistent.
class AppColors {
  // Private constructor: this class is only a holder for constants.
  AppColors._();

  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryLight = Color(0xFFFFE8DE);
  static const Color background = Color(0xFFFFFBF7);
  static const Color dark = Color(0xFF1F1F1F);
  static const Color grey = Color(0xFF8A8A8A);
  static const Color card = Colors.white;
  static const Color green = Color(0xFF2E9E5B);
  static const Color star = Color(0xFFFFB800);
  static const Color shadow = Color(0x14000000); // black at ~8% opacity
}
