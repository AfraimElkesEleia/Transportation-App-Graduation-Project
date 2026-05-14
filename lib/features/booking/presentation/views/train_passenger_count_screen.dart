import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/seat_app_bar.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';

/// Train flow: no seat map — user picks how many passengers then proceeds.
class TrainPassengerCountScreen extends StatefulWidget {
  final TripResultEntity trip;
  final CoachClassEntity coachClass;
  final void Function(int count) onProceed;
  final int initialCount;

  const TrainPassengerCountScreen({
    super.key,
    required this.trip,
    required this.coachClass,
    required this.onProceed,
    this.initialCount = 1,
  });

  @override
  State<TrainPassengerCountScreen> createState() =>
      _TrainPassengerCountScreenState();
}

class _TrainPassengerCountScreenState extends State<TrainPassengerCountScreen> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.initialCount > 0 ? widget.initialCount : 1;
  }

  @override
  Widget build(BuildContext context) {
    final total = _count * widget.coachClass.price;

    return Scaffold(
      body: Container(
        color: ColorsManager.seatBg,
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            SeatAppBar(trip: widget.trip, coachClass: widget.coachClass),
            const SizedBox(height: 40),

            // ── Train icon ──
            const Icon(Icons.train, color: Colors.white24, size: 72),
            const SizedBox(height: 20),
            const Text(
              'How many passengers?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'EGP ${widget.coachClass.price.toStringAsFixed(0)} per seat',
              style: const TextStyle(
                color: ColorsManager.textMuted,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),

            // ── Counter ──
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CounterButton(
                  icon: Icons.remove,
                  onTap: _count > 1 ? () => setState(() => _count--) : null,
                ),
                const SizedBox(width: 32),
                Text(
                  '$_count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 32),
                _CounterButton(
                  icon: Icons.add,
                  onTap: _count < widget.coachClass.remainingSeats
                      ? () => setState(() => _count++)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.coachClass.remainingSeats} seats available',
              style: const TextStyle(
                color: ColorsManager.textMuted,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 40),

            // ── Total + button ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  Text(
                    'EGP ${total.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => widget.onProceed(_count),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.accentCyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue with $_count Passenger${_count > 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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

// ─────────────────────────────────────────────────────────────────
// _CounterButton — circular +/- button
// ─────────────────────────────────────────────────────────────────
class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CounterButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: onTap != null
              ? const Color(0xFF1A2E4A)
              : const Color(0xFF0D1B2A),
          shape: BoxShape.circle,
          border: Border.all(
            color: onTap != null ? ColorsManager.accentCyan : Colors.white12,
          ),
        ),
        child: Icon(
          icon,
          color: onTap != null ? ColorsManager.accentCyan : Colors.white24,
          size: 22,
        ),
      ),
    );
  }
}
