import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';

class BasicContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const BasicContainer({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorsManager.darkBlue,
            ColorsManager.middleColor,
            ColorsManager.lightColor,
          ],
        ),
      ),
      child: child,
    );
  }
}
