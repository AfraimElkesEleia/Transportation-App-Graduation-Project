import 'package:transportation_app/features/booking/domain/entities/seat_map.dart';
class SeatModel extends SeatEntity {
  const SeatModel({
    required super.seatNumber,
    required super.status,
    super.holdExpiresAt,
  });

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    final statusStr = json['status'] as String? ?? 'Available';
    final status = switch (statusStr.toLowerCase()) {
      'pending' => SeatStatus.pending,
      'booked'  => SeatStatus.booked,
      _         => SeatStatus.available,
    };
    final hold = json['holdExpiresAt'] as String?;

    return SeatModel(
      seatNumber:    json['seatNumber'] as String,
      status:        status,
      holdExpiresAt: hold != null ? DateTime.tryParse(hold) : null,
    );
  }
}

class SeatClassMapModel extends SeatClassMap {
  const SeatClassMapModel({
    required super.coachClassId,
    required super.className,
    required super.totalSeats,
    required super.remainingSeats,
    required super.availableCount,
    required super.pendingCount,
    required super.bookedCount,
    required super.seats,
    super.layoutType,
    super.deckCount,
  });

  factory SeatClassMapModel.fromJson(Map<String, dynamic> json) {
    final seats = (json['seats'] as List<dynamic>? ?? [])
        .map((s) => SeatModel.fromJson(s as Map<String, dynamic>))
        .toList();

    return SeatClassMapModel(
      coachClassId:   json['coachClassId']   as int,
      className:      json['className']      as String? ?? '',
      totalSeats:     json['totalSeats']     as int? ?? 0,
      remainingSeats: json['remainingSeats'] as int? ?? 0,
      layoutType:     json['layoutType']     as String?,
      deckCount:      json['deckCount']      as int? ?? 1,
      availableCount: json['availableCount'] as int? ?? 0,
      pendingCount:   json['pendingCount']   as int? ?? 0,
      bookedCount:    json['bookedCount']    as int? ?? 0,
      seats:          seats,
    );
  }
}

class SeatMapModel extends SeatMapEntity {
  const SeatMapModel({
    required super.occurrenceId,
    required super.classes,
  });

  factory SeatMapModel.fromJson(Map<String, dynamic> json) {
    final classes = (json['classes'] as List<dynamic>? ?? [])
        .map((c) => SeatClassMapModel.fromJson(c as Map<String, dynamic>))
        .toList();

    return SeatMapModel(
      occurrenceId: json['occurrenceId'] as int,
      classes:      classes,
    );
  }
}