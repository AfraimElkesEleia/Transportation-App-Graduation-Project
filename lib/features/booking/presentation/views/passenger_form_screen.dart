import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_state.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_states.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';

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
  bool _usePoints = false;
  final _pointsCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.selectedSeats.length,
      (_) => _PassengerControllers(),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    _pointsCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _buildPassengersPayload() {
    return List.generate(widget.selectedSeats.length, (i) {
      final c = _controllers[i];
      final Map<String, dynamic> payload = {};

      if (widget.isTrain) {
        // ENR (train): name + ID required, seat is auto-assigned
        payload['passengerName'] = c.nameController.text.trim();
        payload['idNumber'] = c.idController.text.trim();
        payload['idType'] = 'NationalId';
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
      final pts = _usePoints ? (int.tryParse(_pointsCtrl.text.trim()) ?? 0) : 0;
      cubit.bookNow(
        tripOccurrenceId: widget.trip.tripOccurrenceId,
        coachClassId: widget.coachClass.coachClassId,
        originStationId: widget.trip.originStationId,
        destinationStationId: widget.trip.destinationStationId,
        contactName: contactName,
        contactPhone: contactPhone,
        contactEmail: contactEmail.isEmpty ? 'user@example.com' : contactEmail,
        passengers: passengers,
        pointsToRedeem: pts,
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
                      // Passenger cards
                      ...List.generate(widget.selectedSeats.length, (index) {
                        final seatLabel = widget.isTrain
                            ? 'Passenger ${index + 1}'
                            : 'Seat ${widget.selectedSeats[index]}';
                        return _PassengerCard(
                          label: seatLabel,
                          controllers: _controllers[index],
                          isTrain: widget.isTrain,
                        );
                      }),

                      // ── Loyalty points section (for Book Now) ──────────
                      _LoyaltyPointsSection(
                        loyaltyBalance: loyaltyBalance,
                        usePoints: _usePoints,
                        pointsCtrl: _pointsCtrl,
                        onToggle: (val) =>
                            setState(() => _usePoints = val),
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
  String gender = 'Male';

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
          const Expanded(
            child: Text(
              'Passenger Details',
              style: TextStyle(
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
            label: 'Full Name',
            icon: Icons.person_outline,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),

          // ── National ID — ONLY for train (ENR) ──
          if (widget.isTrain) ...[
            _buildTextField(
              controller: widget.controllers.idController,
              label: 'National ID',
              icon: Icons.badge_outlined,
              keyboardType: TextInputType.number,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
          ],

          // ── Phone ──
          _buildTextField(
            controller: widget.controllers.phoneController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),

          // ── Email ──
          _buildTextField(
            controller: widget.controllers.emailController,
            label: 'Email Address (Optional)',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),

          // ── Gender (bus only) ──
          if (!widget.isTrain) _buildGenderDropdown(),
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

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: widget.controllers.gender,
      onChanged: (val) {
        if (val != null) {
          setState(() => widget.controllers.gender = val);
        }
      },
      items: const [
        DropdownMenuItem(value: 'Male', child: Text('Male')),
        DropdownMenuItem(value: 'Female', child: Text('Female')),
      ],
      dropdownColor: ColorsManager.seatContainerBg,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: const TextStyle(
          color: ColorsManager.textMuted,
          fontSize: 13,
        ),
        prefixIcon: const Icon(
          Icons.wc_outlined,
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
          borderSide: const BorderSide(color: ColorsManager.accentCyan),
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
// _LoyaltyPointsSection — shown in form, applies to "Book Now" only
// ─────────────────────────────────────────────────────────────────
class _LoyaltyPointsSection extends StatelessWidget {
  final int loyaltyBalance;
  final bool usePoints;
  final TextEditingController pointsCtrl;
  final ValueChanged<bool> onToggle;

  const _LoyaltyPointsSection({
    required this.loyaltyBalance,
    required this.usePoints,
    required this.pointsCtrl,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: usePoints
              ? const Color(0xFFFFD700).withValues(alpha: 0.4)
              : ColorsManager.borderDim,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.stars_rounded,
                color: Color(0xFFFFD700),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Use Loyalty Points',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Balance: $loyaltyBalance pts',
                      style: TextStyle(
                        color: loyaltyBalance > 0
                            ? const Color(0xFFFFD700)
                            : Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: usePoints,
                onChanged: loyaltyBalance > 0 ? onToggle : null,
                activeThumbColor: const Color(0xFFFFD700),
              ),
            ],
          ),
          if (usePoints) ...[
            const SizedBox(height: 12),
            TextField(
              controller: pointsCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Points to redeem (max 50% of total, max $loyaltyBalance)',
                hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFFFD700)),
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Only applies to "Book Now". Points are capped at 50% of the cart total.',
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
          if (loyaltyBalance == 0)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'You have no loyalty points to redeem.',
                style: TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// _FormBottomButtons — Add to Cart + Book Now
// ─────────────────────────────────────────────────────────────────
class _FormBottomButtons extends StatelessWidget {
  final VoidCallback onAddToCart;
  final VoidCallback onBookNow;

  const _FormBottomButtons({
    required this.onAddToCart,
    required this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SeatMapCubit, SeatMapState>(
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
                        onPressed: isLoading ? null : onAddToCart,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: ColorsManager.accentCyan,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(
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
                        onPressed: isLoading ? null : onBookNow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.accentCyan,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Book Now',
                                style: TextStyle(
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
