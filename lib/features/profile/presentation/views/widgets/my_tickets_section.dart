import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/profile/domain/entities/ticket_entity.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_states.dart';

class MyTicketsSection extends StatefulWidget {
  const MyTicketsSection({super.key});

  @override
  State<MyTicketsSection> createState() => _MyTicketsSectionState();
}

class _MyTicketsSectionState extends State<MyTicketsSection>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    context.read<ProfileCubit>().loadMyTickets();
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.sectionCardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                const Icon(Icons.confirmation_number_rounded,
                    color: Color(0xFF00E5FF), size: 20),
                const SizedBox(width: 10),
                const Text('My Tickets',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                const Spacer(),
                TextButton(
                  onPressed: () => context.read<ProfileCubit>().loadMyTickets(),
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: const Text('Refresh',
                      style:
                          TextStyle(color: Color(0xFF00E5FF), fontSize: 12)),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tab,
            indicatorColor: const Color(0xFF00E5FF),
            labelColor: const Color(0xFF00E5FF),
            unselectedLabelColor: Colors.white38,
            labelStyle:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            dividerColor: Colors.white10,
            tabs: const [
              Tab(text: 'Upcoming'),
              Tab(text: 'Active'),
              Tab(text: 'Past'),
            ],
          ),
          BlocBuilder<ProfileCubit, ProfileState>(
            buildWhen: (p, c) =>
                c is TicketsLoading ||
                c is TicketsLoaded ||
                c is TicketsError,
            builder: (context, state) {
              if (state is TicketsLoading) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFF00E5FF), strokeWidth: 2)),
                );
              }
              if (state is TicketsError) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.wifi_off,
                            color: Colors.white38, size: 36),
                        const SizedBox(height: 8),
                        Text(state.message,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 12),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                );
              }
              if (state is TicketsLoaded) {
                final upcoming =
                    state.tickets.where((t) => t.isUpcoming).toList();
                final active =
                    state.tickets.where((t) => t.isActive).toList();
                final past =
                    state.tickets.where((t) => t.isPast).toList();

                return SizedBox(
                  height: 280,
                  child: TabBarView(
                    controller: _tab,
                    children: [
                      _TicketList(tickets: upcoming, emptyLabel: 'No upcoming trips'),
                      _TicketList(tickets: active, emptyLabel: 'No active trips'),
                      _TicketList(tickets: past, emptyLabel: 'No past trips'),
                    ],
                  ),
                );
              }
              return const SizedBox(height: 60);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _TicketList extends StatelessWidget {
  final List<TicketEntity> tickets;
  final String emptyLabel;
  const _TicketList({required this.tickets, required this.emptyLabel});

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.airplane_ticket_outlined,
                color: Colors.white24, size: 48),
            const SizedBox(height: 10),
            Text(emptyLabel,
                style:
                    const TextStyle(color: Colors.white38, fontSize: 13)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      itemCount: tickets.length,
      itemBuilder: (_, i) => _MiniTicketCard(ticket: tickets[i]),
    );
  }
}

class _MiniTicketCard extends StatelessWidget {
  final TicketEntity ticket;
  const _MiniTicketCard({required this.ticket});

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
        return const Color(0xFF00C853);
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    String fmtDate(DateTime d) {
      final h = d.hour.toString().padLeft(2, '0');
      final m = d.minute.toString().padLeft(2, '0');
      return '${d.day.toString().padLeft(2,'0')} ${months[d.month-1]}  $h:$m';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1B2D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _agencyColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border:
                      Border.all(color: _agencyColor.withOpacity(0.5)),
                ),
                child: Text(ticket.agencyName,
                    style: TextStyle(
                        color: _agencyColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Text(ticket.className,
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 11)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(ticket.status,
                    style: TextStyle(
                        color: _statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ticket.originStation,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                        overflow: TextOverflow.ellipsis),
                    Text(fmtDate(ticket.boardingTime),
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 11)),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward,
                    color: Color(0xFF00E5FF), size: 16),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(ticket.destinationStation,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end),
                    Text(fmtDate(ticket.dropoffTime),
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${ticket.seatsBooked} seat(s)',
                  style: const TextStyle(
                      color: Colors.white38, fontSize: 11)),
              Text('${ticket.totalPrice.toStringAsFixed(0)} EGP',
                  style: const TextStyle(
                      color: Color(0xFF00E5FF),
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
