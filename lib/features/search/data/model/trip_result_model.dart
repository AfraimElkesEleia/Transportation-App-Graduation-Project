import 'package:transportation_app/features/search/data/model/coach_class_model.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';

class TripResultModel extends TripResultEntity {
  const TripResultModel({
    required super.tripOccurrenceId,
    required super.tripId,
    required super.agencyName,
    required super.departureTime,
    required super.arrivalTime,
    required super.totalDurationMinutes,
    required super.originStationId,
    required super.originStationName,
    required super.originGovernorate,
    required super.destinationStationId,
    required super.destinationStationName,
    required super.destinationGovernorate,
    required super.availableClasses,
  });

  // ── TripResultModel.fromJson ───────────────────────────────────
  factory TripResultModel.fromJson(Map<String, dynamic> json) {
    final classes = (json['availableClasses'] as List<dynamic>? ?? [])
        .map((c) => CoachClassModel.fromJson(c as Map<String, dynamic>))
        .toList();

    return TripResultModel(
      tripOccurrenceId: json['tripOccurrenceId'] as int,
      tripId: json['tripId'] as int,
      agencyName: json['agencyName'] as String? ?? '',
      departureTime: DateTime.parse(json['departureTime'] as String),
      arrivalTime: json['arrivalTime'] != null
          ? DateTime.parse(json['arrivalTime'] as String)
          : null,
      totalDurationMinutes: json['totalDurationMinutes'] as int?,
      originStationId: json['originStationId'] as int,
      originStationName: json['originStationName'] as String? ?? '',
      originGovernorate: json['originGovernorate'] as String? ?? '',
      destinationStationId: json['destinationStationId'] as int,
      destinationStationName: json['destinationStationName'] as String? ?? '',
      destinationGovernorate: json['destinationGovernorate'] as String? ?? '',
      availableClasses: classes,
    );
  }
}
