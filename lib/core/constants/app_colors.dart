import 'package:flutter/material.dart';

/// Central color definitions for CatLab Studios.
/// AI-hint: Add new brand colors here — never inline colors in widgets.
abstract final class AppColors {
  // Background
  static const Color background = Color(0xFF0D0F1E);
  static const Color surface = Color(0xFF161829);
  static const Color surfaceVariant = Color(0xFF1E2138);

  // Primary — navy/violet
  static const Color primary = Color(0xFF5B5FEF);
  static const Color primaryVariant = Color(0xFF3D41C8);

  // Accent — warm gold
  static const Color accent = Color(0xFFFFBB55);
  static const Color accentVariant = Color(0xFFE6A030);

  // Text
  static const Color textPrimary = Color(0xFFF0F0F8);
  static const Color textSecondary = Color(0xFFAAABC4);
  static const Color textMuted = Color(0xFF6B6D88);

  // Utility
  static const Color divider = Color(0xFF2A2C45);
  static const Color cardBorder = Color(0xFF2E3155);
}
