import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';

class DotIndicator extends StatelessWidget {
  final bool isActive;
  const DotIndicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: isActive ? 20 : 12,
      height: isActive ? 20 : 12,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
        ),
        color: isActive ? ColorsManager.cyanBlue : ColorsManager.darkBlue,
      ),
    );
  }
}
