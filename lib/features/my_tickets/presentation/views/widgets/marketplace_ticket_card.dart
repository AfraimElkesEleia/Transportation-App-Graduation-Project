import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';

/// A card displaying a marketplace ticket listing with route, schedule,
/// seat info, seller rating, and pricing.
class MarketplaceTicketCard extends StatelessWidget {
  /// Route label (e.g. "Cairo → Alexandria").
  final String fromTo;

  /// Departure date.
  final String date;

  /// Departure time.
  final String time;

  /// Seat number.
  final String seat;

  /// Travel class name.
  final String className;

  /// Seller rating value.
  final String sellerRating;

  /// When the listing was posted.
  final String postedTime;

  /// Original (strikethrough) price.
  final String oldPrice;

  /// Discounted price.
  final String newPrice;

  /// Discount percentage label.
  final String discount;

  const MarketplaceTicketCard({
    super.key,
    required this.fromTo,
    required this.date,
    required this.time,
    required this.seat,
    required this.className,
    required this.sellerRating,
    required this.postedTime,
    required this.oldPrice,
    required this.newPrice,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.marketplaceCardBg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: ColorsManager.accentCyan.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          // Route header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.train,
                    color: ColorsManager.accentCyan,
                    size: 28,
                  ),
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
                  style: TextStyle(
                    color: ColorsManager.successGreen,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Date & time
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

          // Info columns
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

          // Pricing & buy
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
                          color: ColorsManager.successGreen,
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
                            color: ColorsManager.successGreen,
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
                  backgroundColor: ColorsManager.successGreen,
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
