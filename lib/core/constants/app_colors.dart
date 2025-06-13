import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // =====================
  // TAILWIND BASE
  // =====================
  static const Color tailwindIndigo500 = Color(0xFF6366F1);
  static const Color tailwindRose500 = Color(0xFFF43F5E);

  // =====================
  // LIGHT THEME COLORS
  // =====================
  static const Color lightPrimary = tailwindIndigo500;
  static const Color lightPrimaryVariant = Color(0xFF4F46E5); // indigo-600
  static const Color lightSecondary = tailwindRose500;
  static const Color lightSecondaryVariant = Color(0xFFE11D48); // rose-600

  static const Color lightBackground = Color(0xFFF9FAFB); // slate-50
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF1F5F9); // slate-100

  static const Color lightTextPrimary = Color(0xFF1E293B); // slate-800
  static const Color lightTextSecondary = Color(0xFF475569); // slate-600
  static const Color lightTextOnPrimary = Color(0xFFFFFFFF);

  static const Color lightDivider = Color(0xFFE2E8F0); // slate-200

  // =====================
  // DARK THEME COLORS
  // =====================
  static const Color darkPrimary = Color(0xFF818CF8); // indigo-400
  static const Color darkPrimaryVariant = tailwindIndigo500;
  static const Color darkSecondary = Color(0xFFFB7185); // rose-400
  static const Color darkSecondaryVariant = tailwindRose500;

  static const Color darkBackground = Color(0xFF0F172A); // slate-900
  static const Color darkSurface = Color(0xFF1E293B); // slate-800
  static const Color darkCard = Color(0xFF334155); // slate-700

  static const Color darkTextPrimary = Color(0xFFF1F5F9); // slate-100
  static const Color darkTextSecondary = Color(0xFF94A3B8); // slate-400
  static const Color darkTextOnPrimary = Color(0xFFFFFFFF);

  static const Color darkDivider = Color(0xFF475569); // slate-600

  // =====================
  // STATUS COLORS (Shared)
  // =====================
  static const Color success = Color(0xFF22C55E); // green-500
  static const Color error = Color(0xFFEF4444); // red-500
  static const Color warning = Color(0xFFF59E0B); // amber-500
  static const Color info = Color(0xFF0EA5E9); // sky-500
}
