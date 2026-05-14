import 'package:flutter/material.dart';

class IndirectPromptWidget extends StatelessWidget {
  final VoidCallback onTap;
  const IndirectPromptWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF112240),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00E5FF).withAlpha(76)), // .withOpacity(0.3) -> 255 * 0.3 ~= 76
      ),
      child: Column(
        children: [
          const Icon(Icons.alt_route, color: Color(0xFF00E5FF), size: 36),
          const SizedBox(height: 12),
          const Text(
            "That's all direct trips",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Want to see connecting routes with 1 stop?',
            style: TextStyle(color: Colors.white54, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.search, size: 18),
              label: const Text('Search Indirect Routes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A2E4A),
                foregroundColor: const Color(0xFF00E5FF),
                side: const BorderSide(color: Color(0xFF00E5FF)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
