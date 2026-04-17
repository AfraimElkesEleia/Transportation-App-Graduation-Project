import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/theming/font_weight_helper.dart';

class PlanYourJourneyHeader extends StatelessWidget {
  const PlanYourJourneyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(FontAwesomeIcons.train, color: Colors.white, size: 20),
        const SizedBox(width: 12),
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
}
