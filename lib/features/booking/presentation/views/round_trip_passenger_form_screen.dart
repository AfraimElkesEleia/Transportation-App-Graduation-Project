import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/utils/error_localizer.dart';
import 'package:transportation_app/features/booking/presentation/cubit/round_trip_booking_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/round_trip_booking_state.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/points_redemption_widget.dart';
import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_states.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/passenger_form/passenger_autofill_banner.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/passenger_form/passenger_card.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/passenger_form/passenger_form_app_bar.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/passenger_form/passenger_form_controllers.dart';

bool _keepHomeRoute(Route<dynamic> route) =>
    route.settings.name == AppRoutes.homeScreen || route.isFirst;

class RoundTripPassengerFormScreen extends StatefulWidget {
  const RoundTripPassengerFormScreen({super.key});

  @override
  State<RoundTripPassengerFormScreen> createState() =>
      _RoundTripPassengerFormScreenState();
}

class _RoundTripPassengerFormScreenState
    extends State<RoundTripPassengerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Separate passenger controller lists per leg
  late final List<PassengerFormControllers> _outboundControllers;
  late final List<PassengerFormControllers> _returnControllers;

  late final int _outboundCount;
  late final int _returnCount;

  int _selectedPoints = 0;

  bool _outboundAutofilled = false;
  bool _returnAutofilled = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<RoundTripBookingCubit>().state;
    _outboundCount = state.selectedOutboundSeats.length;
    _returnCount = state.selectedReturnSeats.length;

    _outboundControllers = List.generate(
      _outboundCount,
      (_) => PassengerFormControllers(),
    );
    _returnControllers = List.generate(
      _returnCount,
      (_) => PassengerFormControllers(),
    );

    if (_outboundControllers.isNotEmpty) {
      _outboundControllers.first.nameController.addListener(
        _onOutboundFirstChanged,
      );
      _outboundControllers.first.phoneController.addListener(
        _onOutboundFirstChanged,
      );
    }
    if (_returnControllers.isNotEmpty) {
      _returnControllers.first.nameController.addListener(
        _onReturnFirstChanged,
      );
      _returnControllers.first.phoneController.addListener(
        _onReturnFirstChanged,
      );
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
    final state = context.read<RoundTripBookingCubit>().state;
    final outboundIsTrain = _isTrain(state.selectedOutboundTrip);
    final returnIsTrain = _isTrain(state.selectedReturnTrip);

    if (_outboundControllers.isNotEmpty) {
      final first = _outboundControllers.first;
      if (first.nameController.text.trim().isEmpty) {
        first.nameController.text = profile.fullName;
      }
      if (first.phoneController.text.trim().isEmpty) {
        first.phoneController.text = profile.phoneNumber;
      }
      if (first.emailController.text.trim().isEmpty) {
        first.emailController.text = profile.email;
      }
      if (outboundIsTrain) {
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

    if (_returnControllers.isNotEmpty) {
      final first = _returnControllers.first;
      if (first.nameController.text.trim().isEmpty) {
        first.nameController.text = profile.fullName;
      }
      if (first.phoneController.text.trim().isEmpty) {
        first.phoneController.text = profile.phoneNumber;
      }
      if (first.emailController.text.trim().isEmpty) {
        first.emailController.text = profile.email;
      }
      if (returnIsTrain) {
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

  void _onOutboundFirstChanged() {
    if (_outboundAutofilled) setState(() => _outboundAutofilled = false);
  }

  void _onReturnFirstChanged() {
    if (_returnAutofilled) setState(() => _returnAutofilled = false);
  }

  void _autofillOutbound() {
    final srcName = _outboundControllers.first.nameController.text.trim();
    final srcPhone = _outboundControllers.first.phoneController.text.trim();

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

    for (int i = 1; i < _outboundControllers.length; i++) {
      _outboundControllers[i].nameController.text = srcName;
      _outboundControllers[i].phoneController.text = srcPhone;
    }
    setState(() => _outboundAutofilled = true);

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
                )!.filledNSeats('${_outboundControllers.length - 1}', srcName),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _autofillReturn() {
    final srcName = _returnControllers.first.nameController.text.trim();
    final srcPhone = _returnControllers.first.phoneController.text.trim();

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

    for (int i = 1; i < _returnControllers.length; i++) {
      _returnControllers[i].nameController.text = srcName;
      _returnControllers[i].phoneController.text = srcPhone;
    }
    setState(() => _returnAutofilled = true);

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
                )!.filledNSeats('${_returnControllers.length - 1}', srcName),
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
    if (_outboundControllers.isNotEmpty) {
      _outboundControllers.first.nameController.removeListener(
        _onOutboundFirstChanged,
      );
      _outboundControllers.first.phoneController.removeListener(
        _onOutboundFirstChanged,
      );
    }
    if (_returnControllers.isNotEmpty) {
      _returnControllers.first.nameController.removeListener(
        _onReturnFirstChanged,
      );
      _returnControllers.first.phoneController.removeListener(
        _onReturnFirstChanged,
      );
    }
    for (final c in _outboundControllers) {
      c.dispose();
    }
    for (final c in _returnControllers) {
      c.dispose();
    }
    super.dispose();
  }

  bool _isTrain(TripResultEntity? trip) {
    if (trip == null) return false;
    final name = trip.agencyName.toLowerCase();
    return name.contains('rail') ||
        name.contains('enr') ||
        name.contains('train') ||
        name.contains('talgo');
  }

  List<Map<String, dynamic>> _buildPassengersPayload({
    required List<PassengerFormControllers> controllers,
    required List<String> seats,
    required bool isTrain,
  }) {
    return List.generate(controllers.length, (i) {
      final c = controllers[i];
      final payload = <String, dynamic>{
        'passengerName': c.nameController.text.trim(),
      };

      if (isTrain) {
        payload['idType'] = c.selectedIdType;
        payload['idNumber'] = c.idController.text.trim();
      } else {
        payload['seatNumber'] = seats[i];
      }

      return payload;
    });
  }

  void _submit({required bool bookNow}) {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<RoundTripBookingCubit>();
    final state = cubit.state;
    final outboundPassengers = _buildPassengersPayload(
      controllers: _outboundControllers,
      seats: state.selectedOutboundSeats,
      isTrain: _isTrain(state.selectedOutboundTrip),
    );
    final returnPassengers = _buildPassengersPayload(
      controllers: _returnControllers,
      seats: state.selectedReturnSeats,
      isTrain: _isTrain(state.selectedReturnTrip),
    );

    final contactName = _outboundControllers.isNotEmpty
        ? _outboundControllers.first.nameController.text.trim()
        : 'Unknown';
    final contactPhone = _outboundControllers.isNotEmpty
        ? _outboundControllers.first.phoneController.text.trim()
        : 'Unknown';
    final contactEmail = _outboundControllers.isNotEmpty
        ? _outboundControllers.first.emailController.text.trim()
        : '';

    if (bookNow) {
      cubit.bookNowRoundTrip(
        contactName: contactName,
        contactPhone: contactPhone,
        contactEmail: contactEmail.isEmpty ? 'user@example.com' : contactEmail,
        outboundPassengers: outboundPassengers,
        returnPassengers: returnPassengers,
        pointsToRedeem: _selectedPoints,
      );
    } else {
      cubit.submitRoundTrip(
        contactName: contactName,
        contactPhone: contactPhone,
        contactEmail: contactEmail.isEmpty ? 'user@example.com' : contactEmail,
        outboundPassengers: outboundPassengers,
        returnPassengers: returnPassengers,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.seatBg,
      body: SafeArea(
        child: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, profileState) {
            if (profileState is ProfileLoaded) {
              _prefillFromProfile(profileState.profile);
            }
          },
          child: BlocConsumer<RoundTripBookingCubit, RoundTripBookingState>(
            listenWhen: (prev, current) =>
                prev.cartError != current.cartError ||
                prev.cartSuccess != current.cartSuccess ||
                prev.checkoutSuccess != current.checkoutSuccess,
            listener: (context, state) {
              if (state.cartError != null && state.cartSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(
                        context,
                      )!.ticketAddedButCheckoutFailed(
                        ErrorLocalizer.localize(context, state.cartError!),
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
              } else if (state.checkoutSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.bookingSuccessful,
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.cartScreen,
                  _keepHomeRoute,
                );
              } else if (state.cartSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.journeyAddedToCart,
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.cartScreen,
                  _keepHomeRoute,
                );
              } else if (state.cartError != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ErrorLocalizer.localize(context, state.cartError!),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              // Per-leg train check — ID fields should only appear for train legs
              final outboundIsTrain = _isTrain(state.selectedOutboundTrip);
              final returnIsTrain = _isTrain(state.selectedReturnTrip);
              final outPrice = state.selectedOutboundClass?.price ?? 0;
              final retPrice = state.selectedReturnClass?.price ?? 0;
              final cartTotal =
                  (outPrice * _outboundCount) + (retPrice * _returnCount);
              // Read loyalty balance here so it rebuilds with ProfileCubit
              final profileState = context.watch<ProfileCubit>().state;
              final loyaltyBalance = profileState is ProfileLoaded
                  ? (profileState.profile.loyaltyPointsBalance ?? 0)
                  : 0;

              return Column(
                children: [
                  const PassengerFormAppBar(),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        children: [
                          // ── Outbound Leg Passengers ──────────────────────
                          _LegHeader(
                            label: AppLocalizations.of(context)!.outbound,
                            seatCount: _outboundCount,
                            icon: Icons.flight_takeoff,
                            color: ColorsManager.accentCyan,
                            trip: state.selectedOutboundTrip,
                          ),
                          const SizedBox(height: 8),
                          for (int i = 0; i < _outboundCount; i++) ...[
                            PassengerCard(
                              index: i + 1,
                              seatLabel: AppLocalizations.of(
                                context,
                              )!.seatLabel(state.selectedOutboundSeats[i]),
                              controllers: _outboundControllers[i],
                              isTrain: outboundIsTrain,
                            ),
                            if (i == 0 &&
                                !outboundIsTrain &&
                                _outboundCount > 1)
                              PassengerAutofillBanner(
                                autofilled: _outboundAutofilled,
                                onAutofill: _autofillOutbound,
                              ),
                          ],

                          const SizedBox(height: 16),

                          // ── Return Leg Passengers ────────────────────────
                          _LegHeader(
                            label: AppLocalizations.of(context)!.returnTrip,
                            seatCount: _returnCount,
                            icon: Icons.flight_land,
                            color: ColorsManager.turquoise,
                            trip: state.selectedReturnTrip,
                          ),
                          const SizedBox(height: 8),
                          for (int i = 0; i < _returnCount; i++) ...[
                            PassengerCard(
                              index: i + 1,
                              seatLabel: AppLocalizations.of(
                                context,
                              )!.seatLabel(state.selectedReturnSeats[i]),
                              controllers: _returnControllers[i],
                              isTrain: returnIsTrain,
                            ),
                            if (i == 0 && !returnIsTrain && _returnCount > 1)
                              PassengerAutofillBanner(
                                autofilled: _returnAutofilled,
                                onAutofill: _autofillReturn,
                              ),
                          ],
                          const SizedBox(height: 16),
                          // ── Loyalty points section (for Book Now) ──────────
                          PointsRedemptionWidget(
                            cartTotal: cartTotal.toDouble(),
                            walletPoints: loyaltyBalance,
                            onPointsChanged: (pts) =>
                                setState(() => _selectedPoints = pts),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  _FormBottomButtons(
                    isAdding: state.isAddingToCart,
                    isBookingNow: state.isBookingNow,
                    onAddToCart: () => _submit(bookNow: false),
                    onBookNow: () => _submit(bookNow: true),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ── Leg section header ────────────────────────────────────────────────────────
class _LegHeader extends StatelessWidget {
  final String label;
  final int seatCount;
  final IconData icon;
  final Color color;
  final TripResultEntity? trip;

  const _LegHeader({
    required this.label,
    required this.seatCount,
    required this.icon,
    required this.color,
    required this.trip,
  });

  List<Widget> _buildGovSubList(String gov, String sub) {
    if (sub.isEmpty || sub == gov) {
      return [
        Text(gov, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ];
    }
    return [
      Text(gov, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      const Text(' - ', style: TextStyle(color: Colors.white70, fontSize: 12)),
      Text(sub, style: const TextStyle(color: Colors.white70, fontSize: 12)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label — ${AppLocalizations.of(context)!.passengersCount('$seatCount')}',
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (trip != null) ...[
                  const SizedBox(height: 2),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    textDirection: TextDirection.ltr,
                    children: [
                      ..._buildGovSubList(
                        trip!.originGovernorate.toLocalizedGov(context),
                        trip!.originStationName.toLocalizedStation(context),
                      ),
                      const Text(
                        ' ➔ ',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      ..._buildGovSubList(
                        trip!.destinationGovernorate.toLocalizedGov(context),
                        trip!.destinationStationName.toLocalizedStation(
                          context,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom submit bar ─────────────────────────────────────────────────────────
class _FormBottomButtons extends StatefulWidget {
  final bool isAdding;
  final bool isBookingNow;
  final VoidCallback onAddToCart;
  final VoidCallback onBookNow;

  const _FormBottomButtons({
    required this.isAdding,
    required this.isBookingNow,
    required this.onAddToCart,
    required this.onBookNow,
  });

  @override
  State<_FormBottomButtons> createState() => _FormBottomButtonsState();
}

class _FormBottomButtonsState extends State<_FormBottomButtons> {
  int _lastClicked = 0;

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.isAdding || widget.isBookingNow;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: ColorsManager.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
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
        ],
      ),
    );
  }
}
