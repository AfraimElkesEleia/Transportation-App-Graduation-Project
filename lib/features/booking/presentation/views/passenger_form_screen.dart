import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_state.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_states.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/points_redemption_widget.dart';

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
  late final List<_PassengerControllers> _controllers;

  // Loyalty points for "Book Now"
  int _selectedPoints = 0;

  // Autocomplete state — tracks whether the banner is in "re-fill" mode
  bool _autofilled = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.selectedSeats.length,
      (_) => _PassengerControllers(),
    );
    // Listen on first passenger fields to reset _autofilled badge when user edits
    _controllers.first.nameController.addListener(_onFirstChanged);
    _controllers.first.phoneController.addListener(_onFirstChanged);
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
        payload['seatNumber'] = 'T-${i + 1}'; // auto placeholder
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
        child: BlocListener<SeatMapCubit, SeatMapState>(
          listener: (context, state) {
            if (state is CartSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Success!'),
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
            if (state is CartAddedButCheckoutFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Ticket added to cart, but checkout failed: ${state.message}',
                  ),
                  backgroundColor: Colors.orange,
                  duration: const Duration(seconds: 4),
                ),
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.cartScreen,
                (route) => route.isFirst,
              );
            }
          },
          child: Column(
            children: [
              // ── App bar ──
              _FormAppBar(trip: widget.trip),

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
                            _PassengerCard(
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
                              _AutofillBanner(
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
// _PassengerControllers — holds text controllers per passenger
// ─────────────────────────────────────────────────────────────────
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

// ─────────────────────────────────────────────────────────────────
// _FormAppBar
// ─────────────────────────────────────────────────────────────────
class _FormAppBar extends StatelessWidget {
  final TripResultEntity trip;

  const _FormAppBar({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: ColorsManager.seatContainerBg,
                borderRadius: BorderRadius.circular(21),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.passengerDetails,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// _PassengerCard — one card per passenger
//   - Bus: Name + Phone + Email (no National ID)
//   - Train (ENR): Name + National ID + Phone + Email
// ─────────────────────────────────────────────────────────────────
class _PassengerCard extends StatefulWidget {
  final String label;
  final _PassengerControllers controllers;
  final bool isTrain;

  const _PassengerCard({
    required this.label,
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
          // ── Seat / passenger label ──
          Text(
            widget.label,
            style: const TextStyle(
              color: ColorsManager.accentCyan,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // ── Full Name (required for all) ──
          _buildTextField(
            controller: widget.controllers.nameController,
            label: loc.fullName,
            icon: Icons.person_outline,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? loc.requiredField : null,
          ),
          const SizedBox(height: 12),

          // ── ID Type Dropdown + ID Number — ONLY for train (ENR) ──
          if (widget.isTrain) ...[
            // ID Type Dropdown
            DropdownButtonFormField<String>(
              value: widget.controllers.selectedIdType,
              decoration: InputDecoration(
                labelText: loc.idTypeLabel,
                labelStyle: const TextStyle(
                  color: ColorsManager.textMuted,
                  fontSize: 13,
                ),
                prefixIcon: const Icon(
                  Icons.badge_outlined,
                  color: ColorsManager.textMuted,
                  size: 20,
                ),
                filled: true,
                fillColor: ColorsManager.seatContainerBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: ColorsManager.accentCyan),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              dropdownColor: ColorsManager.surfaceDark,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              items: [
                DropdownMenuItem(
                  value: 'NationalId',
                  child: Text(loc.idTypeNationalId),
                ),
                DropdownMenuItem(
                  value: 'Passport',
                  child: Text(loc.idTypePassport),
                ),
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
            // ID Number field (label adapts to type)
            _buildTextField(
              controller: widget.controllers.idController,
              label: widget.controllers.selectedIdType == 'NationalId'
                  ? loc.idNumberLabel
                  : loc.passportNumberLabel,
              icon: Icons.credit_card_outlined,
              keyboardType: widget.controllers.selectedIdType == 'NationalId'
                  ? TextInputType.number
                  : TextInputType.text,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? loc.requiredField : null,
            ),
            const SizedBox(height: 12),
          ],

          // ── Phone ──
          _buildTextField(
            controller: widget.controllers.phoneController,
            label: loc.phoneNumberLabel,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? loc.requiredField : null,
          ),
          const SizedBox(height: 12),

          // ── Email ──
          _buildTextField(
            controller: widget.controllers.emailController,
            label: loc.emailOptional,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: ColorsManager.textMuted,
          fontSize: 13,
        ),
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
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

// -----------------------------------------------------------------
// _AutofillBanner - shown between seat 0 and seat 1 for bus legs
// -----------------------------------------------------------------
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
