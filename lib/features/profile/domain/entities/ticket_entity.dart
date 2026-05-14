import 'package:equatable/equatable.dart';

class TicketPassengerEntity extends Equatable {
  final int passengerId;
  final String name;
  final String idNumber;
  final String seatNumber;

  const TicketPassengerEntity({
    required this.passengerId,
    required this.name,
    required this.idNumber,
    required this.seatNumber,
  });

  @override
  List<Object?> get props => [passengerId, name, idNumber, seatNumber];
}

class TicketEntity extends Equatable {
  final int bookingId;
  final int userId;
  final String status;
  final String paymentStatus;
  final double totalPrice;
  final int seatsBooked;
  final DateTime bookingDate;
  final String agencyName;
  final String className;
  final String originGovernorate;
  final String originStation;
  final String destinationGovernorate;
  final String destinationStation;
  final DateTime boardingTime;
  final DateTime dropoffTime;
  final bool isMarketplacePurchase;
  final bool isOfferedForResale;
  final int? marketplaceListingId;
  final List<TicketPassengerEntity> passengers;

  const TicketEntity({
    required this.bookingId,
    required this.userId,
    required this.status,
    required this.paymentStatus,
    required this.totalPrice,
    required this.seatsBooked,
    required this.bookingDate,
    required this.agencyName,
    required this.className,
    required this.originGovernorate,
    required this.originStation,
    required this.destinationGovernorate,
    required this.destinationStation,
    required this.boardingTime,
    required this.dropoffTime,
    required this.isMarketplacePurchase,
    this.isOfferedForResale = false,
    this.marketplaceListingId,
    required this.passengers,
  });

  bool get isUpcoming =>
      boardingTime.isAfter(DateTime.now()) && status == 'Confirmed';
  bool get isPast =>
      dropoffTime.isBefore(DateTime.now()) && status == 'Completed';
  bool get isActive => !isPast && status == 'Confirmed';

  bool get isActiveNow {
    final now = DateTime.now();
    final diff = boardingTime.difference(now);
    return diff.inSeconds >= 0 && diff.inHours < 5 && status == 'Confirmed';
  }

  @override
  List<Object?> get props => [bookingId];
}
