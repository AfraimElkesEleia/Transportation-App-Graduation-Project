import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/features/my_tickets/domain/entities/ticket_entity.dart';

class BoardingPassDragHandle extends StatelessWidget {
  const BoardingPassDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class BoardingPassHeader extends StatelessWidget {
  final TicketEntity ticket;
  final TicketPassengerEntity passenger;

  const BoardingPassHeader({
    super.key,
    required this.ticket,
    required this.passenger,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.boardingPassTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'REF-${ticket.bookingId}-P${passenger.passengerId}',
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white12,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
