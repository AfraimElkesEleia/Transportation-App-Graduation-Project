import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';

enum SeatStatus { available, selected, taken }

class Seat {
  final String label;
  SeatStatus status;

  Seat({required this.label, required this.status});
}

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({super.key});

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final int pricePerSeat = 250;

  late List<List<Seat>> seats;

  @override
  void initState() {
    super.initState();
    seats = [
      [
        Seat(label: '1A', status: SeatStatus.taken),
        Seat(label: '1B', status: SeatStatus.taken),
        Seat(label: '1C', status: SeatStatus.available),
        Seat(label: '1D', status: SeatStatus.available),
      ],
      [
        Seat(label: '2A', status: SeatStatus.selected),
        Seat(label: '2B', status: SeatStatus.available),
        Seat(label: '2C', status: SeatStatus.taken),
        Seat(label: '2D', status: SeatStatus.selected),
      ],
      [
        Seat(label: '3A', status: SeatStatus.taken),
        Seat(label: '3B', status: SeatStatus.taken),
        Seat(label: '3C', status: SeatStatus.available),
        Seat(label: '3D', status: SeatStatus.available),
      ],
      [
        Seat(label: '4A', status: SeatStatus.available),
        Seat(label: '4B', status: SeatStatus.available),
        Seat(label: '4C', status: SeatStatus.available),
        Seat(label: '4D', status: SeatStatus.available),
      ],
    ];
  }

  List<Seat> get selectedSeats => seats
      .expand((row) => row)
      .where((s) => s.status == SeatStatus.selected)
      .toList();

  void _onSeatTap(Seat seat) {
    if (seat.status == SeatStatus.taken) return;
    setState(() {
      seat.status = seat.status == SeatStatus.selected
          ? SeatStatus.available
          : SeatStatus.selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = selectedSeats;
    final total = selected.length * pricePerSeat;

    return Scaffold(
      backgroundColor: ColorsManager.seatBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildLegend(),
            const SizedBox(height: 24),
            _buildBusContainer(),
            const Spacer(),
            _buildBottomBar(selected, total),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
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
            child: Column(
              children: [
                Text(
                  'Cairo to Hurghada',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Sat, 24 Oct • GoBus VIP',
                  style: TextStyle(
                    color: ColorsManager.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: ColorsManager.seatContainerBg,
              borderRadius: BorderRadius.circular(21),
            ),
            child: const Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(SeatStatus.available, 'Available'),
        const SizedBox(width: 24),
        _legendItem(SeatStatus.selected, 'Selected'),
        const SizedBox(width: 24),
        _legendItem(SeatStatus.taken, 'Taken'),
      ],
    );
  }

  Widget _legendItem(SeatStatus status, String label) {
    return Row(
      children: [
        _seatCircle(status, size: 20, fontSize: 0, showLabel: false),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: status == SeatStatus.taken ? Colors.white38 : Colors.white70,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildBusContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        decoration: BoxDecoration(
          color: ColorsManager.surfaceDark,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: ColorsManager.borderDim, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.accentCyan.withOpacity(0.04),
              blurRadius: 30,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            // Bus top bar
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.directions_bus_outlined,
                    color: Colors.white38,
                    size: 28,
                  ),
                  Icon(Icons.navigation, color: Colors.white38, size: 26),
                ],
              ),
            ),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 20),
            // Seat grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: seats.map((row) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: row.map((seat) {
                        return GestureDetector(
                          onTap: () => _onSeatTap(seat),
                          child: _seatCircle(seat.status, label: seat.label),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _seatCircle(
    SeatStatus status, {
    String label = '',
    double size = 64,
    double fontSize = 14,
    bool showLabel = true,
  }) {
    Color bgColor;
    Color borderColor;
    Color textColor;
    List<BoxShadow> shadows = [];

    switch (status) {
      case SeatStatus.selected:
        bgColor = ColorsManager.seatSelected;
        borderColor = ColorsManager.accentCyan;
        textColor = Colors.white;
        shadows = [
          BoxShadow(
            color: ColorsManager.seatSelected.withOpacity(0.6),
            blurRadius: 14,
            spreadRadius: 2,
          ),
        ];
        break;
      case SeatStatus.available:
        bgColor = Colors.transparent;
        borderColor = ColorsManager.seatBorderAvail;
        textColor = ColorsManager.accentCyan;
        break;
      case SeatStatus.taken:
        bgColor = ColorsManager.seatContainerBg;
        borderColor = ColorsManager.seatBorderTaken;
        textColor = Colors.white24;
        break;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: shadows,
      ),
      child: showLabel
          ? Center(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildBottomBar(List<Seat> selected, int total) {
    final seatLabels = selected.map((s) => s.label).join(', ');

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Selected: ',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                          text: '${selected.length} Seats',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    seatLabels.isEmpty ? 'No seats selected' : seatLabels,
                    style: const TextStyle(
                      color: ColorsManager.accentCyan,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                  Text(
                    'EGP $total',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: selected.isEmpty ? null : () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: selected.isEmpty
                      ? const LinearGradient(
                          colors: [
                            ColorsManager.seatContainerBg,
                            ColorsManager.seatContainerBg,
                          ],
                        )
                      : const LinearGradient(
                          colors: [
                            ColorsManager.seatSelected,
                            ColorsManager.accentCyan,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Confirm Seats',
                    style: TextStyle(
                      color: selected.isEmpty
                          ? Colors.white38
                          : ColorsManager.seatBg,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
