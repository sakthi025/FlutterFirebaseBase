import 'package:flutter/material.dart';

/// Helper mapping to provide compile-time constant icons for Flutter Web font tree-shaking.
class HabitIcons {
  static const List<IconData> all = [
    Icons.self_improvement_rounded,
    Icons.water_drop_rounded,
    Icons.menu_book_rounded,
    Icons.directions_run_rounded,
    Icons.fitness_center_rounded,
    Icons.code_rounded,
    Icons.bedtime_rounded,
    Icons.directions_walk_rounded,
    Icons.brush_rounded,
    Icons.favorite_rounded,
    Icons.psychology_rounded,
  ];

  static IconData fromCodePoint(int codePoint) {
    for (final icon in all) {
      if (icon.codePoint == codePoint) return icon;
    }
    return Icons.star_rounded;
  }
}
