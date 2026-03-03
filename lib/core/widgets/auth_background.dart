import 'package:flutter/material.dart';

/// Provides the shared dark-navy gradient background used on all auth screens.
///
/// Wrap any auth screen body with this widget instead of repeating the
/// [Container] + [BoxDecoration] + [LinearGradient] boilerplate.
///
/// Usage:
/// ```dart
/// AuthBackground(
///   child: SingleChildScrollView(child: ...),
/// )
/// ```
class AuthBackground extends StatelessWidget {
  const AuthBackground({
    super.key,
    required this.child,
    this.horizontalPadding = 16,
  });

  final Widget child;
  final double horizontalPadding;

  static const _gradientColors = [Color(0xff0B1F3A), Color(0xff081A33)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _gradientColors,
          ),
        ),
        child: child,
      ),
    );
  }
}

/// The small decorative cyan-to-blue accent bar shown at the top of auth screens.
class AuthAccentBar extends StatelessWidget {
  const AuthAccentBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xff00dbff), Color(0xff004eff)],
        ),
      ),
    );
  }
}