import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/multidestination/presentation/cubit/multi_destination_booking_cubit.dart';
import 'package:transportation_app/features/multidestination/presentation/cubit/multi_destination_booking_state.dart';

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

    _controllers = List.generate(
      _legCount,
      (i) => List.generate(_seatCounts[i], (_) => _PassengerControllers()),
    );
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
        legPass.add({
          'passengerName': c.nameController.text.trim(),
          'idType': 'NationalId',
          'idNumber': c.nationalIdController.text.trim(),
          'seatNumber': seats[pIndex].toString(),
        });
      }
      allLegPassengers[legIndex] = legPass;
    }

    final firstLegControllers = _controllers.isNotEmpty && _controllers.first.isNotEmpty ? _controllers.first.first : null;
    final contactName = firstLegControllers?.nameController.text.trim() ?? 'Unknown';
    final contactPhone = firstLegControllers?.phoneController.text.trim() ?? 'Unknown';
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
        title: const Text(
          'Passenger Details',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<MultiDestinationBookingCubit, MultiDestinationBookingState>(
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
                        for (int legIndex = 0; legIndex < _legCount; legIndex++) ...[
                          // ── Leg header ──────────────────────────────
                          _LegHeader(
                            legIndex: legIndex,
                            seatCount: _seatCounts[legIndex],
                            from: state.legSummaries[legIndex].from,
                            to: state.legSummaries[legIndex].to,
                          ),
                          const SizedBox(height: 10),

                          // ── Passenger cards for this leg ─────────────
                          for (int pIndex = 0; pIndex < _seatCounts[legIndex]; pIndex++)
                            _PassengerCard(
                              index: pIndex + 1,
                              seatNumber:
                                  state.selectedSeats[legIndex]![pIndex].toString(),
                              controllers: _controllers[legIndex][pIndex],
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
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Add to Cart',
                                style: TextStyle(
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
    );
  }
}

// ── Leg section header ────────────────────────────────────────────────────────
class _LegHeader extends StatelessWidget {
  final int legIndex;
  final int seatCount;
  final String from;
  final String to;

  const _LegHeader({
    required this.legIndex,
    required this.seatCount,
    required this.from,
    required this.to,
  });

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
                  'Leg ${legIndex + 1} — $seatCount Passenger${seatCount != 1 ? 's' : ''}',
                  style: const TextStyle(
                    color: ColorsManager.accentCyan,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$from → $to',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Per-passenger controllers ─────────────────────────────────────────────────
class _PassengerControllers {
  final nameController     = TextEditingController();
  final nationalIdController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  void dispose() {
    nameController.dispose();
    nationalIdController.dispose();
    phoneController.dispose();
    emailController.dispose();
  }
}

// ── Single passenger card ─────────────────────────────────────────────────────
class _PassengerCard extends StatelessWidget {
  final int index;
  final String seatNumber;
  final _PassengerControllers controllers;

  const _PassengerCard({
    required this.index,
    required this.seatNumber,
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
                'Seat $seatNumber',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controllers.nameController,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: _inputDecoration(
              label: 'Full Name',
              icon: Icons.person_outline,
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controllers.nationalIdController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: _inputDecoration(
              label: 'National ID',
              icon: Icons.badge_outlined,
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controllers.phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: _inputDecoration(
              label: 'Phone Number',
              icon: Icons.phone_outlined,
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controllers.emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: _inputDecoration(
              label: 'Email Address (Optional)',
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
