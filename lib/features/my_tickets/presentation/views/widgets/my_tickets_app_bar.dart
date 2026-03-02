import 'package:flutter/material.dart';

class MyTicketsAppBar extends StatelessWidget {
  const MyTicketsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My Tickets",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text(
              "Digital ticket wallet",
              style: TextStyle(color: Colors.blue[200], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}