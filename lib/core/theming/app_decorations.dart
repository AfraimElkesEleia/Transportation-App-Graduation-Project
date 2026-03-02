import 'package:flutter/material.dart';

/// Shared decoration factories used by profile, marketplace, and resell screens.
abstract class AppDecorations {
  /// Standard rounded card decoration used for section containers.
  static BoxDecoration roundedCard({
    required Color color,
    double borderRadius = 20,
    Color borderColor = Colors.transparent,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      border: borderColor != Colors.transparent
          ? Border.all(color: borderColor)
          : null,
    );
  }

  /// Dark-themed text field decoration used on the profile screen.
  static InputDecoration profileInput(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white10,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.cyan),
      ),
    );
  }
}
