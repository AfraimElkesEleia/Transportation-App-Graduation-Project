import 'package:equatable/equatable.dart';
import 'package:transportation_app/features/search/data/model/route_stops_model.dart';
import 'package:transportation_app/features/search/domain/entities/floor_group.dart';
import 'coach_class_entity.dart';
import 'package:intl/intl.dart';

class TripResultEntity extends Equatable {
  final int tripOccurrenceId;
  final int tripId;
  final String agencyName;
  final String? agencyNameAr;
  final DateTime departureTime;
  final DateTime? arrivalTime;
  final int? totalDurationMinutes;
  final int originStationId;
  final String originStationName;
  final String? originStationNameAr;
  final String originGovernorate;
  final String? originGovernorateAr;
  final int destinationStationId;
  final String destinationStationName;
  final String? destinationStationNameAr;
  final String destinationGovernorate;
  final String? destinationGovernorateAr;
  final List<CoachClassEntity> availableClasses;
  final List<RouteStopsModel>? routeStops;

  const TripResultEntity({
    required this.tripOccurrenceId,
    required this.tripId,
    required this.agencyName,
    this.agencyNameAr,
    required this.departureTime,
    required this.arrivalTime,
    required this.totalDurationMinutes,
    required this.originStationId,
    required this.originStationName,
    this.originStationNameAr,
    required this.originGovernorate,
    this.originGovernorateAr,
    required this.destinationStationId,
    required this.destinationStationName,
    this.destinationStationNameAr,
    required this.destinationGovernorate,
    this.destinationGovernorateAr,
    required this.availableClasses,
    this.routeStops,
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

  List<RouteStopsModel> get safeRouteStops => routeStops ?? const [];
  List<FloorGroup> get floorGroups {
    final Map<int?, List<CoachClassEntity>> bucket = {};

    for (final cls in availableClasses) {
      bucket.putIfAbsent(cls.floorNumber, () => []).add(cls);
    }

    final groups = bucket.entries.map((e) {
      // All classes in same floor share same groupName — take from first
      final name = e.value.first.groupName;
      return FloorGroup(
        groupName: name, // ← "Horus - Prestige"
        floorNumber: e.key,
        classes: e.value,
      );
    }).toList();

    groups.sort((a, b) {
      if (a.floorNumber == null) return 1;
      if (b.floorNumber == null) return -1;
      return a.floorNumber!.compareTo(b.floorNumber!);
    });

    return groups;
  }

  bool get hasMultipleFloors =>
      floorGroups.where((g) => g.floorNumber != null).length > 1;
  bool get hasRouteStops => routeStops?.isNotEmpty == true;
  @override
  List<Object> get props => [tripOccurrenceId];
}
