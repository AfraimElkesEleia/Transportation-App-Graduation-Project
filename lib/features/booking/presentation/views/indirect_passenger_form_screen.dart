import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/booking/presentation/cubit/indirect_booking_state.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_state.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';

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
  late final List<_PassengerControllers> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.bookingState.requiredSeatCount,
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

    final passengers = List.generate(widget.bookingState.requiredSeatCount, (
      i,
    ) {
      final c = _controllers[i];
      final Map<String, dynamic> p = {
        'passengerName': c.nameController.text.trim(),
        'idNumber': c.idController.text.trim().isEmpty
            ? 'N/A'
            : c.idController.text.trim(),
        'idType': 'NationalId',
      };

      if (isTrain) {
        p['seatNumber'] = '${i + 1}';
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

  void _submit() {
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

    context.read<SeatMapCubit>().addMultipleToCart(
      payloads: [leg1Payload, leg2Payload],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasTrain =
        _isTrain(widget.bookingState.selectedTripLeg1!) ||
        _isTrain(widget.bookingState.selectedTripLeg2!);

    return Scaffold(
      backgroundColor: ColorsManager.seatBg,
      appBar: AppBar(
        title: const Text(
          'Passenger Details',
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
        backgroundColor: ColorsManager.seatContainerBg,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocListener<SeatMapCubit, SeatMapState>(
        listener: (context, state) {
          if (state is CartSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Indirect Trip successfully added to Cart!'),
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
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.bookingState.requiredSeatCount,
                  itemBuilder: (_, index) {
                    return _PassengerCard(
                      label: 'Passenger ${index + 1}',
                      controllers: _controllers[index],
                      hasTrainAnywhere: hasTrain,
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: ColorsManager.seatContainerBg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.accentCyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: BlocBuilder<SeatMapCubit, SeatMapState>(
                      builder: (context, state) {
                        if (state is SeatMapLoading) {
                          return const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          );
                        }
                        return const Text(
                          'Add Entire Journey to Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

class _PassengerCard extends StatelessWidget {
  final String label;
  final _PassengerControllers controllers;
  final bool hasTrainAnywhere;

  const _PassengerCard({
    required this.label,
    required this.controllers,
    required this.hasTrainAnywhere,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsManager.borderDim),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: ColorsManager.accentCyan,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controllers.nameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Full Name',
              labelStyle: TextStyle(color: ColorsManager.textMuted),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          if (hasTrainAnywhere) ...[
            TextFormField(
              controller: controllers.idController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'National ID',
                labelStyle: TextStyle(color: ColorsManager.textMuted),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
          ],
          TextFormField(
            controller: controllers.phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              labelStyle: TextStyle(color: ColorsManager.textMuted),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controllers.emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Email Address (Optional)',
              labelStyle: TextStyle(color: ColorsManager.textMuted),
            ),
          ),
          const SizedBox(height: 12),
          if (!hasTrainAnywhere) ...[
            DropdownButtonFormField<String>(
              initialValue: controllers.gender,
              dropdownColor: ColorsManager.surfaceDark,
              items: const [
                DropdownMenuItem(
                  value: 'Male',
                  child: Text('Male', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'Female',
                  child: Text('Female', style: TextStyle(color: Colors.white)),
                ),
              ],
              onChanged: (v) => controllers.gender = v!,
              decoration: const InputDecoration(
                labelText: 'Gender',
                labelStyle: TextStyle(color: ColorsManager.textMuted),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
