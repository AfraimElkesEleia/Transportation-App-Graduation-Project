import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/multidestination/presentation/cubit/multi_destination_booking_cubit.dart';
import 'package:transportation_app/features/multidestination/presentation/cubit/multi_destination_booking_state.dart';

class MultiDestinationPassengerFormScreen extends StatefulWidget {
  const MultiDestinationPassengerFormScreen({super.key});

  @override
  State<MultiDestinationPassengerFormScreen> createState() => _MultiDestinationPassengerFormScreenState();
}

class _MultiDestinationPassengerFormScreenState extends State<MultiDestinationPassengerFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late List<Map<String, dynamic>> _passengers;
  late int _seatCount;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<MultiDestinationBookingCubit>();
    _seatCount = cubit.state.requiredSeatCount;
    _passengers = List.generate(
      _seatCount,
      (index) => {
        'name': '',
        'nationalId': '',
        'gender': 'Male',
        'isEgyptian': true,
      },
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final cubit = context.read<MultiDestinationBookingCubit>();
      
      // Map passengers for all legs
      Map<int, List<Map<String, dynamic>>> allLegPassengers = {};
      
      for (int legIndex = 0; legIndex < cubit.state.legSummaries.length; legIndex++) {
        final seats = cubit.state.selectedSeats[legIndex]!;
        List<Map<String, dynamic>> legPass = [];
        
        for (int pIndex = 0; pIndex < _seatCount; pIndex++) {
          final pass = _passengers[pIndex];
          legPass.add({
            'name': pass['name'],
            'age': 30, 
            'idType': pass['isEgyptian'] ? 1 : 2, 
            'idNumber': pass['nationalId'],
            'seatNumber': seats[pIndex].toString(),
          });
        }
        allLegPassengers[legIndex] = legPass;
      }

      cubit.submitCart(allLegPassengers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.seatBg,
      appBar: AppBar(
        backgroundColor: ColorsManager.surfaceDark,
        title: const Text('Passenger Details', style: TextStyle(color: Colors.white, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<MultiDestinationBookingCubit, MultiDestinationBookingState>(
        listenWhen: (prev, current) => prev.isAddingToCart != current.isAddingToCart || current.cartSuccess,
        listener: (context, state) {
          if (state.cartSuccess) {
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.cartScreen, (route) => route.settings.name == AppRoutes.homeScreen);
          } else if (state.cartError != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.cartError!), backgroundColor: Colors.red));
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      itemCount: _seatCount,
                      itemBuilder: (context, index) {
                        return _PassengerCard(
                          index: index + 1,
                          seatNumber: "Unified Seat ${index + 1}",
                          passData: _passengers[index],
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: ColorsManager.surfaceDark,
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: state.isAddingToCart ? null : _submit,
                        style: ElevatedButton.styleFrom(backgroundColor: ColorsManager.buttonBlue),
                        child: state.isAddingToCart
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

class _PassengerCard extends StatelessWidget {
  final int index;
  final String seatNumber;
  final Map<String, dynamic> passData;

  const _PassengerCard({
    required this.index,
    required this.seatNumber,
    required this.passData,
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
              Text('Passenger $index', style: const TextStyle(color: ColorsManager.accentCyan, fontSize: 14, fontWeight: FontWeight.bold)),
              Text(seatNumber, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: passData['name'],
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              labelText: 'Full Name',
              labelStyle: const TextStyle(color: ColorsManager.textMuted, fontSize: 13),
              prefixIcon: const Icon(Icons.person_outline, color: ColorsManager.textMuted, size: 20),
              filled: true,
              fillColor: ColorsManager.seatContainerBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            onSaved: (val) => passData['name'] = val,
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: passData['nationalId'],
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              labelText: 'National ID',
              labelStyle: const TextStyle(color: ColorsManager.textMuted, fontSize: 13),
              prefixIcon: const Icon(Icons.badge_outlined, color: ColorsManager.textMuted, size: 20),
              filled: true,
              fillColor: ColorsManager.seatContainerBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            onSaved: (val) => passData['nationalId'] = val,
          ),
        ],
      ),
    );
  }
}
