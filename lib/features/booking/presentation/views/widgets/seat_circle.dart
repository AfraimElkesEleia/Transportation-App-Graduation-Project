import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/booking/domain/entities/seat_map.dart';

/// A circular seat indicator used across the seat selection screen.
///
/// Renders differently based on [status]:
/// - [SeatStatus.available] → transparent with teal border
/// - [SeatStatus.pending]   → cyan glow (user-selected)
/// - [SeatStatus.booked]    → dark fill (taken)
class SeatCircle extends StatelessWidget {
  final SeatStatus status;
  final String     label;
  final double     size;
  final bool       showLabel;

  const SeatCircle({
    super.key,
    required this.status,
    this.label     = '',
    this.size      = 52,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color borderColor;
    final Color textColor;
    final List<BoxShadow> shadows;

    switch (status) {
      case SeatStatus.pending:
        bgColor     = ColorsManager.seatSelected;
        borderColor = ColorsManager.accentCyan;
        textColor   = Colors.white;
        shadows = [
          BoxShadow(
            color:        ColorsManager.seatSelected.withValues(alpha: 0.5),
            blurRadius:   10,
            spreadRadius: 1,
          ),
        ];
        break;
      case SeatStatus.available:
        bgColor     = Colors.transparent;
        borderColor = ColorsManager.seatBorderAvail;
        textColor   = ColorsManager.accentCyan;
        shadows     = const [];
        break;
      case SeatStatus.booked:
        bgColor     = ColorsManager.seatContainerBg;
        borderColor = ColorsManager.seatBorderTaken;
        textColor   = Colors.white24;
        shadows     = const [];
        break;
    }

    return Container(
      width:  size,
      height: size,
      decoration: BoxDecoration(
        color:     bgColor,
        shape:     BoxShape.circle,
        border:    Border.all(color: borderColor, width: 1.5),
        boxShadow: shadows,
      ),
      child: showLabel
          ? Center(
              child: Text(
                label,
                style: TextStyle(
                  color:      textColor,
                  fontWeight: FontWeight.bold,
                  fontSize:   11,
                ),
              ),
            )
          : null,
    );
  }
}
