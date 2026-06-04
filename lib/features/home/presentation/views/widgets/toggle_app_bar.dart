import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';

class ToggleAppBar extends StatelessWidget {
  final int selectedType;
  final ValueChanged<int> onTypeChanged;

  const ToggleAppBar({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = [l10n.all, l10n.train, l10n.bus];
    final List<FaIconData?> icons = [
      null,
      FontAwesomeIcons.train,
      FontAwesomeIcons.bus,
    ];

    return ToggleButtons(
      constraints: BoxConstraints.expand(
        width: MediaQuery.of(context).size.width / 3.6,
        height: 40,
      ),
      borderRadius: BorderRadius.circular(12),
      borderColor: Colors.white70,
      selectedBorderColor: Colors.white,
      fillColor: const Color.fromARGB(255, 8, 22, 62),
      isSelected: List.generate(labels.length, (i) => i == selectedType),
      onPressed: onTypeChanged,
      children: List.generate(
        labels.length,
        (i) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icons[i] != null)
              FittedBox(
                fit: BoxFit.scaleDown,
                child: FaIcon(icons[i], color: Colors.white),
              ),
            horizontalSpace(space: 6),
            Text(labels[i], style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
