import 'package:equatable/equatable.dart';

enum SeatStatus { available, pending, booked }

class SeatEntity extends Equatable {
  final String     seatNumber;
  final SeatStatus status;
  final DateTime?  holdExpiresAt;

  const SeatEntity({
    required this.seatNumber,
    required this.status,
    this.holdExpiresAt,
  });

  bool get isSelectable => status == SeatStatus.available;

  @override
  List<Object?> get props => [seatNumber, status];
}

class SeatClassMap extends Equatable {
  final int          coachClassId;
  final String       className;
  final int          totalSeats;
  final int          remainingSeats;
  final String?      layoutType;    
  final int          deckCount;
  final int          availableCount;
  final int          pendingCount;
  final int          bookedCount;
  final List<SeatEntity> seats;

  const SeatClassMap({
    required this.coachClassId,
    required this.className,
    required this.totalSeats,
    required this.remainingSeats,
    required this.availableCount,
    required this.pendingCount,
    required this.bookedCount,
    required this.seats,
    this.layoutType,
    this.deckCount = 1,
  });

  int get columnsCount {
    if (layoutType == null) return 4;
    final parts = layoutType!.split('x');
    if (parts.length != 2) return 4;
    final left  = int.tryParse(parts[0]) ?? 2;
    final right = int.tryParse(parts[1]) ?? 2;
    return left + right + 1;   
  }

  List<SeatEntity> get availableSeats =>
      seats.where((s) => s.isSelectable).toList();

  @override
  List<Object?> get props => [coachClassId];
}

class SeatMapEntity extends Equatable {
  final int               occurrenceId;
  final List<SeatClassMap> classes;

  const SeatMapEntity({
    required this.occurrenceId,
    required this.classes,
  });

  SeatClassMap? classById(int id) {
    try { return classes.firstWhere((c) => c.coachClassId == id); }
    catch (_) { return null; }
  }

  @override
  List<Object?> get props => [occurrenceId];
}