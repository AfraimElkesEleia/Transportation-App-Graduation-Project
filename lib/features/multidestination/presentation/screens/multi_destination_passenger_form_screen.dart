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
  late final List<List<_PassengerControllers>> _controllers;
  late final List<int> _seatCounts;
  late final int _legCount;
  late final List<bool> _isTrainPerLeg;

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
      (i) => List.generate(_seatCounts[i], (_) => _PassengerControllers()),
    );

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
    if (_controllers.isNotEmpty && _controllers.first.isNotEmpty) {
      final first = _controllers.first.first;
      if (first.nameController.text.trim().isEmpty) {
        first.nameController.text = profile.fullName;
      }
      if (first.phoneController.text.trim().isEmpty) {
        first.phoneController.text = profile.phoneNumber;
      }
      if (first.emailController.text.trim().isEmpty) {
        first.emailController.text = profile.email;
      }
      final firstLegIsTrain = _isTrainPerLeg.isNotEmpty && _isTrainPerLeg.first;
      if (firstLegIsTrain) {
        if (profile.idNumber != null && profile.idNumber!.isNotEmpty) {
          if (first.nationalIdController.text.trim().isEmpty) {
            first.nationalIdController.text = profile.idNumber!;
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

  void _submit() {
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
          'seatNumber': seats[pIndex].toString(),
        };

        if (_isTrainPerLeg[legIndex]) {
          pass['idType'] = c.selectedIdType;
          pass['idNumber'] = c.nationalIdController.text.trim();
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

    cubit.submitCart(
      contactName: contactName,
      contactPhone: contactPhone,
      contactEmail: contactEmail.isEmpty ? 'user@example.com' : contactEmail,
      allPassengers: allLegPassengers,
    );
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
        child: BlocConsumer<
          MultiDestinationBookingCubit,
          MultiDestinationBookingState
        >(
          listenWhen: (prev, current) =>
              prev.isAddingToCart != current.isAddingToCart ||
              current.cartSuccess ||
              current.cartError != null,
          listener: (context, state) {
            if (state.cartSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.cartScreen,
                (route) => route.settings.name == AppRoutes.homeScreen,
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
                            )
                              _PassengerCard(
                                index: pIndex + 1,
                                seatNumber: state
                                    .selectedSeats[legIndex]![pIndex]
                                    .toString(),
                                controllers: _controllers[legIndex][pIndex],
                                isTrain: _isTrainPerLeg[legIndex],
                              ),

                            const SizedBox(height: 8),
                          ],
                        ],
                      ),
                    ),

                    // ── Submit button ─────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: ColorsManager.surfaceDark,
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: state.isAddingToCart ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsManager.buttonBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: state.isAddingToCart
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  AppLocalizations.of(context)!.addToCart,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
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
        ),
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
        color: ColorsManager.accentCyan.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorsManager.accentCyan.withOpacity(0.4)),
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

// ── Per-passenger controllers ────────────────────────────────────────────────────────────────
class _PassengerControllers {
  final nameController = TextEditingController();
  final nationalIdController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  // 'NationalId' | 'Passport'
  String selectedIdType = 'NationalId';

  void dispose() {
    nameController.dispose();
    nationalIdController.dispose();
    phoneController.dispose();
    emailController.dispose();
  }
}

// ── Single passenger card ────────────────────────────────────────────────────────────────
class _PassengerCard extends StatefulWidget {
  final int index;
  final String seatNumber;
  final _PassengerControllers controllers;
  final bool isTrain;

  const _PassengerCard({
    required this.index,
    required this.seatNumber,
    required this.controllers,
    required this.isTrain,
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
        border: Border.all(color: ColorsManager.borderDim, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loc.passengerN('${widget.index}'),
                style: const TextStyle(
                  color: ColorsManager.accentCyan,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                loc.seatLabel(widget.seatNumber),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: widget.controllers.nameController,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: _inputDecoration(
              label: loc.fullName,
              icon: Icons.person_outline,
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? loc.requiredField : null,
          ),
          const SizedBox(height: 12),
          // ── ID Type Dropdown + ID Number — ONLY for train legs ──
          if (widget.isTrain) ...[
            DropdownButtonFormField<String>(
              value: widget.controllers.selectedIdType,
              decoration: _inputDecoration(
                label: loc.idTypeLabel,
                icon: Icons.badge_outlined,
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
                    widget.controllers.nationalIdController.clear();
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: widget.controllers.nationalIdController,
              keyboardType: widget.controllers.selectedIdType == 'NationalId'
                  ? TextInputType.number
                  : TextInputType.text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: _inputDecoration(
                label: widget.controllers.selectedIdType == 'NationalId'
                    ? loc.idNumberLabel
                    : loc.passportNumberLabel,
                icon: Icons.credit_card_outlined,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? loc.requiredField : null,
            ),
            const SizedBox(height: 12),
          ],
          TextFormField(
            controller: widget.controllers.phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: _inputDecoration(
              label: loc.phoneNumberLabel,
              icon: Icons.phone_outlined,
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? loc.requiredField : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: widget.controllers.emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: _inputDecoration(
              label: loc.emailOptional,
              icon: Icons.email_outlined,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: ColorsManager.textMuted, fontSize: 13),
      prefixIcon: Icon(icon, color: ColorsManager.textMuted, size: 20),
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
