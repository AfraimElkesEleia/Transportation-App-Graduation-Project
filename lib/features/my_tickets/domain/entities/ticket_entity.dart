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

  static const Duration activeBeforeBoardingWindow = Duration(hours: 5);
  static const Duration boardingNowWindow = Duration(hours: 1);

  String get _normalizedStatus => status.trim().toLowerCase();
  String get _normalizedRefundStatus => refundStatus?.trim().toLowerCase() ?? '';

  bool get isConfirmed => _normalizedStatus == 'confirmed';
  bool get isCompleted => _normalizedStatus == 'completed';
  bool get isCancelled => _normalizedStatus == 'cancelled';
  bool get hasAcceptedRefund =>
      _normalizedRefundStatus == 'accepted' ||
      _normalizedRefundStatus == 'approved';

  bool get isHiddenFromTicketTabs => isCancelled && !hasAcceptedRefund;

  bool isUpcomingTicket(DateTime now) {
    if (isHiddenFromTicketTabs || hasAcceptedRefund || !isConfirmed) {
      return false;
    }
    return now.isBefore(boardingTime.subtract(activeBeforeBoardingWindow));
  }

  bool isActiveTicket(DateTime now) {
    if (isHiddenFromTicketTabs || hasAcceptedRefund || !isConfirmed) {
      return false;
    }
    return !now.isBefore(boardingTime.subtract(activeBeforeBoardingWindow));
  }

  bool isPastTicket(DateTime now) {
    if (isHiddenFromTicketTabs) return false;
    if (hasAcceptedRefund) return true;
    return isCompleted && now.isAfter(boardingTime.add(boardingNowWindow));
  }

  bool isBoardingNow(DateTime now) {
    if (!isActiveTicket(now)) return false;
    return !now.isBefore(boardingTime) &&
        !now.isAfter(boardingTime.add(boardingNowWindow));
  }

  bool get isUpcoming => isUpcomingTicket(DateTime.now());
  bool get isPast => isPastTicket(DateTime.now());
  bool get isActive => isActiveTicket(DateTime.now());

  bool get isActiveNow {
    final now = DateTime.now();
    return isActiveTicket(now);
  }

  /// Returns true when a refund has already been requested (status == 'Requested').
  bool get isRefundRequested => refundStatus == 'Requested';

  @override
  List<Object?> get props => [bookingId];
}
