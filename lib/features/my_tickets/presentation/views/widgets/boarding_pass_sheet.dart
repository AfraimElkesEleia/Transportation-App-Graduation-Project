import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/passenger_boarding_pass_cubit.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/boarding_pass_action_bar.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/boarding_pass_header.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/boarding_pass_pdf_service.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/boarding_pass_ticket_card.dart';
import 'package:transportation_app/features/my_tickets/domain/entities/ticket_entity.dart';

/// Shows the boarding pass bottom sheet for a specific passenger.
void showBoardingPassSheet(
  BuildContext context,
  TicketEntity ticket,
  TicketPassengerEntity passenger,
  int passengerIndex,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) =>
          sl<PassengerBoardingPassCubit>()
            ..fetchQrPayload(ticket.bookingId, passenger.passengerId),
      child: BoardingPassSheet(
        ticket: ticket,
        passenger: passenger,
        passengerIndex: passengerIndex,
      ),
    ),
  );
}

class BoardingPassSheet extends StatelessWidget {
  final TicketEntity ticket;
  final TicketPassengerEntity passenger;
  final int passengerIndex;

  const BoardingPassSheet({
    super.key,
    required this.ticket,
    required this.passenger,
    required this.passengerIndex,
  });

  @override
  Widget build(BuildContext context) {
    final pdfService = BoardingPassPdfService(
      ticket: ticket,
      passenger: passenger,
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: ColorsManager.darkBlue,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const BoardingPassDragHandle(),
            BoardingPassHeader(ticket: ticket, passenger: passenger),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  BoardingPassTicketCard(ticket: ticket, passenger: passenger),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            BoardingPassActionBar(
              onDownload: pdfService.printPdf,
              onShare: pdfService.sharePdf,
            ),
          ],
        ),
      ),
    );
  }
}
