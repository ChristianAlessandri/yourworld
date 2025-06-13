import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // =====================
  // TAILWIND BASE COLORS
  // =====================
  // Indigo
  static const tailwindIndigo400 = Color(0xFF818CF8);
  static const tailwindIndigo500 = Color(0xFF6366F1);
  static const tailwindIndigo600 = Color(0xFF4F46E5);

  // Rose
  static const tailwindRose400 = Color(0xFFFB7185);
  static const tailwindRose500 = Color(0xFFF43F5E);
  static const tailwindRose600 = Color(0xFFE11D48);

  // Slate (neutri, background, testo)
  static const tailwindSlate50 = Color(0xFFF8FAFC);
  static const tailwindSlate100 = Color(0xFFF1F5F9);
  static const tailwindSlate200 = Color(0xFFE2E8F0);
  static const tailwindSlate400 = Color(0xFF94A3B8);
  static const tailwindSlate600 = Color(0xFF475569);
  static const tailwindSlate700 = Color(0xFF334155);
  static const tailwindSlate800 = Color(0xFF1E293B);
  static const tailwindSlate900 = Color(0xFF0F172A);

  // Green
  static const tailwindGreen500 = Color(0xFF22C55E);

  // Red
  static const tailwindRed500 = Color(0xFFEF4444);

  // Amber
  static const tailwindAmber500 = Color(0xFFF59E0B);

  // Sky
  static const tailwindSky500 = Color(0xFF0EA5E9);

  // =====================
  // LIGHT THEME
  // =====================
  static const lightPrimary = tailwindIndigo500;
  static const lightPrimaryVariant = tailwindIndigo600;
  static const lightSecondary = tailwindRose500;
  static const lightSecondaryVariant = tailwindRose600;

  static const lightBackground = tailwindSlate50;
  static const lightSurface = Colors.white;
  static const lightCard = tailwindSlate100;

  static const lightTextPrimary = tailwindSlate800;
  static const lightTextSecondary = tailwindSlate600;
  static const lightTextOnPrimary = Colors.white;

  static const lightDivider = tailwindSlate200;

  // =====================
  // DARK THEME
  // =====================
  static const darkPrimary = tailwindIndigo400;
  static const darkPrimaryVariant = tailwindIndigo500;
  static const darkSecondary = tailwindRose400;
  static const darkSecondaryVariant = tailwindRose500;

  static const darkBackground = tailwindSlate900;
  static const darkSurface = tailwindSlate800;
  static const darkCard = tailwindSlate700;

  static const darkTextPrimary = tailwindSlate100;
  static const darkTextSecondary = tailwindSlate400;
  static const darkTextOnPrimary = Colors.white;

  static const darkDivider = tailwindSlate600;

  // =====================
  // STATUS (shared)
  // =====================
  static const success = tailwindGreen500;
  static const error = tailwindRed500;
  static const warning = tailwindAmber500;
  static const info = tailwindSky500;
}
