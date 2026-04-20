import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_state.dart';
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
    super.dispose();
  }

  List<Map<String, dynamic>> _buildPassengersPayload() {
    return List.generate(widget.selectedSeats.length, (i) {
      final c = _controllers[i];
      final Map<String, dynamic> payload = {
        'name': c.nameController.text.trim(),
        'age': 25,
        'idNumber': c.idController.text.trim().isEmpty
            ? 'N/A'
            : c.idController.text.trim(),
        'phoneNumber': c.phoneController.text.trim(),
      };

      if (widget.isTrain) {
        payload['idType'] = 1;
        payload['seatNumber'] = 'T-${i + 1}';
      } else {
        payload['idType'] = 5;
        payload['seatNumber'] = widget.selectedSeats[i];
      }
      return payload;
    });
  }

  void _submit({required bool bookNow}) {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<SeatMapCubit>();
    final passengers = _buildPassengersPayload();

    if (bookNow) {
      cubit.bookNow(
        tripOccurrenceId: widget.trip.tripOccurrenceId,
        coachClassId: widget.coachClass.coachClassId,
        originStationId: widget.trip.originStationId,
        destinationStationId: widget.trip.destinationStationId,
        passengers: passengers,
      );
    } else {
      cubit.addToCart(
        tripOccurrenceId: widget.trip.tripOccurrenceId,
        coachClassId: widget.coachClass.coachClassId,
        originStationId: widget.trip.originStationId,
        destinationStationId: widget.trip.destinationStationId,
        passengers: passengers,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          },
          child: Column(
            children: [
              // ── App bar ──
              _FormAppBar(trip: widget.trip),

              // ── Form ──
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    itemCount: widget.selectedSeats.length,
                    itemBuilder: (_, index) {
                      final seatLabel = widget.isTrain
                          ? 'Passenger ${index + 1}'
                          : 'Seat ${widget.selectedSeats[index]}';

                      return _PassengerCard(
                        label: seatLabel,
                        controllers: _controllers[index],
                        isTrain: widget.isTrain,
                      );
                    },
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
// _PassengerControllers — holds text controllers + gender per passenger
// ─────────────────────────────────────────────────────────────────
class _PassengerControllers {
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final phoneController = TextEditingController();
  String gender = 'Male';

  void dispose() {
    nameController.dispose();
    idController.dispose();
    phoneController.dispose();
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
// _PassengerCard — one card per passenger with name, ID, gender
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

          // ── Full Name ──
          _buildTextField(
            controller: widget.controllers.nameController,
            label: 'Full Name',
            icon: Icons.person_outline,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),

          // ── National ID & Phone (Required for validation) ──
          _buildTextField(
            controller: widget.controllers.idController,
            label: 'National ID',
            icon: Icons.badge_outlined,
            keyboardType: TextInputType.number,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: widget.controllers.phoneController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),

          if (!widget.isTrain) ...[
            // ── Bus specific fields: Gender ──
            _buildGenderDropdown(),
          ],
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
                    onPressed: onAddToCart,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: ColorsManager.accentCyan),
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
                    onPressed: onBookNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.accentCyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
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
  }
}
