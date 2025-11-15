import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/styles.dart';

class FilterSelection extends StatelessWidget {
  final List items;
  const FilterSelection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => DropdownMenu(
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide(color: Color(0xFF4f8c9a), width: 5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: const BorderSide(color: Color(0xFF4f8c9a), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: const BorderSide(color: Color(0xFF4f8c9a), width: 2.5),
          ),
        ),
        width: constraints.maxWidth,
        initialSelection: items[0],
        textStyle: AppStyles.semiBold18White(context),
        dropdownMenuEntries: items
            .map((type) => DropdownMenuEntry(value: type, label: type))
            .toList(),
      ),
    );
  }
}
