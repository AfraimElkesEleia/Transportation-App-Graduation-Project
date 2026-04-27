import 'package:equatable/equatable.dart';

class TicketPassengerEntity extends Equatable {
  final String name;
  final String idNumber;
  final String seatNumber;

  const TicketPassengerEntity({
    required this.name,
    required this.idNumber,
    required this.seatNumber,
  });

  @override
  List<Object?> get props => [name, idNumber, seatNumber];
}

class TicketEntity extends Equatable {
  final int bookingId;
  final String status;
  final String paymentStatus;
  final double totalPrice;
  final int seatsBooked;
  final DateTime bookingDate;
  final String agencyName;
  final String className;
  final String originStation;
  final String destinationStation;
  final DateTime boardingTime;
  final DateTime dropoffTime;
  final List<TicketPassengerEntity> passengers;

  const TicketEntity({
    required this.bookingId,
    required this.status,
    required this.paymentStatus,
    required this.totalPrice,
    required this.seatsBooked,
    required this.bookingDate,
    required this.agencyName,
    required this.className,
    required this.originStation,
    required this.destinationStation,
    required this.boardingTime,
    required this.dropoffTime,
    required this.passengers,
  });

  bool get isUpcoming => boardingTime.isAfter(DateTime.now());
  bool get isPast => dropoffTime.isBefore(DateTime.now());
  bool get isActive => !isPast && status == 'Confirmed';

  @override
  List<Object?> get props => [bookingId];
}
