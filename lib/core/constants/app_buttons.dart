import 'package:flutter/material.dart';
import 'package:yourworld/core/constants/app_colors.dart';

class AppButtons {
  final BuildContext context;

  AppButtons(this.context);

  ThemeData get theme => Theme.of(context);
  bool get isDark => theme.brightness == Brightness.dark;

  ButtonStyle primary({
    double borderRadius = 16.0,
    EdgeInsets padding =
        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
      foregroundColor: AppColors.lightTextOnPrimary,
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  ButtonStyle secondary({
    double borderRadius = 16.0,
    EdgeInsets padding =
        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  }) {
    return OutlinedButton.styleFrom(
      foregroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
      side: BorderSide(
        color: isDark
            ? AppColors.darkPrimaryVariant
            : AppColors.lightPrimaryVariant,
      ),
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  ButtonStyle text({
    double borderRadius = 16.0,
    EdgeInsets padding =
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  }) {
    return TextButton.styleFrom(
      foregroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
