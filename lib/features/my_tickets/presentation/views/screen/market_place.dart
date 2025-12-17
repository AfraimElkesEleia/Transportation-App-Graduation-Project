import 'package:flutter/material.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  static const Color primaryBlue = Color(0xFF0D2167);
  static const Color accentCyan = Color(0xFF00E5FF);
  static const Color successGreen = Color(0xFF00C853);
  static const Color cardBg = Color(0xFF162B75);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlue,
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
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search by city (e.g., Cairo, Alexandria)",
                hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: accentCyan),
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatBox(
                  Icons.trending_up,
                  "5",
                  "Available",
                  Colors.greenAccent,
                ),
                _buildStatBox(Icons.bolt, "15%", "Avg. Discount", Colors.amber),
                _buildStatBox(
                  Icons.groups,
                  "5",
                  "Total Listings",
                  Colors.blueAccent,
                ),
              ],
            ),
            const SizedBox(height: 25),

            _buildTicketCard(
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

            _buildTicketCard(
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
            _buildTicketCard(
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

  Widget _buildStatBox(IconData icon, String value, String label, Color color) {
    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: cardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard({
    required String fromTo,
    required String date,
    required String time,
    required String seat,
    required String className,
    required String sellerRating,
    required String postedTime,
    required String oldPrice,
    required String newPrice,
    required String discount,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: accentCyan.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.train, color: accentCyan, size: 28),
                  const SizedBox(width: 10),
                  Text(
                    fromTo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  "For Sale",
                  style: TextStyle(color: successGreen, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.white60),
              const SizedBox(width: 4),
              Text(
                date,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
              const SizedBox(width: 15),
              const Icon(Icons.access_time, size: 14, color: Colors.white60),
              const SizedBox(width: 4),
              Text(
                time,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn("Seat", seat),
              _infoColumn("Class", className),
              _sellerColumn("Seller", sellerRating),
              _infoColumn("Posted", postedTime),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    oldPrice,
                    style: const TextStyle(
                      color: Colors.white38,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        newPrice,
                        style: const TextStyle(
                          color: successGreen,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          discount,
                          style: const TextStyle(
                            color: successGreen,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart, size: 18),
                label: const Text(
                  "Buy Now",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: successGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _sellerColumn(String label, String rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 14),
            Text(
              rating,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
