import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/booking/domain/entities/seat_map.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/seat_circle.dart';

/// The scrollable seat grid inside the bus container.
///
/// Layout is **hard-coded** per floor number:
/// - Floor 1 (or standard / null) → `2x2`: [A B] · [C D]
/// - Floor 2 (upper deck)         → `1x2`: [A] · [B C]
class SeatGrid extends StatelessWidget {
  final SeatClassMap classMap;
  final Set<String> selectedSeats;
  final void Function(String) onSeatToggle;
  final int? floorNumber;

  const SeatGrid({
    super.key,
    required this.classMap,
    required this.selectedSeats,
    required this.onSeatToggle,
    this.floorNumber,
  });

  // ── Hard-coded layout based on floor number ──────────────────
  ({int left, int right}) get _columns {
    if (floorNumber == 2) return (left: 1, right: 2);
    return (left: 2, right: 2); // Floor 1 / standard / any bus
  }

  List<String?> _rowLabels(int rowNum, int leftCols, int rightCols) {
    final labels = <String?>[];
    final totalColsPerRow = leftCols + rightCols;

    int currentNumber = (rowNum * totalColsPerRow) + 1;
    // Left columns
    for (int i = 0; i < leftCols; i++) {
      labels.add('${currentNumber++}');
    }

    // Aisle
    labels.add(null);

    // Right columns
    for (int i = 0; i < rightCols; i++) {
      labels.add('${currentNumber++}');
    }

    return labels;
  }

  @override
  @override
  Widget build(BuildContext context) {
    final cols = _columns;
    final totalCols = cols.left + cols.right;
    final seatMap = {for (final s in classMap.seats) s.seatNumber: s};

    final rows = classMap.seats.isEmpty
        ? (classMap.remainingSeats / totalCols).ceil()
        : (classMap.seats.length / totalCols).ceil();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: ColorsManager.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ColorsManager.borderDim, width: 1.5),
      ),
      child: CustomScrollView(
        slivers: [
          const SliverPersistentHeader(
            pinned: true,
            delegate: _BusHeaderDelegate(),
          ),

          // ── Seat rows ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((_, rowIndex) {
                final labels = _rowLabels(rowIndex, cols.left, cols.right);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: labels.map((label) {
                      if (label == null) {
                        return const SizedBox(width: 24);
                      }
                      return _buildSeat(
                        label: label,
                        apiSeat: seatMap[label],
                        rowIndex: rowIndex,
                        totalCols: totalCols,
                        labels: labels,
                      );
                    }).toList(),
                  ),
                );
              }, childCount: rows),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),
        ],
      ),
    );
  }

  /// Builds a single seat widget with tap handling.
  Widget _buildSeat({
    required String label,
    required SeatEntity? apiSeat,
    required int rowIndex,
    required int totalCols,
    required List<String?> labels,
  }) {
    // Determine seat status
    final SeatStatus status;
    if (apiSeat != null) {
      status = apiSeat.status;
    } else {
      // Fallback: derive from remainingSeats count
      final seatIndex =
          rowIndex * totalCols +
          labels.where((l) => l != null).toList().indexOf(label);
      status = seatIndex < classMap.remainingSeats
          ? SeatStatus.available
          : SeatStatus.booked;
    }

    final isSelected = selectedSeats.contains(label);
    final displayStatus = isSelected ? SeatStatus.pending : status;
    final canTap =
        status == SeatStatus.available || status == SeatStatus.pending;

    return GestureDetector(
      onTap: canTap ? () => onSeatToggle(label) : null,
      child: SeatCircle(status: displayStatus, label: label, showLabel: true),
    );
  }
}

class _BusHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _BusHeaderDelegate();

  @override
  double get minExtent => 55;
  @override
  double get maxExtent => 55;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: ColorsManager.surfaceDark, // matches the grid bg
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.directions_bus_outlined,
                  color: Colors.white24,
                  size: 26,
                ),
                Icon(Icons.navigation, color: Colors.white24, size: 22),
              ],
            ),
          ),
          Divider(color: Colors.white12, height: 1),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_BusHeaderDelegate old) => false;
}
