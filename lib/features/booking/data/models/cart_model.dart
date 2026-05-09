import 'package:transportation_app/features/booking/domain/entities/cart_entity.dart';

class CartPassengerModel extends CartPassengerEntity {
  const CartPassengerModel({
    required super.name,
    required super.idNumber,
    required super.seatNumber,
  });

  factory CartPassengerModel.fromJson(Map<String, dynamic> json) {
    return CartPassengerModel(
      name: json['name'] as String? ?? 'Unknown',
      idNumber: json['idNumber'] as String? ?? '',
      seatNumber: json['seatNumber'] as String? ?? '',
    );
  }
}

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.bookingId,
    required super.totalPrice,
    required super.seatsBooked,
    super.holdExpiresAt,
    required super.agencyName,
    required super.className,
    required super.origin,
    super.originGov,
    required super.destination,
    super.destinationGov,
    super.boardingTime,
    super.dropoffTime,
    required super.passengers,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      bookingId: json['bookingId'] as int? ?? 0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      seatsBooked: json['seatsBooked'] as int? ?? 0,
      holdExpiresAt: json['holdExpiresAt'] != null
          ? DateTime.tryParse(json['holdExpiresAt'])
          : null,
      agencyName: json['agencyName'] as String? ?? '',
      className: json['className'] as String? ?? '',
      origin: json['origin'] as String? ?? '',
      originGov: json['originGov'] as String? ?? '',
      destination: json['destination'] as String? ?? '',
      destinationGov: json['destinationGov'] as String? ?? '',
      boardingTime: json['boardingTime'] != null
          ? DateTime.tryParse(json['boardingTime'])
          : null,
      dropoffTime: json['dropoffTime'] != null
          ? DateTime.tryParse(json['dropoffTime'])
          : null,
      passengers: (json['passengers'] as List<dynamic>? ?? [])
          .map((e) => CartPassengerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CartResponseModel extends CartEntity {
  const CartResponseModel({
    required super.items,
    required super.grandTotal,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    return CartResponseModel(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      grandTotal: (json['grandTotal'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
