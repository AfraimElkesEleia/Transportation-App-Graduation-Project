import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/widgets/app_shimmer.dart';
import 'package:transportation_app/core/widgets/basic_container.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/my_tickets_cubit.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/my_tickets_states.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/ticket_detail_card.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/action_buttons_row.dart';
import 'package:transportation_app/features/profile/domain/entities/ticket_entity.dart';

class MyTickets extends StatefulWidget {
  const MyTickets({super.key});

  @override
  State<MyTickets> createState() => _MyTicketsState();
}

class _MyTicketsState extends State<MyTickets>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    context.read<MyTicketsCubit>().loadAll();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<MyTicketsCubit>().loadAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BasicContainer(
        child: SafeArea(
          child: RefreshIndicator(
            color: ColorsManager.accentCyan,
            backgroundColor: ColorsManager.cardBg,
            onRefresh: _onRefresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // ── App Bar ───────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'My Tickets',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'Your digital travel wallet',
                          style: TextStyle(
                              color: Colors.blue[200], fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),



                // ── Marketplace / Resell actions ───────────────────
                ActionButtonsRow(
                  marketPlaceButton: () =>
                      context.pushNamed(AppRoutes.marketPlaceScreen),
                  resellButton: () =>
                      context.pushNamed(AppRoutes.resellTicketsScreen),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                // ── Tabs header ───────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorsManager.surfaceMid,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TabBar(
                        controller: _tabCtrl,
                        indicator: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            ColorsManager.profileGradientStart,
                            ColorsManager.profileGradientEnd,
                          ]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white38,
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 13),
                        dividerColor: Colors.transparent,
                        tabs: const [
                          Tab(text: 'Upcoming'),
                          Tab(text: 'Active'),
                          Tab(text: 'Past'),
                        ],
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // ── Ticket list ───────────────────────────────────
                SliverFillRemaining(
                  child: BlocBuilder<MyTicketsCubit, MyTicketsState>(
                    buildWhen: (_, c) =>
                        c is TicketsLoadingState ||
                        c is TicketsLoadedState ||
                        c is TicketsErrorState,
                    builder: (context, state) {
                      if (state is TicketsLoadingState) {
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          itemCount: 4,
                          itemBuilder: (_, __) => const AppShimmerCard(),
                        );
                      }
                      if (state is TicketsErrorState) {
                        return _ErrorView(
                          message: state.message,
                          onRetry: () =>
                              context.read<MyTicketsCubit>().fetchTickets(),
                        );
                      }
                      if (state is TicketsLoadedState) {
                        final upcoming = state.tickets
                            .where((t) => t.isUpcoming)
                            .toList();
                        final active = state.tickets
                            .where((t) => t.isActive)
                            .toList();
                        final past = state.tickets
                            .where((t) => t.isPast)
                            .toList();

                        return TabBarView(
                          controller: _tabCtrl,
                          children: [
                            _TicketListView(
                                tickets: upcoming,
                                emptyLabel: 'No upcoming trips'),
                            _TicketListView(
                                tickets: active,
                                emptyLabel: 'No active trips'),
                            _TicketListView(
                                tickets: past,
                                emptyLabel: 'No past trips'),
                          ],
                        );
                      }
                      // Initial / fallback
                      return const Center(
                        child: Text('Pull down to refresh',
                            style: TextStyle(color: Colors.white38)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Ticket list per tab ──────────────────────────────────────────────
class _TicketListView extends StatelessWidget {
  final List<TicketEntity> tickets;
  final String emptyLabel;
  const _TicketListView(
      {required this.tickets, required this.emptyLabel});

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.airplane_ticket_outlined,
                color: Colors.white12, size: 64),
            const SizedBox(height: 16),
            Text(emptyLabel,
                style: const TextStyle(
                    color: Colors.white38, fontSize: 14)),
            const SizedBox(height: 8),
            const Text('Pull down to refresh',
                style: TextStyle(color: Colors.white24, fontSize: 12)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      itemCount: tickets.length,
      itemBuilder: (_, i) => TicketDetailCard(ticket: tickets[i]),
    );
  }
}

// ── Error view ───────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off_rounded,
              color: Colors.white24, size: 56),
          const SizedBox(height: 16),
          Text(message,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.accentCyan,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
