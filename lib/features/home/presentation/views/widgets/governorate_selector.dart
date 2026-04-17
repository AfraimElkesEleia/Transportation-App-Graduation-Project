import 'package:flutter/material.dart';
import 'package:transportation_app/features/home/domain/entities/station_entity.dart';
import 'package:transportation_app/features/home/domain/entities/station_group_entity.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/dropdown_app_menu.dart';

class GovernorateSelector extends StatelessWidget {
 final List<StationGroupEntity>            items;
  final StationGroupEntity?                 selectedGroup;
  final StationEntity?                      selectedStation;
  final ValueChanged<StationGroupEntity?>   onGroupSelected;
  final ValueChanged<StationEntity?>        onStationSelected;
  final TextEditingController               controller;
  final TextEditingController               subCityController;
  final String                              title;
  final String?                             errorText;

  const GovernorateSelector({
    super.key,
    required this.title,
    required this.controller,
    required this.subCityController, 
    required this.selectedGroup,
    required this.selectedStation,
    required this.onGroupSelected,
    required this.onStationSelected,
    required this.items,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color:  const Color(0xFFE0E0E0).withValues(alpha: 0.05),
        border: Border.all(color: const Color(0xFF1E3A52)),
      ),
      child: Column(
        children: [
          DropdownAppMenu<StationGroupEntity>(
            items:           items,           
            hintText:        '$title (e.g. Cairo, Luxor)',
            controller:      controller,
            errorText:       errorText,
            selectedItem:    selectedGroup,
            onSelected:      onGroupSelected,
            displayProperty: 'nameEn',
          ),
          if (selectedGroup != null) ...[
            const SizedBox(height: 10),
            DropdownAppMenu<StationEntity>(
              items:              selectedGroup!.stations,
              hintText:           'Sub-city (optional — any station)',
              controller:         subCityController,  // ← separate controller
              selectedItem:       selectedStation,
              onSelected:         onStationSelected,
              displayProperty:    'nameEn',
              allowClearSelection: true,
              prefixIcon:         Icons.train_outlined,
            ),
          ],
        ],
      ),
    );
  }
}