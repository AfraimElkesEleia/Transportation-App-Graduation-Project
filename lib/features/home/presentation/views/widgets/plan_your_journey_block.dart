import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/widgets/block_container.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/home/domain/entities/station_entity.dart';
import 'package:transportation_app/features/home/domain/entities/station_group_entity.dart';
import 'package:transportation_app/features/home/presentation/cubit/stations_cubit.dart';
import 'package:transportation_app/features/home/presentation/cubit/stations_state.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/date_section.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/governorate_selector.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/plan_your_journey_header.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/search_trip_button.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/swap_button.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/toggle_app_bar.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/trip_type_toggle.dart';

class PlanYourJourneyBlock extends StatefulWidget {
  const PlanYourJourneyBlock({super.key});

  @override
  State<PlanYourJourneyBlock> createState() => _PlanYourJourneyBlockState();
}

class _PlanYourJourneyBlockState extends State<PlanYourJourneyBlock>
    with SingleTickerProviderStateMixin {
  late final TextEditingController dateController;
  late final TextEditingController returnDateController;
  late final TextEditingController fromGovernorateController;
  late final TextEditingController fromSubCityController;
  late final TextEditingController toGovernorateController;
  late final TextEditingController toSubCityController;

  late final AnimationController animationController;
  late final Animation<double> swapAnimation;

  StationGroupEntity? _selectedFromGroup;
  StationEntity? _selectedFromStation;
  StationGroupEntity? _selectedToGroup;
  StationEntity? _selectedToStation;

  bool _isRoundTrip = false;

  String? _fromGovernorateError;
  String? _toGovernorateError;
  String? _dateError;
  String? _returnDateError;

  // ── lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    dateController = TextEditingController();
    returnDateController = TextEditingController();
    fromGovernorateController = TextEditingController();
    fromSubCityController = TextEditingController();
    toGovernorateController = TextEditingController();
    toSubCityController = TextEditingController();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    swapAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    returnDateController.dispose();
    fromGovernorateController.dispose();
    fromSubCityController.dispose();
    toGovernorateController.dispose();
    toSubCityController.dispose();
    animationController.dispose();
    super.dispose();
  }

  // ── handlers ───────────────────────────────────────────────────────────────
  void _onFromGroupSelected(StationGroupEntity? group) {
    setState(() {
      _selectedFromGroup = group;
      _selectedFromStation = null;
      fromGovernorateController.text = group?.governorate ?? '';
      fromSubCityController.clear();
      _fromGovernorateError = null;
    });
  }

  void _onToGroupSelected(StationGroupEntity? group) {
    setState(() {
      _selectedToGroup = group;
      _selectedToStation = null;
      toGovernorateController.text = group?.governorate ?? '';
      toSubCityController.clear();
      _toGovernorateError = null;
    });
  }

  void _onFromStationSelected(StationEntity? station) => setState(() {
    _selectedFromStation = station;
    fromSubCityController.text = station?.englishName ?? '';
  });

  void _onToStationSelected(StationEntity? station) => setState(() {
    _selectedToStation = station;
    toSubCityController.text = station?.englishName ?? '';
  });
  void _swapLocations() {
    setState(() {
      final tempGroup = _selectedFromGroup;
      _selectedFromGroup = _selectedToGroup;
      _selectedToGroup = tempGroup;

      final tempStation = _selectedFromStation;
      _selectedFromStation = _selectedToStation;
      _selectedToStation = tempStation;

      final tempGovText = fromGovernorateController.text;
      fromGovernorateController.text = toGovernorateController.text;
      toGovernorateController.text = tempGovText;

      final tempSubText = fromSubCityController.text;
      fromSubCityController.text = toSubCityController.text;
      toSubCityController.text = tempSubText;
    });
    animationController.forward(from: 0);
  }

  // ── validation ─────────────────────────────────────────────────────────────
  bool _validate() {
    String? fromErr;
    String? toErr;
    String? dateErr;
    String? returnDateErr;

    if (_selectedFromGroup == null) {
      fromErr = 'Please select a departure governorate';
    }
    if (_selectedToGroup == null) {
      toErr = 'Please select a destination governorate';
    }

    // Same governorate selected
    if (_selectedFromGroup != null &&
        _selectedToGroup != null &&
        _selectedFromGroup!.governorate == _selectedToGroup!.governorate) {
      if (_selectedFromStation != null &&
          _selectedToStation != null &&
          _selectedFromStation!.id == _selectedToStation!.id) {
        toErr = 'Destination must differ from departure';
      } else if (_selectedFromStation == null && _selectedToStation == null) {
        toErr = 'Destination governorate must differ from departure';
      }
    }

    if (dateController.text.trim().isEmpty) {
      dateErr = 'Please select a departure date';
    }
    if (_isRoundTrip) {
      if (returnDateController.text.trim().isEmpty) {
        returnDateErr = 'Please select a return date';
      } else if (returnDateController.text.compareTo(dateController.text) <=
          0) {
        returnDateErr = 'Return date must be after departure';
      }
    }

    setState(() {
      _fromGovernorateError = fromErr;
      _toGovernorateError = toErr;
      _dateError = dateErr;
      _returnDateError = returnDateErr;
    });

    return fromErr == null &&
        toErr == null &&
        dateErr == null &&
        returnDateErr == null;
  }

  SearchParams _buildSearchParams() {
    return SearchParams(
      travelDate: _formatDateForApi(dateController.text),
      passengers: 1,
      // Station ID if specific station picked — else governorate name
      fromStationId: _selectedFromStation?.id,
      fromGovernorate: _selectedFromStation == null
          ? _selectedFromGroup!
                .governorate // exact API string
          : null,
      toStationId: _selectedToStation?.id,
      toGovernorate: _selectedToStation == null
          ? _selectedToGroup!
                .governorate // exact API string
          : null,
    );
  }

  String _formatDateForApi(String display) {
    final parts = display.split('/');
    if (parts.length != 3) return display;
    return '${parts[2]}-'
        '${parts[1].padLeft(2, '0')}-'
        '${parts[0].padLeft(2, '0')}';
  }

  void _onSearch() {
    if (!_validate()) return;
    Navigator.pushNamed(
      context,
      AppRoutes.searchScreen,
      arguments: _buildSearchParams(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StationsCubit, StationsState>(
      builder: (context, state) {
        if (state is StationsInitial || state is StationsLoading) {
          return BlockContainer(
            isVip: true,
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    CircularProgressIndicator(color: Colors.cyan),
                    SizedBox(height: 12),
                    Text(
                      'Loading stations...',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Error — no hardcoded fallback
        if (state is StationsError) {
          return BlockContainer(
            isVip: true,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(Icons.wifi_off, color: Colors.red, size: 40),
                  const SizedBox(height: 12),
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.white54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<StationsCubit>().loadStations(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // Loaded — governorates from API only
        final governorates = state as StationsLoaded;
        return BlockContainer(
          isVip: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PlanYourJourneyHeader(),
              verticalSpace(space: 24),
              const ToggleAppBar(),
              verticalSpace(space: 16),
              TripTypeToggle(
                isRoundTrip: _isRoundTrip,
                onChanged: (value) => setState(() => _isRoundTrip = value),
              ),
              verticalSpace(space: 20),
              GovernorateSelector(
                items: governorates.groups,
                title: "From Governorate",
                controller: fromGovernorateController,
                subCityController: fromSubCityController,
                selectedGroup: _selectedFromGroup,
                selectedStation: _selectedFromStation,
                onGroupSelected: _onFromGroupSelected,
                onStationSelected: _onFromStationSelected,
                errorText: _fromGovernorateError,
              ),
              verticalSpace(space: 12),
              // ── SWAP button ───────────────────────────────────────────────────
              SwapButton(onSwap: _swapLocations, animation: swapAnimation),
              verticalSpace(space: 12),
              GovernorateSelector(
                items: governorates.groups,
                title: "To Governorate",
                controller: toGovernorateController,
                subCityController: toSubCityController,
                selectedGroup: _selectedToGroup,
                selectedStation: _selectedToStation,
                onGroupSelected: _onToGroupSelected,
                onStationSelected: _onToStationSelected,
                errorText: _toGovernorateError,
              ),
              verticalSpace(space: 16),
              DateSection(
                isRoundTrip: _isRoundTrip,
                dateController: dateController,
                returnDateController: returnDateController,
                dateError: _dateError,
                returnDateError: _returnDateError,
              ),
              verticalSpace(space: 12),
              // const FilterSection(),
              // verticalSpace(space: 12),
              SearchTripButton(onPressed: _onSearch),
              verticalSpace(space: 12),
            ],
          ),
        );
      },
    );
  }
}
