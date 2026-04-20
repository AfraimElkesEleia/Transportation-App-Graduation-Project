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
  final String className;
  final String origin;
  final String destination;
  final DateTime? boardingTime;
  final DateTime? dropoffTime;
  final List<CartPassengerEntity> passengers;

  const CartItemEntity({
    required this.bookingId,
    required this.totalPrice,
    required this.seatsBooked,
    this.holdExpiresAt,
    required this.agencyName,
    required this.className,
    required this.origin,
    required this.destination,
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

  const CartEntity({
    required this.items,
    required this.grandTotal,
  });

  @override
  List<Object?> get props => [items, grandTotal];
}
