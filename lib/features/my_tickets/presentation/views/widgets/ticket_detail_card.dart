import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/profile/domain/entities/ticket_entity.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/routing/routes.dart';

class TicketDetailCard extends StatelessWidget {
  final TicketEntity ticket;
  final bool showUrgency;

  const TicketDetailCard({super.key, required this.ticket, this.showUrgency = false});

  Color get _agencyColor {
    final n = ticket.agencyName.toLowerCase();
    if (n.contains('gobus')) return ColorsManager.agencyGoBus;
    if (n.contains('blue')) return ColorsManager.agencyBlueBus;
    if (n.contains('rail') || n.contains('train'))
      return ColorsManager.agencyRailway;
    if (n.contains('horus')) return ColorsManager.agencyHorus;
    return ColorsManager.agencyDefault;
  }

  Color get _statusColor {
    switch (ticket.status.toLowerCase()) {
      case 'confirmed':
        return ColorsManager.successGreen;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return ColorsManager.brightBlue;
      default:
        return Colors.grey;
    }
  }

  String _fmtDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]}  $h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRoutes.ticketDetailsScreen, arguments: ticket);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: ColorsManager.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Urgency Banner (Active tab only) ──────────────────────
            if (showUrgency) _UrgencyBanner(boardingTime: ticket.boardingTime),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _agencyColor.withOpacity(0.12),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _agencyColor.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _agencyColor.withOpacity(0.6),
                        ),
                      ),
                      child: Text(
                        ticket.agencyName,
                        style: TextStyle(
                          color: _agencyColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    ticket.className,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _statusColor.withOpacity(0.4)),
                    ),
                    child: Text(
                      ticket.status,
                      style: TextStyle(
                        color: _statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Route ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket.originGovernorate,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: ColorsManager.accentCyan,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                ticket.originStation,
                                style: const TextStyle(
                                  color: ColorsManager.accentCyan,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _fmtDate(ticket.boardingTime),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const Icon(
                        Icons.flight_takeoff,
                        color: ColorsManager.accentCyan,
                        size: 18,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        height: 1.5,
                        width: 48,
                        color: ColorsManager.accentCyan.withOpacity(0.4),
                      ),
                      const Icon(
                        Icons.flight_land,
                        color: ColorsManager.accentCyan,
                        size: 18,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          ticket.destinationGovernorate,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: ColorsManager.accentCyan,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                ticket.destinationStation,
                                style: const TextStyle(
                                  color: ColorsManager.accentCyan,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _fmtDate(ticket.dropoffTime),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Divider ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: List.generate(
                  20,
                  (i) => Expanded(
                    child: Container(
                      height: 1,
                      color: i.isEven ? Colors.white12 : Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),

            // ── Footer ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  _InfoChip(
                    icon: Icons.event_seat,
                    label: '${ticket.seatsBooked} seat(s)',
                  ),
                  const SizedBox(width: 8),
                  _InfoChip(
                    icon: Icons.people_alt_outlined,
                    label: '${ticket.passengers.length} pax',
                  ),
                  const Spacer(),
                  Text(
                    '${ticket.totalPrice.toStringAsFixed(0)} EGP',
                    style: const TextStyle(
                      color: ColorsManager.accentCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceMid,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white54),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ── Urgency Banner ──────────────────────────────────────────────────────────
class _UrgencyBanner extends StatefulWidget {
  final DateTime boardingTime;
  const _UrgencyBanner({required this.boardingTime});

  @override
  State<_UrgencyBanner> createState() => _UrgencyBannerState();
}

class _UrgencyBannerState extends State<_UrgencyBanner> {
  late Duration _remaining;
  late final Stream<Duration> _stream;

  @override
  void initState() {
    super.initState();
    _remaining = widget.boardingTime.difference(DateTime.now());
    _stream = Stream.periodic(
      const Duration(seconds: 30),
      (_) => widget.boardingTime.difference(DateTime.now()),
    );
  }

  String _fmt(Duration d) {
    if (d.isNegative) return 'Boarding now';
    if (d.inHours > 0) {
      final h = d.inHours;
      final m = d.inMinutes.remainder(60);
      return 'Departing in ${h}h ${m}m';
    }
    return 'Departing in ${d.inMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: _stream,
      initialData: _remaining,
      builder: (context, snap) {
        final diff = snap.data ?? _remaining;
        final isUrgent = diff.inMinutes <= 60;
        final color = isUrgent ? Colors.orange : Colors.amber;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Row(
            children: [
              Icon(
                isUrgent ? Icons.directions_run_rounded : Icons.schedule_rounded,
                color: color,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                _fmt(diff),
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
