
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/theming/styles.dart';

class PrivateCarRidesItem extends StatelessWidget {
  const PrivateCarRidesItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: ShapeDecoration(
        color: Color(0xFF194482),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
          side: BorderSide(width: 1, color: ColorsManager.cyanBlue),
        ),
      ),
      child: Row(
        children: [
          carLogo(),
          horizontalSpace(space: 4),
          Expanded(
            child: tripDetailsAndAvailableSeats(context),
          ),
          horizontalSpace(space: 4),
          carTypeAndPrice(context),
        ],
      ),
    );
  }

  Column carTypeAndPrice(BuildContext context) {
    return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: ShapeDecoration(
                color: Color(0xFF216597),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  side: BorderSide(width: 1, color: Color(0xFF3FDDCF)),
                ),
              ),
              child: Text(
                "Private Car",
                style: AppStyles.semiBold18White(
                  context,
                ).copyWith(color: Color(0xFF3FDDCF), fontSize: 14),
              ),
            ),
            Text(
              "150 EGP",
              style: AppStyles.bold16CyanBlue(
                context,
              ).copyWith(fontSize: 18),
            ),
          ],
        );
  }

  Column tripDetailsAndAvailableSeats(BuildContext context) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cairo -> Alex",
                style: AppStyles.semiBold18White(context),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "⭐4.8 ",
                      style: AppStyles.regular16CyanBlue(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
                    Text(
                      "2 seats available",
                      style: AppStyles.regular16CyanBlue(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  FittedBox carLogo() {
    return FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(8),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(100),
              ),
              color: Color(0xFF215F89),
            ),
            child: Center(
              child: Icon(
                FontAwesomeIcons.carSide,
                color: ColorsManager.cyanBlue,
              ),
            ),
          ),
        );
  }
}