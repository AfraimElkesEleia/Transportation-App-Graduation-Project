import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/resale_explore_banner.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/resale_summary_card.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/resale_ticket_card.dart';

/// Screen listing the user's tickets available for resale.
///
/// Composes [ResaleSummaryCard], [ResaleExploreBanner], and [ResaleTicketCard]
/// widgets into a scrollable layout.
class ResellTicketsScreen extends StatelessWidget {
  const ResellTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.resellPrimaryBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorsManager.accentCyan),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resell Tickets',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Turn your unused tickets into cash',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary cards
            const Row(
              children: [
                Expanded(
                  child: ResaleSummaryCard(
                    icon: Icons.confirmation_number_outlined,
                    title: "Available",
                    value: "3",
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ResaleSummaryCard(
                    icon: Icons.trending_up,
                    title: "Est. Value",
                    value: "655 EGP",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Explore banner
            ResaleExploreBanner(onExploreTap: () {}),
            const SizedBox(height: 25),

            // Section header
            const Row(
              children: [
                Icon(
                  Icons.confirmation_num_sharp,
                  color: ColorsManager.accentCyan,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Your Tickets for Resale',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Ticket list
            const ResaleTicketCard(
              fromTo: "Cairo → Alexandria",
              date: "Wed, Dec 25",
              time: "14:30",
              seat: "A12",
              className: "Business",
              estValue: "165 EGP",
              originalPrice: "180 EGP",
              daysLeft: "-356 days left",
            ),
            const SizedBox(height: 12),
            const ResaleTicketCard(
              fromTo: "Giza → Luxor",
              date: "Sat, Dec 28",
              time: "00:15",
              seat: "C05",
              className: "Standard",
              estValue: "210 EGP",
              originalPrice: "250 EGP",
              daysLeft: "-353 days left",
            ),
          ],
        ),
      ),
    );
  }
}
