import 'package:flutter/material.dart';
import 'package:yourworld/core/constants/tailwind_colors.dart';

enum BadgeLevel {
  gray,
  bronze,
  silver,
  gold,
  diamond,
}

BadgeLevel getBadgeLevelByPercentage(double percent) {
  if (percent >= 1.0) return BadgeLevel.diamond;
  if (percent >= 0.75) return BadgeLevel.gold;
  if (percent >= 0.5) return BadgeLevel.silver;
  if (percent >= 0.25) return BadgeLevel.bronze;
  return BadgeLevel.gray;
}

Color getBadgeColor(BadgeLevel level) {
  switch (level) {
    case BadgeLevel.gray:
      return TailwindColors.neutral300;
    case BadgeLevel.bronze:
      return TailwindColors.amber800;
    case BadgeLevel.silver:
      return TailwindColors.slate600;
    case BadgeLevel.gold:
      return TailwindColors.amber400;
    case BadgeLevel.diamond:
      return TailwindColors.sky400;
  }
}
