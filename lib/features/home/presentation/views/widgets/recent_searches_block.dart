import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/theming/styles.dart';

class RecentSearchItem extends StatelessWidget {
  const RecentSearchItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: ShapeDecoration(
        color: Color(0xFF132967),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
          side: BorderSide(width: 0.5, color: Colors.grey),
        ),
      ),
      child: recentSearchesItem(context),
    );
  }

  ListTile recentSearchesItem(BuildContext context) {
    return ListTile(
      leading: Icon(FontAwesomeIcons.clock, color: ColorsManager.cyanBlue),
      title: Text(
        "Alex -> Sohag",
        style: AppStyles.bold18DarkBlue(
          context,
        ).copyWith(color: Colors.white),
      ),
      subtitle: Text("15-01-2024", style: AppStyles.regular18white(context)),
      trailing: Transform.rotate(
        angle: -1.57079633,
        child: Icon(
          FontAwesomeIcons.arrowDown,
          color: ColorsManager.cyanBlue,
        ),
      ),
    );
  }
}
