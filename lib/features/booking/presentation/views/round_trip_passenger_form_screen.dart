import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/booking/presentation/cubit/round_trip_booking_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/round_trip_booking_state.dart';

class RoundTripPassengerFormScreen extends StatefulWidget {
  const RoundTripPassengerFormScreen({super.key});

  @override
  State<RoundTripPassengerFormScreen> createState() => _RoundTripPassengerFormScreenState();
}

class _RoundTripPassengerFormScreenState extends State<RoundTripPassengerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Separate passenger controller lists per leg
  late final List<_PassengerControllers> _outboundControllers;
  late final List<_PassengerControllers> _returnControllers;

  late final int _outboundCount;
  late final int _returnCount;

  @override
  void initState() {
    super.initState();
    final state = context.read<RoundTripBookingCubit>().state;
    _outboundCount = state.selectedOutboundSeats.length;
    _returnCount   = state.selectedReturnSeats.length;

    _outboundControllers = List.generate(_outboundCount, (_) => _PassengerControllers());
    _returnControllers   = List.generate(_returnCount,   (_) => _PassengerControllers());
  }

  @override
  void dispose() {
    for (final c in _outboundControllers) { c.dispose(); }
    for (final c in _returnControllers)   { c.dispose(); }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<RoundTripBookingCubit>();
    final state = cubit.state;

    final List<Map<String, dynamic>> outboundPassengers = [];
    for (int i = 0; i < _outboundCount; i++) {
      final c = _outboundControllers[i];
      outboundPassengers.add({
        'name': c.nameController.text.trim(),
        'age': 25,
        'idNumber': c.idController.text.trim().isEmpty ? 'N/A' : c.idController.text.trim(),
        'phoneNumber': c.phoneController.text.trim(),
        'idType': 5,
        'seatNumber': state.selectedOutboundSeats[i],
      });
    }

    final List<Map<String, dynamic>> returnPassengers = [];
    for (int i = 0; i < _returnCount; i++) {
      final c = _returnControllers[i];
      returnPassengers.add({
        'name': c.nameController.text.trim(),
        'age': 25,
        'idNumber': c.idController.text.trim().isEmpty ? 'N/A' : c.idController.text.trim(),
        'phoneNumber': c.phoneController.text.trim(),
        'idType': 5,
        'seatNumber': state.selectedReturnSeats[i],
      });
    }

    cubit.submitRoundTrip(outboundPassengers, returnPassengers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.seatBg,
      body: SafeArea(
        child: BlocConsumer<RoundTripBookingCubit, RoundTripBookingState>(
          listenWhen: (prev, current) =>
              prev.cartError != current.cartError ||
              prev.cartSuccess != current.cartSuccess,
          listener: (context, state) {
            if (state.cartSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Journey added to cart successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.cartScreen,
                (route) => route.isFirst,
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
            return Column(
              children: [
                _FormAppBar(),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      children: [
                        // ── Outbound Leg Passengers ──────────────────────
                        _LegHeader(
                          label: 'Outbound',
                          seatCount: _outboundCount,
                          icon: Icons.flight_takeoff,
                          color: ColorsManager.accentCyan,
                        ),
                        const SizedBox(height: 8),
                        for (int i = 0; i < _outboundCount; i++)
                          _PassengerCard(
                            index: i + 1,
                            seatLabel: 'Seat: ${state.selectedOutboundSeats[i]}',
                            controllers: _outboundControllers[i],
                          ),

                        const SizedBox(height: 16),

                        // ── Return Leg Passengers ────────────────────────
                        _LegHeader(
                          label: 'Return',
                          seatCount: _returnCount,
                          icon: Icons.flight_land,
                          color: ColorsManager.turquoise,
                        ),
                        const SizedBox(height: 8),
                        for (int i = 0; i < _returnCount; i++)
                          _PassengerCard(
                            index: i + 1,
                            seatLabel: 'Seat: ${state.selectedReturnSeats[i]}',
                            controllers: _returnControllers[i],
                          ),
                      ],
                    ),
                  ),
                ),
                _FormBottomButtons(
                  isAdding: state.isAddingToCart,
                  onAddToCart: _submit,
                ),
              ],
            );
          },
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

  const _LegHeader({
    required this.label,
    required this.seatCount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Text(
            '$label — $seatCount Passenger${seatCount != 1 ? 's' : ''}',
            style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// ── Per-passenger controllers ─────────────────────────────────────────────────
class _PassengerControllers {
  final nameController  = TextEditingController();
  final idController    = TextEditingController();
  final phoneController = TextEditingController();

  void dispose() {
    nameController.dispose();
    idController.dispose();
    phoneController.dispose();
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────
class _FormAppBar extends StatelessWidget {
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
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            ),
          ),
          const Expanded(
            child: Text(
              'Passenger Details',
              style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }
}

// ── Single passenger card ─────────────────────────────────────────────────────
class _PassengerCard extends StatelessWidget {
  final int index;
  final String seatLabel;
  final _PassengerControllers controllers;

  const _PassengerCard({
    required this.index,
    required this.seatLabel,
    required this.controllers,
  });

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Passenger $index',
                style: const TextStyle(
                  color: ColorsManager.accentCyan,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                seatLabel,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: controllers.nameController,
            label: 'Full Name',
            icon: Icons.person_outline,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: controllers.idController,
            label: 'National ID',
            icon: Icons.badge_outlined,
            keyboardType: TextInputType.number,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: controllers.phoneController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
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
      ),
    );
  }
}

// ── Bottom submit bar ─────────────────────────────────────────────────────────
class _FormBottomButtons extends StatelessWidget {
  final bool isAdding;
  final VoidCallback onAddToCart;

  const _FormBottomButtons({required this.isAdding, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: ColorsManager.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isAdding ? null : onAddToCart,
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsManager.accentCyan,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
          ),
          child: isAdding
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Add Journey to Cart',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
