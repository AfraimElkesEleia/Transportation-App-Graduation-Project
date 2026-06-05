import 'package:transportation_app/features/booking/domain/entities/cart_entity.dart';

class CartPassengerModel extends CartPassengerEntity {
  const CartPassengerModel({
    required super.name,
    required super.idNumber,
    required super.seatNumber,
  });

  factory CartPassengerModel.fromJson(Map<String, dynamic> json) {
    String readString(List<String> keys) {
      for (final key in keys) {
        final value = json[key];
        if (value is String && value.trim().isNotEmpty) {
          return value;
        }
      }
      return '';
    }

    return CartPassengerModel(
      name: readString(['name', 'passengerName']),
      idNumber: readString(['idNumber']),
      seatNumber: readString(['seatNumber']),
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
    super.agencyNameAr,
    required super.className,
    super.classNameAr,
    required super.origin,
    super.originAr,
    super.originGov,
    super.originGovAr,
    required super.destination,
    super.destinationAr,
    super.destinationGov,
    super.destinationGovAr,
    super.boardingTime,
    super.dropoffTime,
    required super.passengers,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    String readString(List<String> keys) {
      for (final key in keys) {
        final value = json[key];
        if (value is String && value.trim().isNotEmpty) {
          return value;
        }
      }
      return '';
    }

    return CartItemModel(
      bookingId: json['bookingId'] as int? ?? 0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      seatsBooked: json['seatsBooked'] as int? ?? 0,
      holdExpiresAt: json['holdExpiresAt'] != null
          ? DateTime.tryParse(json['holdExpiresAt'])
          : null,
      agencyName: json['agencyName'] as String? ?? '',
      agencyNameAr: json['agencyNameAr'] as String? ?? '',
      className: json['className'] as String? ?? '',
      classNameAr: json['classNameAr'] as String? ?? '',
      origin: readString(['originStationNameEn', 'originEn', 'origin']),
      originAr: readString(['originStationNameAr', 'originAr']),
      originGov: readString(['originGovEn', 'originGov']),
      originGovAr: readString(['originGovAr']),
      destination: readString([
        'destinationStationNameEn',
        'destinationEn',
        'destination',
      ]),
      destinationAr: readString(['destinationStationNameAr', 'destinationAr']),
      destinationGov: readString(['destinationGovEn', 'destinationGov']),
      destinationGovAr: readString(['destinationGovAr']),
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
  const CartResponseModel({required super.items, required super.grandTotal});

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    return CartResponseModel(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      grandTotal: (json['grandTotal'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
