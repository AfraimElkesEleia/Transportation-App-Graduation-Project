
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/helper/spacing.dart';

class ToggleAppBar extends StatefulWidget {
  const ToggleAppBar({super.key});

  @override
  State<ToggleAppBar> createState() => _ToggleAppBarState();
}

class _ToggleAppBarState extends State<ToggleAppBar> {
  List<Widget> trainsType = [
    trainTypeWidget("All"),
    trainTypeWidget("Train"),
    trainTypeWidget("Bus"),
  ];
  int selectedType = 0;
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      constraints: BoxConstraints.expand(
        width: MediaQuery.of(context).size.width / 3.5,
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
      onPressed: (index) {
        setState(() {
          selectedType = index;
        });
      },
      children: trainsType,
    );
  }
}

Widget trainTypeWidget(String name) => Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    if (name == "Train")
      Icon(FontAwesomeIcons.train, color: Colors.white)
    else if (name == "Bus")
      Icon(FontAwesomeIcons.bus, color: Colors.white),
    horizontalSpace(space: 8),
    Text(name, style: TextStyle(color: Colors.white)),
  ],
);
