import 'package:equatable/equatable.dart';
import 'coach_class_entity.dart';
import 'package:intl/intl.dart';
class TripResultEntity extends Equatable {
  final int tripOccurrenceId;
  final int tripId;
  final String agencyName;
  final DateTime departureTime;
  final DateTime? arrivalTime;
  final int? totalDurationMinutes;
  final int originStationId;
  final String originStationName;
  final String originGovernorate;
  final int destinationStationId;
  final String destinationStationName;
  final String destinationGovernorate;
  final List<CoachClassEntity> availableClasses;

  const TripResultEntity({
    required this.tripOccurrenceId,
    required this.tripId,
    required this.agencyName,
    required this.departureTime,
    required this.arrivalTime,
    required this.totalDurationMinutes,
    required this.originStationId,
    required this.originStationName,
    required this.originGovernorate,
    required this.destinationStationId,
    required this.destinationStationName,
    required this.destinationGovernorate,
    required this.availableClasses,
  });
  String get departureTimeFormatted =>
      DateFormat('hh:mm a').format(departureTime);

  String get arrivalTimeFormatted {
    if (arrivalTime == null) return '--:--'; // Safety fallback
    return DateFormat('hh:mm a').format(arrivalTime!);
  }

  double get lowestPrice => availableClasses.isEmpty
      ? 0
      : availableClasses.map((c) => c.price).reduce((a, b) => a < b ? a : b);

  String get durationFormatted {
    if (totalDurationMinutes == null) return '--';
    final minutes = totalDurationMinutes!;
    final h = minutes ~/ 60;
    final m = minutes % 60;

    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  @override
  List<Object> get props => [tripOccurrenceId];
}
