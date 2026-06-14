import 'package:transportation_app/features/search/data/model/coach_class_model.dart';
import 'package:transportation_app/features/search/data/model/route_stops_model.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';

class TripResultModel extends TripResultEntity {
  const TripResultModel({
    required super.tripOccurrenceId,
    required super.tripId,
    required super.agencyName,
    super.agencyNameAr,
    required super.departureTime,
    required super.arrivalTime,
    required super.totalDurationMinutes,
    required super.originStationId,
    required super.originStationName,
    super.originStationNameAr,
    required super.originGovernorate,
    super.originGovernorateAr,
    required super.destinationStationId,
    required super.destinationStationName,
    super.destinationStationNameAr,
    required super.destinationGovernorate,
    super.destinationGovernorateAr,
    required super.availableClasses,
    required super.routeStops,
  });

  // ── TripResultModel.fromJson ───────────────────────────────────
  factory TripResultModel.fromJson(Map<String, dynamic> json) {
    final classes = (json['availableClasses'] as List<dynamic>? ?? [])
        .map((c) => CoachClassModel.fromJson(c as Map<String, dynamic>))
        .toList();
    final stopsJson = json['routeStops'];
    final List<RouteStopsModel> stops;
    if (stopsJson == null || stopsJson is! List) {
      stops = const [];
    } else {
      stops = stopsJson
          .map((s) => RouteStopsModel.fromJson(s as Map<String, dynamic>))
          .toList();
    }
    return TripResultModel(
      tripOccurrenceId: json['tripOccurrenceId'] as int,
      tripId: json['tripId'] as int,
      agencyName: json['agencyName'] as String? ?? '',
      agencyNameAr: json['agencyNameAr'] as String?,
      // UI departure/arrival fields intentionally use passenger-segment
      // timetable values from the API, not occurrence-level trip times.
      departureTime: DateTime.parse(json['boardingTime'] as String),
      arrivalTime: json['dropoffTime'] != null
          ? DateTime.parse(json['dropoffTime'] as String)
          : null,
      totalDurationMinutes: json['totalDurationMinutes'] as int?,
      originStationId: json['originStationId'] as int,
      originStationName: json['originStationName'] as String? ?? '',
      originStationNameAr: json['originStationNameAr'] as String?,
      originGovernorate: json['originGovernorate'] as String? ?? '',
      originGovernorateAr: json['originGovernorateAr'] as String?,
      destinationStationId: json['destinationStationId'] as int,
      destinationStationName: json['destinationStationName'] as String? ?? '',
      destinationStationNameAr: json['destinationStationNameAr'] as String?,
      destinationGovernorate: json['destinationGovernorate'] as String? ?? '',
      destinationGovernorateAr: json['destinationGovernorateAr'] as String?,
      availableClasses: classes,
      routeStops: stops,
    );
  }
}
