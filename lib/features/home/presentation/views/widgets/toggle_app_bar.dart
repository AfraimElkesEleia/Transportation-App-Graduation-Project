import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/helper/spacing.dart';

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
    List<Widget> trainsType = [
      trainTypeWidget("All"),
      trainTypeWidget("Train"),
      trainTypeWidget("Bus"),
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
      isSelected: List.generate(
        trainsType.length,
        (index) => index == selectedType,
      ),
      onPressed: onTypeChanged, 
      children: trainsType,
    );
  }
}

Widget trainTypeWidget(String name) => Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    if (name == "Train")
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Icon(FontAwesomeIcons.train, color: Colors.white),
      )
    else if (name == "Bus")
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Icon(FontAwesomeIcons.bus, color: Colors.white),
      ),
    horizontalSpace(space: 6),
    Text(name, style: TextStyle(color: Colors.white)),
  ],
);
