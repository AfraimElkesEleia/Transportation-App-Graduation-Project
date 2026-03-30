import 'package:flutter/material.dart';
import 'package:transportation_app/core/constants/cities.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/dropdown_app_menu.dart';

class GovernorateSelector extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final Governorate? selectedGovernorate;
  final SubCity? selectedSubCity;
  final ValueChanged<Governorate?> onGovernorateSelected;
  final ValueChanged<SubCity?> onSubCitySelected;
  final String? errorText;

  const GovernorateSelector({
    super.key,
    required this.title,
    required this.controller,
    required this.selectedGovernorate,
    required this.selectedSubCity,
    required this.onGovernorateSelected,
    required this.onSubCitySelected,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFE0E0E0).withValues(alpha: 0.05),
        border: Border.all(color: const Color(0xFF1E3A52)),
      ),
      child: Column(
        children: [
          DropdownAppMenu<Governorate>(
            items: egyptGovernorates,
            hintText: "$title (e.g. Cairo, Luxor)",
            controller: controller,
            errorText: errorText,
            selectedItem: selectedGovernorate,
            onSelected: onGovernorateSelected,
            displayProperty: 'nameEn',
          ),
          if (selectedGovernorate != null) ...[
            const SizedBox(height: 10),
            DropdownAppMenu<SubCity>(
              items: selectedGovernorate!.subCities,
              hintText: "Sub-city (optional — any station)",
              controller: controller,
              selectedItem: selectedSubCity,
              onSelected: onSubCitySelected,
              displayProperty: 'nameEn',
              allowClearSelection: true,
              prefixIcon: Icons.train_outlined,
            ),
          ],
        ],
      ),
    );
  }
}
