import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';
 
enum SeatStatus { available, selected, taken }
 
class Seat {
  final String label;
  SeatStatus   status;
  Seat({required this.label, required this.status});
}
 
class SeatSelectionScreen extends StatefulWidget {
  final TripResultEntity  trip;
  final CoachClassEntity  coachClass;
 
  const SeatSelectionScreen({
    super.key,
    required this.trip,
    required this.coachClass,
  });
 
  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}
 
class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  late List<List<Seat>> seats;
 
  // Price per seat comes directly from coachClass
  double get pricePerSeat => widget.coachClass.price;
 
  @override
  void initState() {
    super.initState();
    seats = _generateSeats(widget.coachClass.remainingSeats);
  }
 
  // ── Generate seat grid ─────────────────────────────────────
  // We only know remainingSeats count from API — all shown as available.
  // Layout: 4 columns (A B C D), rows calculated from count.
  List<List<Seat>> _generateSeats(int remainingCount) {
    const columns   = 4;
    const colLabels = ['A', 'B', 'C', 'D'];
 
    // Total grid size — round up to nearest full row
    final rows = (remainingCount / columns).ceil();
 
    final grid = <List<Seat>>[];
 
    int seatIndex = 0;
    for (int row = 1; row <= rows; row++) {
      final rowSeats = <Seat>[];
      for (int col = 0; col < columns; col++) {
        seatIndex++;
        final label  = '$row${colLabels[col]}';
        // Seats beyond remainingCount are marked taken
        final status = seatIndex <= remainingCount
            ? SeatStatus.available
            : SeatStatus.taken;
        rowSeats.add(Seat(label: label, status: status));
      }
      grid.add(rowSeats);
    }
    return grid;
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
 
  // ── Route label ────────────────────────────────────────────
  String get _routeLabel {
    final from = widget.trip.originStationName.isNotEmpty
        ? widget.trip.originStationName
        : widget.trip.originGovernorate;
    final to = widget.trip.destinationStationName.isNotEmpty
        ? widget.trip.destinationStationName
        : widget.trip.destinationGovernorate;
    return '$from → $to';
  }
 
  // Sub-label: agency + class type
  String get _subLabel =>
      '${widget.trip.agencyName} • ${widget.coachClass.groupName} ${widget.coachClass.seatType}';
 
  String _fmt(DateTime? dt) {
    if (dt == null) return '--:--';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
 
  @override
  Widget build(BuildContext context) {
    final selected = selectedSeats;
    final total    = selected.length * pricePerSeat;
 
    return Scaffold(
      backgroundColor: ColorsManager.seatBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildTripInfo(),
            const SizedBox(height: 16),
            _buildLegend(),
            const SizedBox(height: 20),
            Expanded(child: _buildBusContainer()),
            _buildBottomBar(selected, total),
          ],
        ),
      ),
    );
  }
 
  // ── Header ─────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color:        ColorsManager.seatContainerBg,
                borderRadius: BorderRadius.circular(21),
              ),
              child: const Icon(Icons.arrow_back,
                  color: Colors.white, size: 20),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  _routeLabel,
                  style: const TextStyle(
                    color:      Colors.white,
                    fontSize:   16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _subLabel,
                  style: const TextStyle(
                      color: ColorsManager.textMuted, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color:        ColorsManager.seatContainerBg,
              borderRadius: BorderRadius.circular(21),
            ),
            child: const Icon(Icons.info_outline,
                color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
 
  // ── Trip time info ─────────────────────────────────────────
  Widget _buildTripInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Departure
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _fmt(widget.trip.departureTime),
                style: const TextStyle(
                  color:      Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize:   22,
                ),
              ),
              Text(
                widget.trip.originStationName.isNotEmpty
                    ? widget.trip.originStationName
                    : widget.trip.originGovernorate,
                style: const TextStyle(
                    color: ColorsManager.textMuted, fontSize: 12),
              ),
            ],
          ),
 
          // Duration pill
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color:        const Color(0xFF1A2E4A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF1E3A52)),
            ),
            child: Text(
              widget.trip.durationFormatted,
              style: const TextStyle(
                  color: ColorsManager.accentCyan, fontSize: 12),
            ),
          ),
 
          // Arrival
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _fmt(widget.trip.arrivalTime),
                style: const TextStyle(
                  color:      Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize:   22,
                ),
              ),
              Text(
                widget.trip.destinationStationName.isNotEmpty
                    ? widget.trip.destinationStationName
                    : widget.trip.destinationGovernorate,
                style: const TextStyle(
                    color: ColorsManager.textMuted, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
 
  // ── Legend ─────────────────────────────────────────────────
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(SeatStatus.available, 'Available'),
        const SizedBox(width: 24),
        _legendItem(SeatStatus.selected,  'Selected'),
        const SizedBox(width: 24),
        _legendItem(SeatStatus.taken,     'Taken'),
      ],
    );
  }
 
  Widget _legendItem(SeatStatus status, String label) {
    return Row(
      children: [
        _seatCircle(status, size: 20, showLabel: false),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: status == SeatStatus.taken
                ? Colors.white38
                : Colors.white70,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
 
  // ── Bus container ──────────────────────────────────────────
  Widget _buildBusContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        decoration: BoxDecoration(
          color:        ColorsManager.surfaceDark,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
              color: ColorsManager.borderDim, width: 1.5),
          boxShadow: [
            BoxShadow(
              color:      ColorsManager.accentCyan.withOpacity(0.04),
              blurRadius: 30,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            // Bus icon row
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.directions_bus_outlined,
                      color: Colors.white38, size: 28),
                  Icon(Icons.navigation,
                      color: Colors.white38, size: 26),
                ],
              ),
            ),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 20),
 
            // Seat grid — scrollable if many rows
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Column headers A B C D
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: ['A', 'B', 'C', 'D']
                            .map((l) => SizedBox(
                                  width: 64,
                                  child: Center(
                                    child: Text(
                                      l,
                                      style: const TextStyle(
                                        color:    Colors.white38,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
 
                    // Seat rows
                    ...seats.map((row) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: row.map((seat) {
                              return GestureDetector(
                                onTap: () => _onSeatTap(seat),
                                child: _seatCircle(
                                  seat.status,
                                  label: seat.label,
                                ),
                              );
                            }).toList(),
                          ),
                        )),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
 
  Widget _seatCircle(
    SeatStatus status, {
    String label = '',
    double size  = 64,
    bool showLabel = true,
  }) {
    Color           bgColor;
    Color           borderColor;
    Color           textColor;
    List<BoxShadow> shadows = [];
 
    switch (status) {
      case SeatStatus.selected:
        bgColor     = ColorsManager.seatSelected;
        borderColor = ColorsManager.accentCyan;
        textColor   = Colors.white;
        shadows = [
          BoxShadow(
            color:       ColorsManager.seatSelected.withOpacity(0.6),
            blurRadius:  14,
            spreadRadius: 2,
          ),
        ];
        break;
      case SeatStatus.available:
        bgColor     = Colors.transparent;
        borderColor = ColorsManager.seatBorderAvail;
        textColor   = ColorsManager.accentCyan;
        break;
      case SeatStatus.taken:
        bgColor     = ColorsManager.seatContainerBg;
        borderColor = ColorsManager.seatBorderTaken;
        textColor   = Colors.white24;
        break;
    }
 
    return Container(
      width:  size,
      height: size,
      decoration: BoxDecoration(
        color:      bgColor,
        shape:      BoxShape.circle,
        border:     Border.all(color: borderColor, width: 1.5),
        boxShadow:  shadows,
      ),
      child: showLabel
          ? Center(
              child: Text(
                label,
                style: TextStyle(
                  color:      textColor,
                  fontWeight: FontWeight.bold,
                  fontSize:   12,
                ),
              ),
            )
          : null,
    );
  }
 
  // ── Bottom bar ─────────────────────────────────────────────
  Widget _buildBottomBar(List<Seat> selected, double total) {
    final seatLabels = selected.map((s) => s.label).join(', ');
 
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 24, vertical: 12),
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
                          color: Colors.white70, fontSize: 15),
                      children: [
                        TextSpan(
                          text: '${selected.length} Seats',
                          style: const TextStyle(
                            color:      Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    seatLabels.isEmpty
                        ? 'No seats selected'
                        : seatLabels,
                    style: const TextStyle(
                      color:      ColorsManager.accentCyan,
                      fontSize:   13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Total',
                      style: TextStyle(
                          color: Colors.white54, fontSize: 13)),
                  Text(
                    'EGP ${total.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color:      Colors.white,
                      fontSize:   22,
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
            width:  double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: selected.isEmpty ? null : () {
                // TODO: navigate to booking confirmation
                // Pass: trip, coachClass, selectedSeats, total
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:         Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)),
                elevation: 0,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: selected.isEmpty
                      ? LinearGradient(colors: [
                          ColorsManager.seatContainerBg,
                          ColorsManager.seatContainerBg,
                        ])
                      : const LinearGradient(
                          colors: [
                            ColorsManager.seatSelected,
                            ColorsManager.accentCyan,
                          ],
                          begin: Alignment.centerLeft,
                          end:   Alignment.centerRight,
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
                      fontSize:   17,
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