import 'package:transportation_app/features/search/domain/entities/route_stop_entity.dart';

class RouteStopsModel extends RouteStopEntity {
  const RouteStopsModel({
    required super.stationName,
    super.arabicName,
    super.governorateAr,
    required super.arrivalTime,
    required super.departureTime,
    required super.stopSequence,
  });

  factory RouteStopsModel.fromJson(Map<String, dynamic> json) {
    return RouteStopsModel(
      stationName: json['stationName'] as String? ?? '',
      arabicName: json['arabicName'] as String?,
      governorateAr: json['governorateAr'] as String?,
      arrivalTime: json['arrivalTime'] as String? ?? '',
      departureTime: json['departureTime'] as String? ?? '',
      stopSequence: json['stopSequence'] as int,
    );
  }
}
