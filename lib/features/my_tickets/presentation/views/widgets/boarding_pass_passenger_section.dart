import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/passenger_boarding_pass_cubit.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/boarding_pass_helpers.dart';
import 'package:transportation_app/features/my_tickets/domain/entities/ticket_entity.dart';

class BoardingPassPassengerSection extends StatelessWidget {
  final TicketEntity ticket;
  final TicketPassengerEntity passenger;

  const BoardingPassPassengerSection({
    super.key,
    required this.ticket,
    required this.passenger,
  });

  @override
  Widget build(BuildContext context) {
    final className = context.isArabic
        ? (ticket.classNameAr ?? ticket.className)
        : ticket.className;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoardingPassPassengerIdentity(passenger: passenger),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BoardingPassInfoChip(
                label: 'SEAT',
                value: passenger.seatNumber.isNotEmpty
                    ? passenger.seatNumber
                    : '-',
                valueColor: Colors.white,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: BoardingPassInfoChip(
                  label: 'CLASS',
                  value: className.isNotEmpty ? className : '-',
                  valueColor: ColorsManager.accentCyan,
                  valueMaxLines: 2,
                ),
              ),
              const SizedBox(width: 16),
              BoardingPassInfoChip(
                label: 'DATE',
                value: formatBoardingPassDate(ticket.boardingTime),
                valueColor: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const BoardingPassQrCode(),
        ],
      ),
    );
  }
}

class BoardingPassPassengerIdentity extends StatelessWidget {
  final TicketPassengerEntity passenger;

  const BoardingPassPassengerIdentity({super.key, required this.passenger});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PASSENGER',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                passenger.name.isNotEmpty ? passenger.name : '-',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (passenger.idNumber.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  'ID: ${passenger.idNumber}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class BoardingPassQrCode extends StatelessWidget {
  const BoardingPassQrCode({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PassengerBoardingPassCubit, PassengerBoardingPassState>(
      builder: (_, state) {
        if (state is PassengerBoardingPassLoading) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                color: ColorsManager.accentCyan,
                strokeWidth: 2,
              ),
            ),
          );
        }

        if (state is PassengerBoardingPassLoaded) {
          return RepaintBoundary(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: QrImageView(
                data: state.qrPayload,
                version: QrVersions.auto,
                size: 220,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Colors.black,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Colors.black,
                ),
              ),
            ),
          );
        }

        if (state is PassengerBoardingPassError) {
          return Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
            ),
            child: const Center(
              child: Icon(Icons.error_outline, color: Colors.red, size: 36),
            ),
          );
        }

        return const SizedBox(height: 120);
      },
    );
  }
}
