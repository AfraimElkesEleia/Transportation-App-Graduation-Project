import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/booking/domain/entities/cart_entity.dart';

class CartItemCard extends StatelessWidget {
  final CartItemEntity item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsManager.borderDim),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: ColorsManager.seatContainerBg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.agencyName,
                        style: const TextStyle(
                          color: ColorsManager.accentCyan,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.origin}${item.originGov.isNotEmpty ? ' (${item.originGov})' : ''} ➔ ${item.destination}${item.destinationGov.isNotEmpty ? ' (${item.destinationGov})' : ''}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: ColorsManager.accentCyan.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: ColorsManager.accentCyan.withAlpha(76),
                    ),
                  ),
                  child: Text(
                    '${item.totalPrice} EGP',
                    style: const TextStyle(
                      color: ColorsManager.accentCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeInfo(
                  icon: Icons.departure_board,
                  label: 'Departure',
                  time: item.boardingTime,
                ),
                _buildTimeInfo(
                  icon: Icons.event_seat,
                  label: 'Class',
                  text: item.className,
                ),
                _buildTimeInfo(
                  icon: Icons.timer,
                  label: 'Expires',
                  time: item.holdExpiresAt,
                  isWarning: true,
                ),
              ],
            ),
          ),

          // Passengers Expansion
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: ColorsManager.accentCyan,
              collapsedIconColor: ColorsManager.textMuted,
              title: Text(
                '${item.seatsBooked} Passenger(s)',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: item.passengers
                  .map((p) => _buildPassengerRow(p))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo({
    required IconData icon,
    required String label,
    DateTime? time,
    String? text,
    bool isWarning = false,
  }) {
    String display = text ?? 'N/A';
    if (time != null) {
      if (isWarning) {
        final diff = time.difference(DateTime.now());
        if (diff.isNegative) {
          display = 'Expired';
        } else {
          display = '${diff.inMinutes}m';
        }
      } else {
        display = DateFormat('MMM dd, hh:mm a').format(time);
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20,
          color: isWarning ? Colors.redAccent : ColorsManager.textMuted,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: ColorsManager.textMuted, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          display,
          style: TextStyle(
            color: isWarning ? Colors.redAccent : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildPassengerRow(CartPassengerEntity p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: ColorsManager.seatContainerBg,
            child: Text(
              p.seatNumber.isNotEmpty ? p.seatNumber : '-',
              style: const TextStyle(
                color: ColorsManager.accentCyan,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  'ID: ${p.idNumber}',
                  style: const TextStyle(
                    color: ColorsManager.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
