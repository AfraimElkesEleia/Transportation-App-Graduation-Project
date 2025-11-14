import 'package:flutter/material.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/theming/styles.dart';

class PopularTripItem extends StatelessWidget {
  const PopularTripItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(8),
      decoration: ShapeDecoration(
        color: Color(0XFF11255E),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: ColorsManager.cyanBlue),
          borderRadius: BorderRadiusGeometry.circular(20),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.train, color: ColorsManager.cyanBlue),
          horizontalSpace(space: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Alex -> Sohag",
                style: AppStyles.bold18DarkBlue(
                  context,
                ).copyWith(color: Colors.white),
              ),
              Text("3h 30 min", style: TextStyle(color: Colors.white)),
            ],
          ),
          Expanded(child: SizedBox()),
          Column(
            children: [
              Text(
                "120 EGP",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF40E0D0),
                  fontSize: 18,
                ),
              ),
              Row(
                children: [
                  Text("⭐ 4.9", style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}