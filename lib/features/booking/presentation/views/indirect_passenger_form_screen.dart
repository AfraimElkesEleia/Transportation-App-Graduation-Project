import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/utils/error_localizer.dart';
import 'package:transportation_app/features/booking/presentation/cubit/indirect_booking_state.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_state.dart';
import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_states.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/points_redemption_widget.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/passenger_form/passenger_autofill_banner.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/passenger_form/passenger_card.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/passenger_form/passenger_form_controllers.dart';

bool _keepHomeRoute(Route<dynamic> route) =>
    route.settings.name == AppRoutes.homeScreen || route.isFirst;

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
  late final List<PassengerFormControllers> _controllers;
  bool _autofilled = false;
  int _selectedPoints = 0;

  int get _passengerCount => widget.bookingState.selectedSeatsLeg1.length;
  double get _journeyTotal {
    final leg1Total =
        widget.bookingState.selectedSeatsLeg1.length *
        widget.bookingState.selectedClassLeg1!.price;
    final leg2Total =
        widget.bookingState.selectedSeatsLeg2.length *
        widget.bookingState.selectedClassLeg2!.price;
    return leg1Total + leg2Total;
  }

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _passengerCount,
      (_) => PassengerFormControllers(),
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
      final hasTrain =
          _isTrain(widget.bookingState.selectedTripLeg1!) ||
          _isTrain(widget.bookingState.selectedTripLeg2!);
      if (hasTrain) {
        if (profile.idNumber != null && profile.idNumber!.isNotEmpty) {
          if (first.idController.text.trim().isEmpty) {
            first.idController.text = profile.idNumber!;
          }
          if (profile.idType != null) {
            setState(() {
              first.selectedIdType = profile.idType == 2
                  ? 'Passport'
                  : 'NationalId';
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

    final passengers = List.generate(_passengerCount, (i) {
      final c = _controllers[i];
      final Map<String, dynamic> p = {
        'passengerName': c.nameController.text.trim(),
      };

      if (isTrain) {
        p['idType'] = c.selectedIdType;
        p['idNumber'] = c.idController.text.trim();
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

  void _submit({required bool bookNow}) {
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

    final cubit = context.read<SeatMapCubit>();
    final payloads = [leg1Payload, leg2Payload];
    if (bookNow) {
      cubit.bookMultipleNow(
        payloads: payloads,
        pointsToRedeem: _selectedPoints,
      );
    } else {
      cubit.addMultipleToCart(payloads: payloads);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasTrain =
        _isTrain(widget.bookingState.selectedTripLeg1!) ||
        _isTrain(widget.bookingState.selectedTripLeg2!);
    int loyaltyBalance = 0;
    final profileState = context.watch<ProfileCubit>().state;
    if (profileState is ProfileLoaded) {
      loyaltyBalance = profileState.profile.loyaltyPointsBalance ?? 0;
    }

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
              final l10n = AppLocalizations.of(context)!;
              if (state is CartSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.indirectTripAddedToCart),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.cartScreen,
                  _keepHomeRoute,
                );
              }
              if (state is CartError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ErrorLocalizer.localize(context, state.message),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              if (state is CartAddedButCheckoutFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.ticketAddedButCheckoutFailed(
                        ErrorLocalizer.localize(context, state.message),
                      ),
                    ),
                    backgroundColor: Colors.orange,
                    duration: const Duration(seconds: 4),
                  ),
                );
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.cartScreen,
                  _keepHomeRoute,
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
                      for (int index = 0; index < _passengerCount; index++) {
                        widgets.add(
                          PassengerCard(
                            label: AppLocalizations.of(
                              context,
                            )!.passengerN('${index + 1}'),
                            controllers: _controllers[index],
                            isTrain: hasTrain,
                          ),
                        );

                        // Show autofill banner after the FIRST card for bus only with 2+ seats
                        if (index == 0 && !hasTrain && _passengerCount > 1) {
                          widgets.add(
                            PassengerAutofillBanner(
                              autofilled: _autofilled,
                              onAutofill: _autofill,
                            ),
                          );
                        }
                      }
                      return widgets;
                    }(),
                    PointsRedemptionWidget(
                      cartTotal: _journeyTotal,
                      walletPoints: loyaltyBalance,
                      onPointsChanged: (pts) =>
                          setState(() => _selectedPoints = pts),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            _IndirectFormBottomButtons(
              onAddToCart: () => _submit(bookNow: false),
              onBookNow: () => _submit(bookNow: true),
            ),
          ],
        ),
      ),
    );
  }
}

class _IndirectFormBottomButtons extends StatefulWidget {
  final VoidCallback onAddToCart;
  final VoidCallback onBookNow;

  const _IndirectFormBottomButtons({
    required this.onAddToCart,
    required this.onBookNow,
  });

  @override
  State<_IndirectFormBottomButtons> createState() =>
      _IndirectFormBottomButtonsState();
}

class _IndirectFormBottomButtonsState
    extends State<_IndirectFormBottomButtons> {
  int _lastClicked = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SeatMapCubit, SeatMapState>(
      listener: (context, state) {
        if (state is CartSuccess ||
            state is CartError ||
            state is CartAddedButCheckoutFailed) {
          setState(() => _lastClicked = 0);
        }
      },
      builder: (context, state) {
        final isLoading = state is CartAdding || state is SeatMapLoading;

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: const BoxDecoration(
            color: ColorsManager.seatContainerBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              setState(() => _lastClicked = 1);
                              widget.onAddToCart();
                            },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: ColorsManager.accentCyan),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: isLoading && _lastClicked == 1
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: ColorsManager.accentCyan,
                              ),
                            )
                          : Text(
                              AppLocalizations.of(
                                context,
                              )!.addEntireJourneyToCart,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: ColorsManager.accentCyan,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              setState(() => _lastClicked = 2);
                              widget.onBookNow();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.accentCyan,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading && _lastClicked == 2
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              AppLocalizations.of(
                                context,
                              )!.bookEntireJourneyNow,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
