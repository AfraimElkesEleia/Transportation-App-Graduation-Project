import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/multidestination/presentation/cubit/multi_destination_booking_cubit.dart';
import 'package:transportation_app/features/multidestination/presentation/cubit/multi_destination_booking_state.dart';
import 'package:transportation_app/features/multidestination/presentation/screens/multidestination_summary_screen.dart';
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

class MultiDestinationPassengerFormScreen extends StatefulWidget {
  const MultiDestinationPassengerFormScreen({super.key});

  @override
  State<MultiDestinationPassengerFormScreen> createState() =>
      _MultiDestinationPassengerFormScreenState();
}

class _MultiDestinationPassengerFormScreenState
    extends State<MultiDestinationPassengerFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// _controllers[legIndex][passengerIndex]
  late final List<List<PassengerFormControllers>> _controllers;
  late final List<int> _seatCounts;
  late final int _legCount;
  late final List<bool> _isTrainPerLeg;
  late final List<bool> _autofilledPerLeg;
  int _selectedPoints = 0;

  double _cartTotal(MultiDestinationBookingState state) {
    double total = 0;
    for (int i = 0; i < _legCount; i++) {
      total += _seatCounts[i] * (state.selectedClasses[i]?.price ?? 0);
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    final cubit = context.read<MultiDestinationBookingCubit>();
    _legCount = cubit.state.legSummaries.length;

    // Build controllers per leg based on actual seat count for that leg
    _seatCounts = List.generate(
      _legCount,
      (i) => cubit.state.selectedSeats[i]?.length ?? 0,
    );

    _isTrainPerLeg = List.generate(_legCount, (i) {
      final trip = cubit.state.selectedTrips[i];
      return _isTrain(trip);
    });

    _controllers = List.generate(
      _legCount,
      (i) => List.generate(_seatCounts[i], (_) => PassengerFormControllers()),
    );

    _autofilledPerLeg = List.generate(_legCount, (_) => false);

    for (int legIndex = 0; legIndex < _legCount; legIndex++) {
      if (_controllers[legIndex].isNotEmpty) {
        final legIdx = legIndex;
        _controllers[legIdx].first.nameController.addListener(() {
          if (_autofilledPerLeg[legIdx]) {
            setState(() => _autofilledPerLeg[legIdx] = false);
          }
        });
        _controllers[legIdx].first.phoneController.addListener(() {
          if (_autofilledPerLeg[legIdx]) {
            setState(() => _autofilledPerLeg[legIdx] = false);
          }
        });
      }
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
    for (int legIndex = 0; legIndex < _legCount; legIndex++) {
      if (_controllers[legIndex].isNotEmpty) {
        final first = _controllers[legIndex].first;
        if (first.nameController.text.trim().isEmpty) {
          first.nameController.text = profile.fullName;
        }
        if (first.phoneController.text.trim().isEmpty) {
          first.phoneController.text = profile.phoneNumber;
        }
        if (first.emailController.text.trim().isEmpty) {
          first.emailController.text = profile.email;
        }
        final legIsTrain = _isTrainPerLeg[legIndex];
        if (legIsTrain) {
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
  }

  void _autofillLeg(int legIndex) {
    final legControllers = _controllers[legIndex];
    if (legControllers.isEmpty) return;

    final srcName = legControllers.first.nameController.text.trim();
    final srcPhone = legControllers.first.phoneController.text.trim();

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

    for (int i = 1; i < legControllers.length; i++) {
      legControllers[i].nameController.text = srcName;
      legControllers[i].phoneController.text = srcPhone;
    }
    setState(() => _autofilledPerLeg[legIndex] = true);

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
                )!.filledNSeats('${legControllers.length - 1}', srcName),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  bool _isTrain(TripResultEntity? trip) {
    if (trip == null) return false;
    final name = trip.agencyName.toLowerCase();
    return name.contains('rail') ||
        name.contains('enr') ||
        name.contains('train') ||
        name.contains('talgo');
  }

  @override
  void dispose() {
    for (final legControllers in _controllers) {
      for (final c in legControllers) {
        c.dispose();
      }
    }
    super.dispose();
  }

  void _submit({required bool bookNow}) {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<MultiDestinationBookingCubit>();

    Map<int, List<Map<String, dynamic>>> allLegPassengers = {};

    for (int legIndex = 0; legIndex < _legCount; legIndex++) {
      final seats = cubit.state.selectedSeats[legIndex]!;
      final count = _seatCounts[legIndex];
      List<Map<String, dynamic>> legPass = [];

      for (int pIndex = 0; pIndex < count; pIndex++) {
        final c = _controllers[legIndex][pIndex];
        final pass = <String, dynamic>{
          'passengerName': c.nameController.text.trim(),
        };

        if (_isTrainPerLeg[legIndex]) {
          pass['idType'] = c.selectedIdType;
          pass['idNumber'] = c.idController.text.trim();
        } else {
          pass['seatNumber'] = seats[pIndex].toString();
        }

        legPass.add(pass);
      }
      allLegPassengers[legIndex] = legPass;
    }

    final firstLegControllers =
        _controllers.isNotEmpty && _controllers.first.isNotEmpty
        ? _controllers.first.first
        : null;
    final contactName =
        firstLegControllers?.nameController.text.trim() ?? 'Unknown';
    final contactPhone =
        firstLegControllers?.phoneController.text.trim() ?? 'Unknown';
    final contactEmail = firstLegControllers?.emailController.text.trim() ?? '';

    if (bookNow) {
      cubit.bookNow(
        contactName: contactName,
        contactPhone: contactPhone,
        contactEmail: contactEmail.isEmpty ? 'user@example.com' : contactEmail,
        allPassengers: allLegPassengers,
        pointsToRedeem: _selectedPoints,
      );
    } else {
      cubit.submitCart(
        contactName: contactName,
        contactPhone: contactPhone,
        contactEmail: contactEmail.isEmpty ? 'user@example.com' : contactEmail,
        allPassengers: allLegPassengers,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.seatBg,
      appBar: AppBar(
        backgroundColor: ColorsManager.surfaceDark,
        title: Text(
          AppLocalizations.of(context)!.passengerDetails,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, profileState) {
          if (profileState is ProfileLoaded) {
            _prefillFromProfile(profileState.profile);
          }
        },
        child:
            BlocConsumer<
              MultiDestinationBookingCubit,
              MultiDestinationBookingState
            >(
              listenWhen: (prev, current) =>
                  prev.isAddingToCart != current.isAddingToCart ||
                  prev.isBookingNow != current.isBookingNow ||
                  current.cartSuccess ||
                  current.checkoutSuccess ||
                  current.cartError != null,
              listener: (context, state) {
                if (state.checkoutSuccess || state.cartSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.checkoutSuccess
                            ? AppLocalizations.of(context)!.bookingSuccessful
                            : AppLocalizations.of(context)!.journeyAddedToCart,
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
                      content: Text(state.cartError!),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                final profileState = context.watch<ProfileCubit>().state;
                final loyaltyBalance = profileState is ProfileLoaded
                    ? (profileState.profile.loyaltyPointsBalance ?? 0)
                    : 0;

                return SafeArea(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            children: [
                              for (
                                int legIndex = 0;
                                legIndex < _legCount;
                                legIndex++
                              ) ...[
                                // ── Leg header ──────────────────────────────
                                _LegHeader(
                                  legIndex: legIndex,
                                  seatCount: _seatCounts[legIndex],
                                  summary: state.legSummaries[legIndex],
                                ),
                                const SizedBox(height: 10),

                                // ── Passenger cards for this leg ─────────────
                                for (
                                  int pIndex = 0;
                                  pIndex < _seatCounts[legIndex];
                                  pIndex++
                                ) ...[
                                  PassengerCard(
                                    index: pIndex + 1,
                                    seatLabel: AppLocalizations.of(context)!
                                        .seatLabel(
                                          state.selectedSeats[legIndex]![pIndex]
                                              .toString(),
                                        ),
                                    controllers: _controllers[legIndex][pIndex],
                                    isTrain: _isTrainPerLeg[legIndex],
                                  ),
                                  if (pIndex == 0 &&
                                      !_isTrainPerLeg[legIndex] &&
                                      _seatCounts[legIndex] > 1)
                                    PassengerAutofillBanner(
                                      autofilled: _autofilledPerLeg[legIndex],
                                      onAutofill: () => _autofillLeg(legIndex),
                                    ),
                                ],

                                const SizedBox(height: 8),
                              ],
                              PointsRedemptionWidget(
                                cartTotal: _cartTotal(state),
                                walletPoints: loyaltyBalance,
                                onPointsChanged: (pts) =>
                                    setState(() => _selectedPoints = pts),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),

                        _FormBottomButtons(
                          isAdding: state.isAddingToCart,
                          isBookingNow: state.isBookingNow,
                          onAddToCart: () => _submit(bookNow: false),
                          onBookNow: () => _submit(bookNow: true),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }
}

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
    );
  }
}

// ── Leg section header ────────────────────────────────────────────────────────
class _LegHeader extends StatelessWidget {
  final int legIndex;
  final int seatCount;
  final MultiDestinationLegSummary summary;

  const _LegHeader({
    required this.legIndex,
    required this.seatCount,
    required this.summary,
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
        color: ColorsManager.accentCyan.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorsManager.accentCyan.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.route, color: ColorsManager.accentCyan, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.legN('${legIndex + 1}')} — ${AppLocalizations.of(context)!.passengersCount('$seatCount')}',
                  style: const TextStyle(
                    color: ColorsManager.accentCyan,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  textDirection: TextDirection.ltr,
                  children: [
                    ..._buildGovSubList(
                      summary.fromGov.toLocalizedGov(context),
                      (summary.fromSub ?? " ").toLocalizedStation(context),
                    ),
                    const Text(
                      ' ➔ ',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    ..._buildGovSubList(
                      summary.toGov.toLocalizedGov(context),
                      (summary.toSub ?? " ").toLocalizedStation(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
