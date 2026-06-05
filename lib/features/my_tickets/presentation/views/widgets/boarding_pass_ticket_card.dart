import 'package:flutter/material.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/boarding_pass_helpers.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/boarding_pass_passenger_section.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/boarding_pass_route_section.dart';
import 'package:transportation_app/features/my_tickets/domain/entities/ticket_entity.dart';

class BoardingPassTicketCard extends StatelessWidget {
  final TicketEntity ticket;
  final TicketPassengerEntity passenger;

  const BoardingPassTicketCard({
    super.key,
    required this.ticket,
    required this.passenger,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D2340), Color(0xFF0A3060)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          BoardingPassRouteSection(ticket: ticket),
          const BoardingPassDashedDivider(),
          BoardingPassPassengerSection(ticket: ticket, passenger: passenger),
        ],
      ),
    );
  }
}
