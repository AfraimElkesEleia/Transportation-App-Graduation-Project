import 'package:flutter/material.dart';

class ResellTicketsScreen extends StatelessWidget {
  const ResellTicketsScreen({super.key});

  static const Color primaryBg = Color(0xFF0D1B4E);
  static const Color cardColor = Color(0xFF16255A);
  static const Color accentCyan = Color(0xFF00E5FF);
  static const Color successGreen = Color(0xFF00C853);
  static const Color surfaceTeal = Color(0xFF0D3E4F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: accentCyan),
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
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    Icons.confirmation_number_outlined,
                    "Available",
                    "3",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    Icons.trending_up,
                    "Est. Value",
                    "655 EGP",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildExploreBar(context),
            const SizedBox(height: 25),

            const Row(
              children: [
                Icon(Icons.confirmation_num_sharp, color: accentCyan, size: 20),
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

            _buildResaleCard(
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
            _buildResaleCard(
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

  Widget _buildSummaryCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.1),
            child: Icon(icon, color: accentCyan, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExploreBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceTeal.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.teal.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white10,
            child: Icon(Icons.star_border, color: successGreen),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Browse Marketplace",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Find tickets from other travelers",
                  style: TextStyle(color: successGreen, fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Explore",
              style: TextStyle(
                color: successGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResaleCard({
    required String fromTo,
    required String date,
    required String time,
    required String seat,
    required String className,
    required String estValue,
    required String originalPrice,
    required String daysLeft,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: accentCyan.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.train, color: accentCyan),
                  const SizedBox(width: 8),
                  Text(
                    fromTo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.cyan.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  daysLeft,
                  style: const TextStyle(color: accentCyan, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.white60),
              const SizedBox(width: 5),
              Text(
                date,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
              const SizedBox(width: 15),
              const Icon(Icons.access_time, size: 14, color: Colors.white60),
              const SizedBox(width: 5),
              Text(
                time,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoDetail("Seat", seat),
              _infoDetail("Class", className),
              _infoDetail("Est. Value", estValue, isPrice: true),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Original: $originalPrice",
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.sell_outlined, size: 16),
                    label: const Text("Sell Ticket"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: successGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoDetail(String label, String value, {bool isPrice = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
        Text(
          value,
          style: TextStyle(
            color: isPrice ? successGreen : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isPrice ? 16 : 14,
          ),
        ),
      ],
    );
  }
}
