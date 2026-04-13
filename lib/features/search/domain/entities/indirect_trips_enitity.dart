import 'package:equatable/equatable.dart';
import 'trip_result_entity.dart';

class IndirectTripEntity extends Equatable {
  final int                    totalDurationMinutes;
  final int                    layoverDurationMinutes;
  final double                 totalStartingPrice;
  final List<TripResultEntity> legs;

  const IndirectTripEntity({
    required this.totalDurationMinutes,
    required this.layoverDurationMinutes,
    required this.totalStartingPrice,
    required this.legs,
  });

  TripResultEntity get firstLeg  => legs.first;
  TripResultEntity get secondLeg => legs.last;

  String get totalDurationFormatted {
    final h = totalDurationMinutes ~/ 60;
    final m = totalDurationMinutes % 60;
    return '${h}h ${m}m';
  }

  String get layoverFormatted {
    final h = layoverDurationMinutes ~/ 60;
    final m = layoverDurationMinutes % 60;
    return h > 0 ? '${h}h ${m}m layover' : '${m}m layover';
  }

  @override
  List<Object> get props => [totalDurationMinutes, totalStartingPrice];
}