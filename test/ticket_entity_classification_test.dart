import 'package:flutter_test/flutter_test.dart';
import 'package:transportation_app/features/my_tickets/domain/entities/ticket_entity.dart';

void main() {
  group('TicketEntity tab classification', () {
    final now = DateTime(2026, 6, 14, 12);

    test('confirmed ticket boarding in more than 5 hours is upcoming only', () {
      final ticket = _ticket(
        status: 'Confirmed',
        boardingTime: now.add(const Duration(hours: 6)),
      );

      expect(ticket.isUpcomingTicket(now), isTrue);
      expect(ticket.isActiveTicket(now), isFalse);
      expect(ticket.isPastTicket(now), isFalse);
    });

    test('confirmed ticket boarding exactly in 5 hours is active only', () {
      final ticket = _ticket(
        status: 'Confirmed',
        boardingTime: now.add(const Duration(hours: 5)),
      );

      expect(ticket.isUpcomingTicket(now), isFalse);
      expect(ticket.isActiveTicket(now), isTrue);
      expect(ticket.isPastTicket(now), isFalse);
    });

    test('confirmed ticket boarding in 30 minutes is active only', () {
      final ticket = _ticket(
        status: 'Confirmed',
        boardingTime: now.add(const Duration(minutes: 30)),
      );

      expect(ticket.isUpcomingTicket(now), isFalse);
      expect(ticket.isActiveTicket(now), isTrue);
      expect(ticket.isPastTicket(now), isFalse);
    });

    test('confirmed ticket boarded 30 minutes ago is boarding now', () {
      final ticket = _ticket(
        status: 'Confirmed',
        boardingTime: now.subtract(const Duration(minutes: 30)),
      );

      expect(ticket.isActiveTicket(now), isTrue);
      expect(ticket.isBoardingNow(now), isTrue);
      expect(ticket.isPastTicket(now), isFalse);
    });

    test('confirmed ticket boarded more than 1 hour ago remains active', () {
      final ticket = _ticket(
        status: 'Confirmed',
        boardingTime: now.subtract(const Duration(hours: 2)),
      );

      expect(ticket.isActiveTicket(now), isTrue);
      expect(ticket.isBoardingNow(now), isFalse);
      expect(ticket.isPastTicket(now), isFalse);
    });

    test('completed ticket boarded within the last hour is not past yet', () {
      final ticket = _ticket(
        status: 'Completed',
        boardingTime: now.subtract(const Duration(minutes: 30)),
      );

      expect(ticket.isPastTicket(now), isFalse);
      expect(ticket.isActiveTicket(now), isFalse);
      expect(ticket.isUpcomingTicket(now), isFalse);
    });

    test('completed ticket boarded more than 1 hour ago is past', () {
      final ticket = _ticket(
        status: 'Completed',
        boardingTime: now.subtract(const Duration(hours: 2)),
      );

      expect(ticket.isPastTicket(now), isTrue);
      expect(ticket.isActiveTicket(now), isFalse);
      expect(ticket.isUpcomingTicket(now), isFalse);
    });

    test('cancelled ticket without accepted refund is hidden from all tabs', () {
      final ticket = _ticket(
        status: 'Cancelled',
        refundStatus: null,
        boardingTime: now.add(const Duration(hours: 2)),
      );

      expect(ticket.isHiddenFromTicketTabs, isTrue);
      expect(ticket.isPastTicket(now), isFalse);
      expect(ticket.isActiveTicket(now), isFalse);
      expect(ticket.isUpcomingTicket(now), isFalse);
    });

    test('cancelled ticket with accepted refund is past', () {
      final ticket = _ticket(
        status: 'Cancelled',
        refundStatus: 'Accepted',
        boardingTime: now.add(const Duration(hours: 2)),
      );

      expect(ticket.isHiddenFromTicketTabs, isFalse);
      expect(ticket.isPastTicket(now), isTrue);
      expect(ticket.isActiveTicket(now), isFalse);
      expect(ticket.isUpcomingTicket(now), isFalse);
    });

    test('confirmed ticket with approved refund is past', () {
      final ticket = _ticket(
        status: 'Confirmed',
        refundStatus: 'Approved',
        boardingTime: now.add(const Duration(hours: 2)),
      );

      expect(ticket.isPastTicket(now), isTrue);
      expect(ticket.isActiveTicket(now), isFalse);
      expect(ticket.isUpcomingTicket(now), isFalse);
    });
  });
}

TicketEntity _ticket({
  required String status,
  required DateTime boardingTime,
  String? refundStatus,
}) {
  return TicketEntity(
    bookingId: 1,
    userId: 1,
    status: status,
    paymentStatus: 'Paid',
    totalPrice: 100,
    seatsBooked: 1,
    bookingDate: DateTime(2026, 6, 1),
    agencyName: 'GoBus',
    className: 'Business',
    originGovernorate: 'Cairo',
    originStation: 'Ramses',
    destinationGovernorate: 'Alexandria',
    destinationStation: 'Sidi Gaber',
    boardingTime: boardingTime,
    dropoffTime: boardingTime.add(const Duration(hours: 3)),
    isMarketplacePurchase: false,
    passengers: const [],
    refundStatus: refundStatus,
  );
}
