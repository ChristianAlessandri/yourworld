import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:yourworld/core/constants/app_colors.dart';

class AppDropdown {
  static InputDecoration decoration(BuildContext context) {
    return InputDecoration(
      filled: true,
      fillColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkSurface
          : AppColors.lightSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  static TextStyle textStyle(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }

  static Icon dropdownIcon(BuildContext context) {
    return Icon(
      FluentIcons.chevron_down_20_filled,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static Widget themedDropdown<T>({
    required BuildContext context,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        isExpanded: true,
        decoration: decoration(context),
        style: textStyle(context),
        icon: dropdownIcon(context),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
