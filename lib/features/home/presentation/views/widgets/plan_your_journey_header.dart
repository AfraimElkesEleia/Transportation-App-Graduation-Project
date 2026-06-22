import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/theming/font_weight_helper.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';

class PlanYourJourneyHeader extends StatelessWidget {
  const PlanYourJourneyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const FaIcon(FontAwesomeIcons.train, color: Colors.white, size: 20),
        const SizedBox(width: 12),
        Text(
          AppLocalizations.of(context)!.planYourJourney,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeightHelper.medium,
          ),
        ),
      ],
    );
  }
}
