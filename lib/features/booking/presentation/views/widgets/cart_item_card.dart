import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/booking/domain/entities/cart_entity.dart';
import 'package:transportation_app/features/booking/presentation/cubit/cart_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/cart_state.dart';

class CartItemCard extends StatelessWidget {
  final CartItemEntity item;

  const CartItemCard({super.key, required this.item});

  Color get _agencyColor {
    final n = item.agencyName.toLowerCase();
    if (n.contains('gobus')) return ColorsManager.agencyGoBus;
    if (n.contains('blue')) return ColorsManager.agencyBlueBus;
    if (n.contains('rail') || n.contains('train') || n.contains('enr')) return ColorsManager.agencyRailway;
    if (n.contains('horus')) return ColorsManager.agencyHorus;
    return ColorsManager.agencyDefault;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: ColorsManager.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsManager.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _agencyColor.withAlpha(30),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(bottom: BorderSide(color: _agencyColor.withAlpha(50))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Agency chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _agencyColor.withAlpha(50),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: _agencyColor.withAlpha(120)),
                        ),
                        child: Text(
                          item.agencyName,
                          style: TextStyle(
                            color: _agencyColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Row 1: gov → gov (large)
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              item.originGov.isNotEmpty ? item.originGov : item.origin,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.arrow_forward, color: ColorsManager.accentCyan, size: 14),
                          ),
                          Flexible(
                            child: Text(
                              item.destinationGov.isNotEmpty ? item.destinationGov : item.destination,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      // Row 2: Arabic station names (muted)
                      if (item.origin.isNotEmpty || item.destination.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            '${item.origin}  •  ${item.destination}',
                            style: const TextStyle(
                              color: ColorsManager.textMuted,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: ColorsManager.accentCyan.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ColorsManager.accentCyan.withAlpha(76)),
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

          // Passengers Expansion & Cancel Button
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: ColorsManager.accentCyan,
              collapsedIconColor: ColorsManager.textMuted,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item.seatsBooked} Passenger(s)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      bool isCancelling = state is CartItemCancelling && state.bookingId == item.bookingId;
                      return isCancelling
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.red,
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                              onPressed: () => _confirmCancel(context, item.bookingId),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            );
                    },
                  ),
                ],
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

  void _confirmCancel(BuildContext context, int bookingId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ColorsManager.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel this trip?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'Your seat hold will be released and inventory restored. '
          'This cannot be undone.',
          style: TextStyle(color: Colors.white60),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep It', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CartCubit>().cancelItem(bookingId);
            },
            child: const Text('Cancel Trip',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
