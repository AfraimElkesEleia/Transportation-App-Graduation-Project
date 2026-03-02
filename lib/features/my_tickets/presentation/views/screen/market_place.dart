import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/marketplace_stat_box.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/marketplace_ticket_card.dart';

/// Marketplace screen showing available tickets from other travelers.
///
/// Composes [MarketplaceStatBox] and [MarketplaceTicketCard] widgets
/// with a search bar and filter controls.
class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.darkBlue,
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
              'Ticket Marketplace',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Find great deals from other travelers',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search by city (e.g., Cairo, Alexandria)",
                hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
                prefixIcon: const Icon(
                  Icons.search,
                  color: ColorsManager.accentCyan,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Filter button
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.tune, size: 18, color: Colors.white),
              label: const Text(
                "Filters",
                style: TextStyle(color: Colors.white),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Stats row
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MarketplaceStatBox(
                  icon: Icons.trending_up,
                  value: "5",
                  label: "Available",
                  color: Colors.greenAccent,
                ),
                MarketplaceStatBox(
                  icon: Icons.bolt,
                  value: "15%",
                  label: "Avg. Discount",
                  color: Colors.amber,
                ),
                MarketplaceStatBox(
                  icon: Icons.groups,
                  value: "5",
                  label: "Total Listings",
                  color: Colors.blueAccent,
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Ticket list
            const MarketplaceTicketCard(
              fromTo: "Cairo → Alexandria",
              date: "Tue, Dec 24",
              time: "16:45",
              seat: "B15",
              className: "Business",
              sellerRating: "4.8",
              postedTime: "2 hours ago",
              oldPrice: "180 EGP",
              newPrice: "160 EGP",
              discount: "-11%",
            ),
            const SizedBox(height: 16),
            const MarketplaceTicketCard(
              fromTo: "Giza → Aswan",
              date: "Wed, Dec 25",
              time: "22:00",
              seat: "A04",
              className: "First Class",
              sellerRating: "4.9",
              postedTime: "5 mins ago",
              oldPrice: "250 EGP",
              newPrice: "200 EGP",
              discount: "-20%",
            ),
            const MarketplaceTicketCard(
              fromTo: "cairo → Assuit",
              date: "Wed, Dec 23",
              time: "23:00",
              seat: "A04",
              className: "Second Class",
              sellerRating: "4.9",
              postedTime: "5 mins ago",
              oldPrice: "280 EGP",
              newPrice: "200 EGP",
              discount: "-20%",
            ),
          ],
        ),
      ),
    );
  }
}
