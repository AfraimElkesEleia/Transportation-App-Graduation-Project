import 'package:hive/hive.dart';
import 'package:transportation_app/features/search/domain/entities/recent_search_entity.dart';

part 'recent_search_model.g.dart';

@HiveType(typeId: 1)
class RecentSearchModel extends HiveObject implements RecentSearchEntity {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String fromDisplayName;

  @HiveField(2)
  @override
  final String toDisplayName;

  @HiveField(3)
  @override
  final String? fromGovernorate;

  @HiveField(4)
  @override
  final int? fromStationId;

  @HiveField(5)
  @override
  final String? toGovernorate;

  @HiveField(6)
  @override
  final int? toStationId;

  @HiveField(7)
  @override
  final String travelDate;

  @HiveField(8)
  @override
  final bool isRoundTrip;

  @HiveField(9)
  @override
  final String? returnDate;

  @HiveField(10)
  @override
  final int passengers;

  @HiveField(11)
  @override
  final DateTime createdAt;

  RecentSearchModel({
    required this.id,
    required this.fromDisplayName,
    required this.toDisplayName,
    this.fromGovernorate,
    this.fromStationId,
    this.toGovernorate,
    this.toStationId,
    required this.travelDate,
    required this.isRoundTrip,
    this.returnDate,
    required this.passengers,
    required this.createdAt,
  });

  factory RecentSearchModel.fromEntity(RecentSearchEntity entity) {
    return RecentSearchModel(
      id: entity.id,
      fromDisplayName: entity.fromDisplayName,
      toDisplayName: entity.toDisplayName,
      fromGovernorate: entity.fromGovernorate,
      fromStationId: entity.fromStationId,
      toGovernorate: entity.toGovernorate,
      toStationId: entity.toStationId,
      travelDate: entity.travelDate,
      isRoundTrip: entity.isRoundTrip,
      returnDate: entity.returnDate,
      passengers: entity.passengers,
      createdAt: entity.createdAt,
    );
  }

}
