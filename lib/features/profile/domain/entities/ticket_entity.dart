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
  final String? agencyNameAr;
  final String className;
  final String? classNameAr;
  final String originGovernorate;
  final String? originGovernorateAr;
  final String originStation;
  final String? originStationNameAr;
  final String destinationGovernorate;
  final String? destinationGovernorateAr;
  final String destinationStation;
  final String? destinationStationNameAr;
  final DateTime boardingTime;
  final DateTime dropoffTime;
  final bool isMarketplacePurchase;
  final bool isOfferedForResale;
  final int? marketplaceListingId;
  final List<TicketPassengerEntity> passengers;
  final String? refundStatus;

  const TicketEntity({
    required this.bookingId,
    required this.userId,
    required this.status,
    required this.paymentStatus,
    required this.totalPrice,
    required this.seatsBooked,
    required this.bookingDate,
    required this.agencyName,
    this.agencyNameAr,
    required this.className,
    this.classNameAr,
    required this.originGovernorate,
    this.originGovernorateAr,
    required this.originStation,
    this.originStationNameAr,
    required this.destinationGovernorate,
    this.destinationGovernorateAr,
    required this.destinationStation,
    this.destinationStationNameAr,
    required this.boardingTime,
    required this.dropoffTime,
    required this.isMarketplacePurchase,
    this.isOfferedForResale = false,
    this.marketplaceListingId,
    required this.passengers,
    this.refundStatus,
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

  /// Returns true when a refund has already been requested (status == 'Requested').
  bool get isRefundRequested => refundStatus == 'Requested';

  @override
  List<Object?> get props => [bookingId];
}
