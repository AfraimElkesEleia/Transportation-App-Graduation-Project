import 'package:flutter/material.dart';
import 'package:transportation_app/core/widgets/basic_container.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/action_buttons_row.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/custom_ticket_tab.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/my_tickets_app_bar.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/ticket_card.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/wallet_ballance_card.dart'; // Using the card we made before

class MyTickets extends StatelessWidget {
  const MyTickets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BasicContainer(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const MyTicketsAppBar(),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              const ActionButtonsRow(),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              const SliverToBoxAdapter(child: WalletBalanceCard()),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              const SliverToBoxAdapter(child: CustomTicketTabs()),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: TicketCard(),
                    );
                  }, childCount: 3),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
    );
  }
}