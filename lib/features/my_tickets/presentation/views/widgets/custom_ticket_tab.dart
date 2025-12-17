
import 'package:flutter/material.dart';

class CustomTicketTabs extends StatelessWidget {
  const CustomTicketTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF13285C),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            _buildTab("Active", isActive: true),
            _buildTab("Upcoming", isActive: false),
            _buildTab("Past", isActive: false),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, {required bool isActive}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: isActive
            ? BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              )
            : null,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white38,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
