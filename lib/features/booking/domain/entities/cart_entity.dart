import 'package:equatable/equatable.dart';

class CartPassengerEntity extends Equatable {
  final String name;
  final String idNumber;
  final String seatNumber;

  const CartPassengerEntity({
    required this.name,
    required this.idNumber,
    required this.seatNumber,
  });

  @override
  List<Object?> get props => [name, idNumber, seatNumber];
}

class CartItemEntity extends Equatable {
  final int bookingId;
  final double totalPrice;
  final int seatsBooked;
  final DateTime? holdExpiresAt;
  final String agencyName;
  final String agencyNameAr;
  final String className;
  final String classNameAr;
  final String origin;
  final String originAr;
  final String originGov;
  final String originGovAr;
  final String destination;
  final String destinationAr;
  final String destinationGov;
  final String destinationGovAr;
  final DateTime? boardingTime;
  final DateTime? dropoffTime;
  final List<CartPassengerEntity> passengers;

  const CartItemEntity({
    required this.bookingId,
    required this.totalPrice,
    required this.seatsBooked,
    this.holdExpiresAt,
    required this.agencyName,
    this.agencyNameAr = '',
    required this.className,
    this.classNameAr = '',
    required this.origin,
    this.originAr = '',
    this.originGov = '',
    this.originGovAr = '',
    required this.destination,
    this.destinationAr = '',
    this.destinationGov = '',
    this.destinationGovAr = '',
    this.boardingTime,
    this.dropoffTime,
    required this.passengers,
  });

  @override
  List<Object?> get props => [bookingId];
}

class CartEntity extends Equatable {
  final List<CartItemEntity> items;
  final double grandTotal;

  const CartEntity({required this.items, required this.grandTotal});

  @override
  List<Object?> get props => [items, grandTotal];
}
