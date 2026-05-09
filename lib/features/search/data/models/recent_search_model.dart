import 'package:hive/hive.dart';

part 'recent_search_model.g.dart';

@HiveType(typeId: 1)
class RecentSearchModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fromDisplayName;

  @HiveField(2)
  final String toDisplayName;

  @HiveField(3)
  final String? fromGovernorate;

  @HiveField(4)
  final int? fromStationId;

  @HiveField(5)
  final String? toGovernorate;

  @HiveField(6)
  final int? toStationId;

  @HiveField(7)
  final String travelDate;

  @HiveField(8)
  final bool isRoundTrip;

  @HiveField(9)
  final String? returnDate;

  @HiveField(10)
  final int passengers;

  @HiveField(11)
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
}
