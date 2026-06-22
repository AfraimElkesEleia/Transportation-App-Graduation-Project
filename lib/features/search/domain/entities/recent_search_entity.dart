class RecentSearchEntity {
  final String id;
  final String fromDisplayName;
  final String toDisplayName;
  final String? fromGovernorate;
  final int? fromStationId;
  final String? toGovernorate;
  final int? toStationId;
  final String travelDate;
  final bool isRoundTrip;
  final String? returnDate;
  final int passengers;
  final DateTime createdAt;

  const RecentSearchEntity({
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
