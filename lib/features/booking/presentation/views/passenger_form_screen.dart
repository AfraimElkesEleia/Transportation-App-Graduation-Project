import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/utils/error_localizer.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_state.dart';
import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_states.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/points_redemption_widget.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/passenger_form/passenger_autofill_banner.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/passenger_form/passenger_card.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/passenger_form/passenger_form_app_bar.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/passenger_form/passenger_form_controllers.dart';

bool _keepHomeRoute(Route<dynamic> route) =>
    route.settings.name == AppRoutes.homeScreen || route.isFirst;

class PassengerFormScreen extends StatefulWidget {
  final TripResultEntity trip;
  final CoachClassEntity coachClass;
  final List<String> selectedSeats;
  final bool isTrain;

  const PassengerFormScreen({
    super.key,
    required this.trip,
    required this.coachClass,
    required this.selectedSeats,
    required this.isTrain,
  });

  @override
  State<PassengerFormScreen> createState() => _PassengerFormScreenState();
}

class _PassengerFormScreenState extends State<PassengerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // One controller set per passenger
  late final List<PassengerFormControllers> _controllers;

  // Loyalty points for "Book Now"
  int _selectedPoints = 0;

  // Autocomplete state — tracks whether the banner is in "re-fill" mode
  bool _autofilled = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.selectedSeats.length,
      (_) => PassengerFormControllers(),
    );
    // Listen on first passenger fields to reset _autofilled badge when user edits
    _controllers.first.nameController.addListener(_onFirstChanged);
    _controllers.first.phoneController.addListener(_onFirstChanged);

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
      if (widget.isTrain) {
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

  @override
  void dispose() {
    _controllers.first.nameController.removeListener(_onFirstChanged);
    _controllers.first.phoneController.removeListener(_onFirstChanged);
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  /// Copies name + phone from seat 0 to all other seats.
  /// Validates that seat 0 has both fields before proceeding.
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

  List<Map<String, dynamic>> _buildPassengersPayload() {
    return List.generate(widget.selectedSeats.length, (i) {
      final c = _controllers[i];
      final Map<String, dynamic> payload = {};

      if (widget.isTrain) {
        // ENR (train): name + ID required, seat is auto-assigned
        payload['passengerName'] = c.nameController.text.trim();
        payload['idNumber'] = c.idController.text.trim();
        payload['idType'] = c.selectedIdType; // 'NationalId' or 'Passport'
      } else {
        // Non-ENR (bus): only seat number is required per passenger
        payload['passengerName'] = c.nameController.text.trim();
        payload['seatNumber'] = widget.selectedSeats[i];
      }

      return payload;
    });
  }

  void _submit({required bool bookNow}) {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<SeatMapCubit>();
    final passengers = _buildPassengersPayload();

    final contactName = _controllers.first.nameController.text.trim();
    final contactPhone = _controllers.first.phoneController.text.trim();
    final contactEmail = _controllers.first.emailController.text.trim();

    if (bookNow) {
      cubit.bookNow(
        tripOccurrenceId: widget.trip.tripOccurrenceId,
        coachClassId: widget.coachClass.coachClassId,
        originStationId: widget.trip.originStationId,
        destinationStationId: widget.trip.destinationStationId,
        contactName: contactName,
        contactPhone: contactPhone,
        contactEmail: contactEmail.isEmpty ? 'user@example.com' : contactEmail,
        passengers: passengers,
        pointsToRedeem: _selectedPoints,
      );
    } else {
      cubit.addToCart(
        tripOccurrenceId: widget.trip.tripOccurrenceId,
        coachClassId: widget.coachClass.coachClassId,
        originStationId: widget.trip.originStationId,
        destinationStationId: widget.trip.destinationStationId,
        contactName: contactName,
        contactPhone: contactPhone,
        contactEmail: contactEmail.isEmpty ? 'user@example.com' : contactEmail,
        passengers: passengers,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Read loyalty points balance — ProfileCubit is always provided in scope
    // by the router (MultiBlocProvider on passengerFormScreen route).
    int loyaltyBalance = 0;
    final profileState = context.watch<ProfileCubit>().state;
    if (profileState is ProfileLoaded) {
      loyaltyBalance = profileState.profile.loyaltyPointsBalance ?? 0;
    }

    return Scaffold(
      backgroundColor: ColorsManager.seatBg,
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<SeatMapCubit, SeatMapState>(
              listener: (context, state) {
                final l10n = AppLocalizations.of(context)!;
                if (state is CartSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.journeyAddedToCart),
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
              // ── App bar ──
              const PassengerFormAppBar(),

              // ── Form ──
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    children: [
                      // Passenger cards — with autofill banner after first card
                      ...() {
                        final widgets = <Widget>[];
                        for (
                          int index = 0;
                          index < widget.selectedSeats.length;
                          index++
                        ) {
                          final seatLabel = widget.isTrain
                              ? AppLocalizations.of(
                                  context,
                                )!.passengerN('${index + 1}')
                              : AppLocalizations.of(
                                  context,
                                )!.seatLabel(widget.selectedSeats[index]);
                          widgets.add(
                            PassengerCard(
                              label: seatLabel,
                              controllers: _controllers[index],
                              isTrain: widget.isTrain,
                            ),
                          );

                          // Show the autofill banner after the FIRST card
                          // only for bus with 2+ seats
                          if (index == 0 &&
                              !widget.isTrain &&
                              widget.selectedSeats.length > 1) {
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

                      // ── Loyalty points section (for Book Now) ──────────
                      PointsRedemptionWidget(
                        cartTotal:
                            widget.coachClass.price *
                            widget.selectedSeats.length,
                        walletPoints: loyaltyBalance,
                        onPointsChanged: (pts) =>
                            setState(() => _selectedPoints = pts),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              // ── Bottom buttons ──
              _FormBottomButtons(
                onAddToCart: () => _submit(bookNow: false),
                onBookNow: () => _submit(bookNow: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// _FormBottomButtons — Add to Cart + Book Now
// ─────────────────────────────────────────────────────────────────
class _FormBottomButtons extends StatefulWidget {
  final VoidCallback onAddToCart;
  final VoidCallback onBookNow;

  const _FormBottomButtons({
    required this.onAddToCart,
    required this.onBookNow,
  });

  @override
  State<_FormBottomButtons> createState() => _FormBottomButtonsState();
}

class _FormBottomButtonsState extends State<_FormBottomButtons> {
  // 0 = none, 1 = add to cart, 2 = book now
  int _lastClicked = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SeatMapCubit, SeatMapState>(
      listener: (context, state) {
        if (state is CartSuccess ||
            state is CartError ||
            state is CartAddedButCheckoutFailed) {
          setState(() {
            _lastClicked = 0;
          });
        }
      },
      builder: (context, state) {
        final isLoading = state is CartAdding || state is SeatMapLoading;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(color: Color(0xFF1E3A52), height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Row(
                children: [
                  // Add to Cart
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
                          side: const BorderSide(
                            color: ColorsManager.accentCyan,
                          ),
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
                                AppLocalizations.of(context)!.addToCart,
                                style: const TextStyle(
                                  color: ColorsManager.accentCyan,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Book Now
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
                                AppLocalizations.of(context)!.bookNow,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
