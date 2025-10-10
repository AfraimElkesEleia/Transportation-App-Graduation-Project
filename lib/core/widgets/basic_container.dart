
import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';

class BasicContainer extends StatelessWidget {
  final Widget child;
  const BasicContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
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
      ),
    );
  }
}
