import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/date_time_field.dart';

class DateSection extends StatelessWidget {
  final bool isRoundTrip;
  final TextEditingController dateController;
  final TextEditingController returnDateController;
  final String? dateError;
  final String? returnDateError;

  const DateSection({
    super.key,
    required this.isRoundTrip,
    required this.dateController,
    required this.returnDateController,
    this.dateError,
    this.returnDateError,
  });

  Widget _dateSectionLabel(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: ColorsManager.cyanBlue),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dateSectionLabel(
          isRoundTrip ? 'Departure date' : 'Travel date',
          Icons.flight_takeoff_rounded,
        ),
        DateTimeField(controller: dateController, errorText: dateError),
        AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          child: isRoundTrip
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _dateSectionLabel('Return date', Icons.flight_land_rounded),
                    DateTimeField(
                      controller: returnDateController,
                      errorText: returnDateError,
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
