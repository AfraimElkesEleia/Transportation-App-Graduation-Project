
import 'package:transportation_app/features/search/data/model/trip_result_model.dart';
import 'package:transportation_app/features/search/domain/entities/indirect_trips_enitity.dart';

class IndirectTripModel extends IndirectTripEntity {
  const IndirectTripModel({
    required super.totalDurationMinutes,
    required super.layoverDurationMinutes,
    required super.totalStartingPrice,
    required super.legs,
  });

  factory IndirectTripModel.fromJson(Map<String, dynamic> json) {
    final legs = (json['legs'] as List<dynamic>? ?? [])
        .map((l) => TripResultModel.fromJson(l as Map<String, dynamic>))
        .toList();

    return IndirectTripModel(
      totalDurationMinutes:   json['totalDurationMinutes']   as int,
      layoverDurationMinutes: json['layoverDurationMinutes'] as int,
      totalStartingPrice:     (json['totalStartingPrice']    as num).toDouble(),
      legs:                   legs,
    );
  }
}