import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/boarding_pass_sheet.dart';
import 'package:transportation_app/features/profile/domain/entities/ticket_entity.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';

class TicketDetailsScreen extends StatelessWidget {
  final TicketEntity ticket;

  const TicketDetailsScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: ColorsManager.darkBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorsManager.accentCyan),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.ticketDetails,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Trip Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorsManager.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.07)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.isArabic
                            ? (ticket.agencyNameAr ?? ticket.agencyName)
                            : ticket.agencyName,
                        style: const TextStyle(
                          color: ColorsManager.accentCyan,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: ColorsManager.successGreen.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: ColorsManager.successGreen.withOpacity(0.4),
                          ),
                        ),
                        child: Text(
                          ticket.status,
                          style: const TextStyle(
                            color: ColorsManager.successGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.ticketClass(
                      context.isArabic
                          ? (ticket.classNameAr ?? ticket.className)
                          : ticket.className,
                    ),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.from,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              (ticket.originGovernorateAr ??
                                      ticket.originGovernorate)
                                  .toLocalizedGov(context),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              (context.isArabic
                                      ? (ticket.originStationNameAr ??
                                            ticket.originStation)
                                      : ticket.originStation)
                                  .toLocalizedStation(context),
                              style: const TextStyle(
                                color: ColorsManager.accentCyan,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        color: ColorsManager.accentCyan,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              l10n.to,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              (ticket.destinationGovernorateAr ??
                                      ticket.destinationGovernorate)
                                  .toLocalizedGov(context),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              (context.isArabic
                                      ? (ticket.destinationStationNameAr ??
                                            ticket.destinationStation)
                                      : ticket.destinationStation)
                                  .toLocalizedStation(context),
                              style: const TextStyle(
                                color: ColorsManager.accentCyan,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: ColorsManager.accentCyan,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.departure,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Text(
                      DateFormat(
                        'yyyy-MM-dd hh:mm a',
                      ).format(ticket.boardingTime),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: ColorsManager.accentCyan,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.arrival,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Text(
                      DateFormat(
                        'yyyy-MM-dd hh:mm a',
                      ).format(ticket.dropoffTime),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.white12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.bookingRef,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'REF-${ticket.bookingId}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.passengersAndSeats,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.tapPassengerInfo,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ...ticket.passengers.asMap().entries.map((entry) {
              final index = entry.key;
              final p = entry.value;
              return GestureDetector(
                onTap: () => showBoardingPassSheet(context, ticket, p, index),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorsManager.surfaceMid,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      // Index bubble
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: ColorsManager.accentCyan.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ColorsManager.accentCyan.withOpacity(0.3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: ColorsManager.accentCyan,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Name / ID / Seat tag
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (p.name.isNotEmpty)
                              Text(
                                p.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            if (p.idNumber.isNotEmpty)
                              Text(
                                l10n.idNum(p.idNumber),
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            if (p.seatNumber.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorsManager.accentCyan.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: ColorsManager.accentCyan.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  l10n.seatNum(p.seatNumber),
                                  style: const TextStyle(
                                    color: ColorsManager.accentCyan,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      // QR icon placeholder
                      const Icon(
                        Icons.qr_code_2_rounded,
                        size: 40,
                        color: Colors.white38,
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right, color: Colors.white24),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
