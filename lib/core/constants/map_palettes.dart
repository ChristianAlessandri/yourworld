import 'package:flutter/material.dart';
import 'package:yourworld/core/constants/tailwind_colors.dart';

class StatusColorPalette {
  final Color visited;
  final Color lived;
  final Color want;

  const StatusColorPalette({
    required this.visited,
    required this.lived,
    required this.want,
  });
}

class MapPalettes {
  static const Map<String, StatusColorPalette> palettes = {
    'default': StatusColorPalette(
      visited: TailwindColors.sky500,
      lived: TailwindColors.violet500,
      want: TailwindColors.rose500,
    ),
    'dark': StatusColorPalette(
      visited: TailwindColors.sky700,
      lived: TailwindColors.violet700,
      want: TailwindColors.rose700,
    ),
    'pastel': StatusColorPalette(
      visited: TailwindColors.sky300,
      lived: TailwindColors.violet300,
      want: TailwindColors.rose300,
    ),
  };

  static StatusColorPalette getPalette(String key) {
    return palettes[key] ?? palettes['default']!;
  }

  static List<String> get paletteKeys => palettes.keys.toList();
}
