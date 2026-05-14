import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/theming/colors.dart';

class SwapButton extends StatelessWidget {
  final VoidCallback onSwap;
  final Animation<double> animation;

  const SwapButton({super.key, required this.onSwap, required this.animation});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onSwap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF235272),
            shape: BoxShape.circle,
            border: Border.all(
              color: ColorsManager.cyanBlue.withValues(alpha: 0.4),
            ),
          ),
          child: RotationTransition(
            turns: animation,
            child: Icon(
              FontAwesomeIcons.arrowRightArrowLeft,
              color: ColorsManager.cyanBlue,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}
