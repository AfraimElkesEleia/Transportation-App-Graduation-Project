import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/theming/font_weight_helper.dart';
import 'package:transportation_app/core/widgets/block_container.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/date_time_field.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/dropdown_cities_menu.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/search_trip_button.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/toggle_app_bar.dart';

class PlanYourJourneyBlock extends StatelessWidget {
  const PlanYourJourneyBlock({super.key});
  Row planYourJourney() {
    return Row(
      children: [
        Icon(FontAwesomeIcons.train, color: Colors.white, size: 20),
        horizontalSpace(space: 12),
        Text(
          "Plan Your Journey",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeightHelper.medium,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlockContainer(
      child: Column(
        children: [
          planYourJourney(),
          verticalSpace(space: 24),
          ToggleAppBar(),
          verticalSpace(space: 24),
          DropdownCitiesMenu(hintText: "From (e.g...Cairo,Alex)"),
          verticalSpace(space: 12),
          DropdownCitiesMenu(hintText: "To (e.g...Luxor,Sohag)"),
          verticalSpace(space: 12),
          Row(children: [Expanded(child: DateTimeField())]),
          verticalSpace(space: 12),
          SearchTripButton(),
        ],
      ),
    );
  }
}
