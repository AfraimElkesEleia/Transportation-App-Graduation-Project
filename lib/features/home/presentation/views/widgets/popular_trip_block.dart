import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/theming/styles.dart';
import 'package:transportation_app/core/widgets/block_container.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/popular_trip_item.dart';

class PopularTripBlock extends StatelessWidget {
  const PopularTripBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return BlockContainer(
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.arrowTrendUp,
                color: ColorsManager.cyanBlue,
              ),
              horizontalSpace(space: 10),
              Text("Popular Routes", style: AppStyles.semiBold18White(context)),
            ],
          ),
          verticalSpace(space: 12),
          Column(
            children: [PopularTripItem(), PopularTripItem(), PopularTripItem()],
          ),
        ],
      ),
    );
  }
}
