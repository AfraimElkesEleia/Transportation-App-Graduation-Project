import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/theming/styles.dart';
import 'package:transportation_app/core/widgets/block_container.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/private_car_item.dart';

class PrivateCarRidesBlock extends StatelessWidget {
  const PrivateCarRidesBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return BlockContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(FontAwesomeIcons.car, color: ColorsManager.cyanBlue),
              horizontalSpace(space: 8),
              Text(
                "Private Car Rides",
                style: AppStyles.semiBold18White(context),
              ),
            ],
          ),
          verticalSpace(space: 16),
          PrivateCarRidesItem(),
          verticalSpace(space: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: ColorsManager.cyanBlue,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12),
              ),
              minimumSize: Size(double.infinity, 60),
            ),
            onPressed: () {},
            child: Column(
              children: [Icon(FontAwesomeIcons.carSide), Text("Find a Ride")],
            ),
          ),
        ],
      ),
    );
  }
}
