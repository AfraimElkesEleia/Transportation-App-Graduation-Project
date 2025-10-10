import 'package:flutter/material.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
    required PageController pageController,
    required this.index,
  }) : _pageController = pageController;

  final PageController _pageController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (index == 2) {
          context.pushReplacementNamed(AppRoutes.homeScreen);
        } else {
          _pageController.animateToPage(
            index + 1,
            duration: const Duration(milliseconds: 250),
            curve: Curves.linear,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 60),
        backgroundColor: Color(0xFF3fe0d0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            index == 2 ? "Get Start" : "Continue",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ColorsManager.darkBlue,
              fontSize: 18,
            ),
          ),
          horizontalSpace(space: 16),
          Transform.rotate(
            angle: 3.14159265,
            child: Icon(Icons.arrow_back_ios_new),
          ),
        ],
      ),
    );
  }
}
