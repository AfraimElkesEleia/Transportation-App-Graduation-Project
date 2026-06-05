import 'package:flutter/material.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/boarding_pass_helpers.dart';
import 'package:transportation_app/features/my_tickets/domain/entities/ticket_entity.dart';

class BoardingPassRouteSection extends StatelessWidget {
  final TicketEntity ticket;

  const BoardingPassRouteSection({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final originGov = context.isArabic
        ? (ticket.originGovernorateAr ?? ticket.originGovernorate)
        : ticket.originGovernorate;
    final originStation = context.isArabic
        ? (ticket.originStationNameAr ?? ticket.originStation)
        : ticket.originStation;
    final destinationGov = context.isArabic
        ? (ticket.destinationGovernorateAr ?? ticket.destinationGovernorate)
        : ticket.destinationGovernorate;
    final destinationStation = context.isArabic
        ? (ticket.destinationStationNameAr ?? ticket.destinationStation)
        : ticket.destinationStation;
    final agency = context.isArabic
        ? (ticket.agencyNameAr ?? ticket.agencyName)
        : ticket.agencyName;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: BoardingPassStopColumn(
              code: boardingPassLocationCode(originGov),
              governorate: originGov,
              station: originStation,
              time: formatBoardingPassTime(ticket.boardingTime),
            ),
          ),
          BoardingPassTimeline(
            duration: boardingPassDuration(
              ticket.boardingTime,
              ticket.dropoffTime,
            ),
            agency: agency,
          ),
          Expanded(
            child: BoardingPassStopColumn(
              code: boardingPassLocationCode(destinationGov),
              governorate: destinationGov,
              station: destinationStation,
              time: formatBoardingPassTime(ticket.dropoffTime),
              alignEnd: true,
            ),
          ),
        ],
      ),
    );
  }
}

class BoardingPassStopColumn extends StatelessWidget {
  final String code;
  final String governorate;
  final String station;
  final String time;
  final bool alignEnd;

  const BoardingPassStopColumn({
    super.key,
    required this.code,
    required this.governorate,
    required this.station,
    required this.time,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          code,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        Text(
          governorate,
          style: const TextStyle(color: Colors.white60, fontSize: 13),
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        ),
        if (station.isNotEmpty)
          Text(
            station,
            style: const TextStyle(color: Colors.white38, fontSize: 11),
            textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          ),
        Text(
          time,
          style: const TextStyle(
            color: ColorsManager.accentCyan,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class BoardingPassTimeline extends StatelessWidget {
  final String duration;
  final String agency;

  const BoardingPassTimeline({
    super.key,
    required this.duration,
    required this.agency,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Text(
            duration,
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _TimelineDot(),
              Container(width: 60, height: 1, color: Colors.white24),
              const Icon(Icons.train, color: Colors.white38, size: 18),
              Container(width: 60, height: 1, color: Colors.white24),
              _TimelineDot(),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            agency,
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _TimelineDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: ColorsManager.accentCyan,
        shape: BoxShape.circle,
      ),
    );
  }
}
