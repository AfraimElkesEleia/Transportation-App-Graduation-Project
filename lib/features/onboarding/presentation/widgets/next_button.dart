import 'package:flutter/material.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/theming/colors.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onPressed;
  const NextButton({
    super.key,
    required this.onPressed, required this.isLastPage,
  }) ;

  final bool isLastPage;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
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
            isLastPage? "Get Start" : "Continue",
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
