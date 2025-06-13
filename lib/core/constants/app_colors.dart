import 'package:flutter/material.dart';
import 'package:yourworld/core/constants/tailwind_colors.dart';

class AppColors {
  AppColors._();

  // =====================
  // LIGHT THEME
  // =====================
  static const lightPrimary = TailwindColors.indigo500;
  static const lightPrimaryVariant = TailwindColors.indigo600;
  static const lightSecondary = TailwindColors.rose500;
  static const lightSecondaryVariant = TailwindColors.rose600;

  static const lightBackground = TailwindColors.neutral50;
  static const lightSurface = Colors.white;
  static const lightCard = TailwindColors.neutral100;

  static const lightTextPrimary = TailwindColors.neutral800;
  static const lightTextSecondary = TailwindColors.neutral600;
  static const lightTextOnPrimary = Colors.white;

  static const lightDivider = TailwindColors.neutral200;

  // =====================
  // DARK THEME
  // =====================
  static const darkPrimary = TailwindColors.indigo400;
  static const darkPrimaryVariant = TailwindColors.indigo500;
  static const darkSecondary = TailwindColors.rose400;
  static const darkSecondaryVariant = TailwindColors.rose500;

  static const darkBackground = TailwindColors.neutral900;
  static const darkSurface = TailwindColors.neutral800;
  static const darkCard = TailwindColors.neutral700;

  static const darkTextPrimary = TailwindColors.neutral100;
  static const darkTextSecondary = TailwindColors.neutral400;
  static const darkTextOnPrimary = Colors.white;

  static const darkDivider = TailwindColors.slate600;

  // =====================
  // STATUS (shared)
  // =====================
  static const success = TailwindColors.green500;
  static const error = TailwindColors.red500;
  static const warning = TailwindColors.amber500;
  static const info = TailwindColors.sky500;
}
