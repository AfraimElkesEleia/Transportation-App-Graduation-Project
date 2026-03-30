import 'package:flutter/material.dart';
import 'package:transportation_app/core/constants/cities.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/widgets/block_container.dart';
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

  Governorate? _selectedFromGovernorate;
  SubCity? _selectedFromSubCity;
  Governorate? _selectedToGovernorate;
  SubCity? _selectedToSubCity;

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
  void _onFromGovernorateSelected(Governorate? gov) {
    setState(() {
      _selectedFromGovernorate = gov;
      _selectedFromSubCity = null;
      fromSubCityController.clear();
      _fromGovernorateError = gov == null
          ? 'Please select a departure governorate'
          : null;
    });
  }

  void _onToGovernorateSelected(Governorate? gov) {
    setState(() {
      _selectedToGovernorate = gov;
      _selectedToSubCity = null;
      toSubCityController.clear();
      _toGovernorateError = gov == null
          ? 'Please select a destination governorate'
          : null;
    });
  }

  void _onFromSubCitySelected(SubCity? sub) =>
      setState(() => _selectedFromSubCity = sub);

  void _onToSubCitySelected(SubCity? sub) =>
      setState(() => _selectedToSubCity = sub);

  void _swapLocations() {
    setState(() {
      final tempGov = _selectedFromGovernorate;
      _selectedFromGovernorate = _selectedToGovernorate;
      _selectedToGovernorate = tempGov;

      final tempSub = _selectedFromSubCity;
      _selectedFromSubCity = _selectedToSubCity;
      _selectedToSubCity = tempSub;

      final tempFromGovText = fromGovernorateController.text;
      fromGovernorateController.text = toGovernorateController.text;
      toGovernorateController.text = tempFromGovText;

      final tempFromSubText = fromSubCityController.text;
      fromSubCityController.text = toSubCityController.text;
      toSubCityController.text = tempFromSubText;
    });
    animationController.forward(from: 0);
  }

  // ── validation ─────────────────────────────────────────────────────────────
  bool _validate() {
    String? fromGovErr;
    String? toGovErr;
    String? dateErr;
    String? returnDateErr;

    if (_selectedFromGovernorate == null) {
      fromGovErr = 'Please select a departure governorate';
    }

    if (_selectedToGovernorate == null) {
      toGovErr = 'Please select a destination governorate';
    }

    if (_selectedFromGovernorate != null &&
        _selectedToGovernorate != null &&
        _selectedFromGovernorate!.slug == _selectedToGovernorate!.slug) {
      if (_selectedFromSubCity != null &&
          _selectedToSubCity != null &&
          _selectedFromSubCity!.slug == _selectedToSubCity!.slug) {
        toGovErr = 'Destination must differ from departure';
      } else {
        toGovErr = 'Destination governorate must differ from departure';
      }
    }

    if (dateController.text.trim().isEmpty) {
      dateErr = 'Please select a departure date';
    }

    if (_isRoundTrip) {
      if (returnDateController.text.trim().isEmpty) {
        returnDateErr = 'Please select a return date';
      } else if (dateController.text.trim().isNotEmpty) {
        // Simple string compare works if DateTimeField stores "YYYY-MM-DD"
        // Adjust the comparison logic to match your actual date format.
        if (returnDateController.text.compareTo(dateController.text) <= 0) {
          returnDateErr = 'Return date must be after departure';
        }
      }
    }

    setState(() {
      _fromGovernorateError = fromGovErr;
      _toGovernorateError = toGovErr;
      _dateError = dateErr;
      _returnDateError = returnDateErr;
    });

    return fromGovErr == null &&
        toGovErr == null &&
        dateErr == null &&
        returnDateErr == null;
  }

  void _onSearch() {
    if (!_validate()) return;
    context.pushNamed(AppRoutes.searchScreen);
  } // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
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
            title: "From Governorate",
            controller: fromGovernorateController,
            selectedGovernorate: _selectedFromGovernorate,
            selectedSubCity: _selectedFromSubCity,
            onGovernorateSelected: _onFromGovernorateSelected,
            onSubCitySelected: _onFromSubCitySelected,
            errorText: _fromGovernorateError,
          ),
          verticalSpace(space: 12),
          // ── SWAP button ───────────────────────────────────────────────────
          SwapButton(onSwap: _swapLocations, animation: swapAnimation),
          verticalSpace(space: 12),
          GovernorateSelector(
            title: "To Governorate",
            controller: toGovernorateController,
            selectedGovernorate: _selectedToGovernorate,
            selectedSubCity: _selectedToSubCity,
            onGovernorateSelected: _onToGovernorateSelected,
            onSubCitySelected: _onToSubCitySelected,
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
  }
}
