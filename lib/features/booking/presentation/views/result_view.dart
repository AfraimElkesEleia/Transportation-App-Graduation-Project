import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/utils/error_localizer.dart';
import 'package:transportation_app/features/booking/domain/entities/seat_map.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_state.dart';
import 'package:transportation_app/features/booking/presentation/views/train_passenger_count_screen.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/seat_app_bar.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/seat_bottom_bar.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/seat_grid.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/seat_legend.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/seat_map_error_view.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/trip_times_row.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';

class SeatSelectionScreen extends StatefulWidget {
  final TripResultEntity trip;
  final CoachClassEntity coachClass;

  const SeatSelectionScreen({
    super.key,
    required this.trip,
    required this.coachClass,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final Set<String> _selectedSeats = {};

  /// Detects if the trip is a train (no seat map, pick count only).
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
        _selectedSeats.add(seatNumber);
      }
    });
  }

  void _proceed() {
    final seats = _selectedSeats.toList();
    if (seats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseSelectSeat)),
      );
      return;
    }
    Navigator.pushNamed(
      context,
      AppRoutes.passengerFormScreen,
      arguments: {
        'trip': widget.trip,
        'coachClass': widget.coachClass,
        'seats': seats,
        'isTrain': false,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isTrain) {
      return TrainPassengerCountScreen(
        trip: widget.trip,
        coachClass: widget.coachClass,
        onProceed: (count) {
          Navigator.pushNamed(
            context,
            AppRoutes.passengerFormScreen,
            arguments: {
              'trip': widget.trip,
              'coachClass': widget.coachClass,
              'seats': List.generate(count, (_) => ''),
              'isTrain': true,
            },
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: ColorsManager.seatBg,
      body: SafeArea(
        child: BlocConsumer<SeatMapCubit, SeatMapState>(
          listener: _onStateChange,
          builder: (context, state) {
            if (state is SeatMapLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: ColorsManager.accentCyan,
                ),
              );
            }

            if (state is SeatMapError) {
              return SeatMapErrorView(
                message: ErrorLocalizer.localize(context, state.message),
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
      ),
    );
  }

  /// Handle cart success / error from BlocConsumer listener.
  void _onStateChange(BuildContext context, SeatMapState state) {
    if (state is CartSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to cart successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.popUntil(
        context,
        (r) => r.settings.name == AppRoutes.homeScreen,
      );
    }
    if (state is CartError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ErrorLocalizer.localize(context, state.message)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// The full bus seat layout — composes all extracted widgets.
  Widget _buildBusSeatMap(SeatClassMap classMap) {
    final total = _selectedSeats.length * widget.coachClass.price;

    return Column(
      children: [
        SeatAppBar(trip: widget.trip, coachClass: widget.coachClass),
        const SizedBox(height: 8),

        TripTimesRow(trip: widget.trip),
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
