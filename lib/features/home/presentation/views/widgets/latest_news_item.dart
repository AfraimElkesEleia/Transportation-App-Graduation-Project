
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/theming/styles.dart';

class LatestNewsItem extends StatelessWidget {
  const LatestNewsItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(8),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
          side: BorderSide(width: 0.5, color: Colors.grey),
        ),
        color: Color(0xFF122763),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(FontAwesomeIcons.pooStorm, color: Colors.yellow),
          horizontalSpace(space: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "New High Speed Service",
                  style: AppStyles.bold18DarkBlue(
                    context,
                  ).copyWith(color: Colors.white),
                ),
                Text(
                  "Cairo-Alex route now is 40% faster with new trains",
                  maxLines: 4,
                  overflow: TextOverflow.fade,
                  style: AppStyles.regular16CyanBlue(
                    context,
                  ).copyWith(color: Colors.white),
                ),
                Text(
                  "2 hours",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}