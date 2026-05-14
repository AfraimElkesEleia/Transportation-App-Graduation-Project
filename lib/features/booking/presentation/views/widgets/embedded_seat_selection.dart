import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/booking/domain/entities/seat_map.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_state.dart';
import 'package:transportation_app/features/booking/presentation/views/train_passenger_count_screen.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/seat_bottom_bar.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/seat_grid.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/seat_legend.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/seat_map_error_view.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/trip_times_row.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';

class EmbeddedSeatSelection extends StatefulWidget {
  final TripResultEntity trip;
  final CoachClassEntity coachClass;
  final ValueChanged<List<String>> onProceed;
  final int? enforcedSeatCount;
  final VoidCallback onCancel;
  final List<String> initialSeats;

  const EmbeddedSeatSelection({
    super.key,
    required this.trip,
    required this.coachClass,
    required this.onProceed,
    this.enforcedSeatCount,
    required this.onCancel,
    this.initialSeats = const [],
  });

  @override
  State<EmbeddedSeatSelection> createState() => _EmbeddedSeatSelectionState();
}

class _EmbeddedSeatSelectionState extends State<EmbeddedSeatSelection> {
  late Set<String> _selectedSeats;

  @override
  void initState() {
    super.initState();
    _selectedSeats = Set.from(widget.initialSeats);
  }

  bool get _isTrain {
    final name = widget.trip.agencyName.toLowerCase();
    return name.contains('rail') ||
        name.contains('enr') ||
        name.contains('train') ||
        name.contains('talgo');
  }

  void _onSeatToggle(String seatNumber) {
    setState(() {
      if (_selectedSeats.contains(seatNumber)) {
        _selectedSeats.remove(seatNumber);
      } else {
        if (widget.enforcedSeatCount != null &&
            _selectedSeats.length >= widget.enforcedSeatCount!) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'You can only select exactly ${widget.enforcedSeatCount} seats for Leg 2.',
              ),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        _selectedSeats.add(seatNumber);
      }
    });
  }

  void _proceed() {
    if (_selectedSeats.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a seat')));
      return;
    }
    if (widget.enforcedSeatCount != null &&
        _selectedSeats.length != widget.enforcedSeatCount!) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please pick exactly ${widget.enforcedSeatCount} seats',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onProceed(_selectedSeats.toList());
  }

  @override
  Widget build(BuildContext context) {
    if (_isTrain) {
      return TrainPassengerCountScreen(
        trip: widget.trip,
        coachClass: widget.coachClass,
        initialCount: widget.initialSeats.isNotEmpty
            ? widget.initialSeats.length
            : 1,
        onProceed: (count) {
          if (widget.enforcedSeatCount != null &&
              count != widget.enforcedSeatCount!) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Please select exactly ${widget.enforcedSeatCount} passengers',
                ),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          widget.onProceed(List.generate(count, (_) => ''));
        },
      );
    }

    return Container(
      color: ColorsManager.seatBg,
      child: BlocBuilder<SeatMapCubit, SeatMapState>(
        builder: (context, state) {
          if (state is SeatMapLoading) {
            return const Center(
              child: CircularProgressIndicator(color: ColorsManager.accentCyan),
            );
          }

          if (state is SeatMapError) {
            return SeatMapErrorView(
              message: state.message,
              onRetry: () => context.read<SeatMapCubit>().loadSeatMap(
                widget.trip.tripOccurrenceId,
                widget.coachClass.coachClassId,
              ),
            );
          }

          if (state is SeatMapLoaded) {
            return _buildBusSeatMap(state.classMap);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBusSeatMap(SeatClassMap classMap) {
    final total = _selectedSeats.length * widget.coachClass.price;

    return Column(
      children: [
        // App bar substitute
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: widget.onCancel,
            ),
            const Text(
              'Select Seats',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 48), // balance
          ],
        ),

        TripTimesRow(trip: widget.trip),
        const SizedBox(height: 8),

        if (widget.enforcedSeatCount != null)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorsManager.surfaceChip,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Required: ${widget.enforcedSeatCount} seats. Selected: ${_selectedSeats.length}',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),

        const SizedBox(height: 16),
        const SeatLegend(),
        const SizedBox(height: 16),

        Expanded(
          child: SeatGrid(
            classMap: classMap,
            selectedSeats: _selectedSeats,
            onSeatToggle: _onSeatToggle,
            floorNumber: widget.coachClass.floorNumber,
          ),
        ),

        SeatBottomBar(
          selectedSeats: _selectedSeats,
          pricePerSeat: widget.coachClass.price,
          total: total,
          onProceed: _proceed,
        ),
      ],
    );
  }
}
