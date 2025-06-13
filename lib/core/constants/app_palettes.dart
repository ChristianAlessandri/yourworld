import 'package:flutter/material.dart';

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

class AppPalettes {
  static const Map<String, StatusColorPalette> palettes = {
    'default': StatusColorPalette(
      visited: Colors.blueAccent,
      lived: Colors.green,
      want: Colors.orange,
    ),
    'dark': StatusColorPalette(
      visited: Colors.indigo,
      lived: Colors.teal,
      want: Colors.deepOrange,
    ),
    'pastel': StatusColorPalette(
      visited: Color(0xFFAEC6CF),
      lived: Color(0xFFFFB347),
      want: Color(0xFFFF6961),
    ),
  };

  static StatusColorPalette getPalette(String key) {
    return palettes[key] ?? palettes['default']!;
  }

  static List<String> get paletteKeys => palettes.keys.toList();
}
