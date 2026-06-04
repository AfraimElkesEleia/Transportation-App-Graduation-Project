import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/booking/presentation/cubit/indirect_booking_state.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_state.dart';
import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_states.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';

class IndirectPassengerFormScreen extends StatefulWidget {
  final IndirectBookingState bookingState;

  const IndirectPassengerFormScreen({super.key, required this.bookingState});

  @override
  State<IndirectPassengerFormScreen> createState() =>
      _IndirectPassengerFormScreenState();
}

class _IndirectPassengerFormScreenState
    extends State<IndirectPassengerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final List<_PassengerControllers> _controllers;
  bool _autofilled = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.bookingState.requiredSeatCount,
      (_) => _PassengerControllers(),
    );

    if (_controllers.isNotEmpty) {
      _controllers.first.nameController.addListener(_onFirstChanged);
      _controllers.first.phoneController.addListener(_onFirstChanged);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final profileState = context.read<ProfileCubit>().state;
        if (profileState is ProfileLoaded) {
          _prefillFromProfile(profileState.profile);
        }
      }
    });
  }

  void _prefillFromProfile(ProfileEntity profile) {
    if (_controllers.isNotEmpty) {
      final first = _controllers.first;
      if (first.nameController.text.trim().isEmpty) {
        first.nameController.text = profile.fullName;
      }
      if (first.phoneController.text.trim().isEmpty) {
        first.phoneController.text = profile.phoneNumber;
      }
      if (first.emailController.text.trim().isEmpty) {
        first.emailController.text = profile.email;
      }
      final hasTrain = _isTrain(widget.bookingState.selectedTripLeg1!) ||
                       _isTrain(widget.bookingState.selectedTripLeg2!);
      if (hasTrain) {
        if (profile.idNumber != null && profile.idNumber!.isNotEmpty) {
          if (first.idController.text.trim().isEmpty) {
            first.idController.text = profile.idNumber!;
          }
          if (profile.idType != null) {
            setState(() {
              first.selectedIdType = profile.idType == 2 ? 'Passport' : 'NationalId';
            });
          }
        }
      }
    }
  }

  void _onFirstChanged() {
    if (_autofilled) setState(() => _autofilled = false);
  }

  void _autofill() {
    final srcName = _controllers.first.nameController.text.trim();
    final srcPhone = _controllers.first.phoneController.text.trim();

    if (srcName.isEmpty || srcPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(AppLocalizations.of(context)!.fillNamePhoneFirst),
              ),
            ],
          ),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    for (int i = 1; i < _controllers.length; i++) {
      _controllers[i].nameController.text = srcName;
      _controllers[i].phoneController.text = srcPhone;
    }
    setState(() => _autofilled = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                AppLocalizations.of(
                  context,
                )!.filledNSeats('${_controllers.length - 1}', srcName),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    if (_controllers.isNotEmpty) {
      _controllers.first.nameController.removeListener(_onFirstChanged);
      _controllers.first.phoneController.removeListener(_onFirstChanged);
    }
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  bool _isTrain(TripResultEntity trip) {
    final name = trip.agencyName.toLowerCase();
    return name.contains('rail') ||
        name.contains('enr') ||
        name.contains('train') ||
        name.contains('talgo');
  }

  Map<String, dynamic> _buildPayloadForLeg(
    TripResultEntity trip,
    int coachClassId,
    List<String> selectedSeats,
  ) {
    final isTrain = _isTrain(trip);

    final passengers = List.generate(widget.bookingState.requiredSeatCount, (
      i,
    ) {
      final c = _controllers[i];
      final Map<String, dynamic> p = {
        'passengerName': c.nameController.text.trim(),
        'idNumber': c.idController.text.trim().isEmpty
            ? 'N/A'
            : c.idController.text.trim(),
        'idType': isTrain ? c.selectedIdType : 'NationalId',
      };

      if (isTrain) {
        p['seatNumber'] = '${i + 1}';
      } else {
        p['seatNumber'] = selectedSeats[i];
      }
      return p;
    });

    final contactName = _controllers.first.nameController.text.trim();
    final contactPhone = _controllers.first.phoneController.text.trim();
    final contactEmail = _controllers.first.emailController.text.trim();

    return {
      'tripOccurrenceId': trip.tripOccurrenceId,
      'coachClassId': coachClassId,
      'originStationId': trip.originStationId,
      'destinationStationId': trip.destinationStationId,
      'contactName': contactName,
      'contactPhone': contactPhone,
      'contactEmail': contactEmail.isEmpty ? 'user@example.com' : contactEmail,
      'passengers': passengers,
    };
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final leg1Payload = _buildPayloadForLeg(
      widget.bookingState.selectedTripLeg1!,
      widget.bookingState.selectedClassLeg1!.coachClassId,
      widget.bookingState.selectedSeatsLeg1,
    );

    final leg2Payload = _buildPayloadForLeg(
      widget.bookingState.selectedTripLeg2!,
      widget.bookingState.selectedClassLeg2!.coachClassId,
      widget.bookingState.selectedSeatsLeg2,
    );

    context.read<SeatMapCubit>().addMultipleToCart(
      payloads: [leg1Payload, leg2Payload],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasTrain =
        _isTrain(widget.bookingState.selectedTripLeg1!) ||
        _isTrain(widget.bookingState.selectedTripLeg2!);

    return Scaffold(
      backgroundColor: ColorsManager.seatBg,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.passengerDetails,
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
        backgroundColor: ColorsManager.seatContainerBg,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SeatMapCubit, SeatMapState>(
            listener: (context, state) {
              if (state is CartSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.indirectTripAddedToCart),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.cartScreen,
                  (route) => route.isFirst,
                );
              }
              if (state is CartError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          BlocListener<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileLoaded) {
                _prefillFromProfile(state.profile);
              }
            },
          ),
        ],
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ...() {
                      final widgets = <Widget>[];
                      for (int index = 0; index < widget.bookingState.requiredSeatCount; index++) {
                        widgets.add(
                          _PassengerCard(
                            label: 'Passenger ${index + 1}',
                            controllers: _controllers[index],
                            hasTrainAnywhere: hasTrain,
                          ),
                        );

                        // Show autofill banner after the FIRST card for bus only with 2+ seats
                        if (index == 0 &&
                            !hasTrain &&
                            widget.bookingState.requiredSeatCount > 1) {
                          widgets.add(
                            _AutofillBanner(
                              autofilled: _autofilled,
                              onAutofill: _autofill,
                            ),
                          );
                        }
                      }
                      return widgets;
                    }(),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: ColorsManager.seatContainerBg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.accentCyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: BlocBuilder<SeatMapCubit, SeatMapState>(
                      builder: (context, state) {
                        if (state is SeatMapLoading) {
                          return const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          );
                        }
                        return Text(
                          AppLocalizations.of(context)!.addEntireJourneyToCart,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PassengerControllers {
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  // 'NationalId' | 'Passport'
  String selectedIdType = 'NationalId';

  void dispose() {
    nameController.dispose();
    idController.dispose();
    phoneController.dispose();
    emailController.dispose();
  }
}

class _PassengerCard extends StatefulWidget {
  final String label;
  final _PassengerControllers controllers;
  final bool hasTrainAnywhere;

  const _PassengerCard({
    required this.label,
    required this.controllers,
    required this.hasTrainAnywhere,
  });

  @override
  State<_PassengerCard> createState() => _PassengerCardState();
}

class _PassengerCardState extends State<_PassengerCard> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsManager.borderDim),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.passengerN(widget.label.replaceAll('Passenger ', '')),
            style: const TextStyle(
              color: ColorsManager.accentCyan,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: widget.controllers.nameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: loc.fullName,
              labelStyle: const TextStyle(color: ColorsManager.textMuted),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? loc.requiredField : null,
          ),
          const SizedBox(height: 12),
          // ID Type Dropdown + ID Number — ONLY when trip has a train
          if (widget.hasTrainAnywhere) ...[
            DropdownButtonFormField<String>(
              initialValue: widget.controllers.selectedIdType,
              decoration: InputDecoration(
                labelText: loc.idTypeLabel,
                labelStyle: const TextStyle(color: ColorsManager.textMuted, fontSize: 13),
                prefixIcon: const Icon(Icons.badge_outlined, color: ColorsManager.textMuted, size: 20),
                filled: true,
                fillColor: ColorsManager.seatContainerBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: ColorsManager.accentCyan),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              dropdownColor: ColorsManager.surfaceDark,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              items: [
                DropdownMenuItem(value: 'NationalId', child: Text(loc.idTypeNationalId)),
                DropdownMenuItem(value: 'Passport', child: Text(loc.idTypePassport)),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    widget.controllers.selectedIdType = val;
                    widget.controllers.idController.clear();
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: widget.controllers.idController,
              keyboardType: widget.controllers.selectedIdType == 'NationalId'
                  ? TextInputType.number
                  : TextInputType.text,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: widget.controllers.selectedIdType == 'NationalId'
                    ? loc.idNumberLabel
                    : loc.passportNumberLabel,
                labelStyle: const TextStyle(color: ColorsManager.textMuted),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? loc.requiredField : null,
            ),
            const SizedBox(height: 12),
          ],
          TextFormField(
            controller: widget.controllers.phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: loc.phoneNumberLabel,
              labelStyle: const TextStyle(color: ColorsManager.textMuted),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? loc.requiredField : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: widget.controllers.emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: loc.emailOptional,
              labelStyle: const TextStyle(color: ColorsManager.textMuted),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _AutofillBanner extends StatelessWidget {
  final bool autofilled;
  final VoidCallback onAutofill;

  const _AutofillBanner({required this.autofilled, required this.onAutofill});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorsManager.accentCyan.withAlpha(80),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorsManager.accentCyan.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.family_restroom_rounded,
              color: ColorsManager.accentCyan,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  autofilled
                      ? AppLocalizations.of(context)!.autoFilled
                      : AppLocalizations.of(context)!.travellingWithFamily,
                  style: TextStyle(
                    color: autofilled
                        ? ColorsManager.successGreen
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  AppLocalizations.of(context)!.fillSeat1Info,
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: onAutofill,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: autofilled
                    ? ColorsManager.successGreen
                    : ColorsManager.accentCyan,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              autofilled
                  ? AppLocalizations.of(context)!.reFill
                  : AppLocalizations.of(context)!.autoFill,
              style: TextStyle(
                color: autofilled
                    ? ColorsManager.successGreen
                    : ColorsManager.accentCyan,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
