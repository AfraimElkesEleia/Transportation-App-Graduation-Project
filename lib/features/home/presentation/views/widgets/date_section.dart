import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/date_time_field.dart';

class DateSection extends StatefulWidget {
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

  @override
  State<DateSection> createState() => _DateSectionState();
}

class _DateSectionState extends State<DateSection> {
  DateTime? _minimumReturnDate;
  final GlobalKey<DateTimeFieldState> _returnDateKey = GlobalKey<DateTimeFieldState>();

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
          widget.isRoundTrip ? 'Departure date' : 'Travel date',
          Icons.flight_takeoff_rounded,
        ),
        DateTimeField(
          controller: widget.dateController,
          errorText: widget.dateError,
          onDateSelected: (date) {
            setState(() {
              _minimumReturnDate = date;
              // If previously selected return date is now before the minimum, clear it
              if (widget.returnDateController.text.isNotEmpty) {
                 final parts = widget.returnDateController.text.split('/');
                 if (parts.length == 3) {
                   final currentReturn = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
                   if (currentReturn.isBefore(date)) {
                     widget.returnDateController.clear();
                   }
                 }
              }
            });
            if (widget.isRoundTrip) {
              // Wait briefly for UI to settle, then pop the return picker.
              Future.delayed(const Duration(milliseconds: 300), () {
                _returnDateKey.currentState?.selectDate();
              });
            }
          },
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          child: widget.isRoundTrip
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _dateSectionLabel('Return date', Icons.flight_land_rounded),
                    DateTimeField(
                      key: _returnDateKey,
                      controller: widget.returnDateController,
                      errorText: widget.returnDateError,
                      minimumDate: _minimumReturnDate,
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
