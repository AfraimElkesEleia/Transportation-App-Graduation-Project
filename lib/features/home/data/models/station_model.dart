
import 'package:transportation_app/features/home/domain/entities/station_entity.dart';
import 'package:transportation_app/features/home/domain/entities/station_group_entity.dart';

class StationModel extends StationEntity {
  const StationModel({
    required super.id,
    required super.arabicName,
    required super.englishName,
    required super.slug,
    required super.city,
  });

  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      id:          json['id']          as int,
      arabicName:  json['arabicName']  as String? ?? '',
      englishName: json['englishName'] as String? ?? '',
      slug:        json['slug']        as String? ?? '',
      city:        json['city']        as String? ?? '',
    );
  }
}

class StationGroupModel extends StationGroupEntity {
  const StationGroupModel({
    required super.governorate,
    required super.stations,
  });

  factory StationGroupModel.fromJson(Map<String, dynamic> json) {
    final stationsList = (json['stations'] as List<dynamic>? ?? [])
        .map((s) => StationModel.fromJson(s as Map<String, dynamic>))
        .toList();

    return StationGroupModel(
      governorate: json['governorate'] as String? ?? '',
      stations:    stationsList,
    );
  }
}