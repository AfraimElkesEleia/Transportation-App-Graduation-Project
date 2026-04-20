import 'package:flutter/material.dart';

/// Error view shown when the seat map fails to load.
class SeatMapErrorView extends StatelessWidget {
  final String       message;
  final VoidCallback onRetry;

  const SeatMapErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 56),
            const SizedBox(height: 16),
            Text(
              message,
              style:     const TextStyle(color: Colors.white54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon:      const Icon(Icons.refresh),
              label:     const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A2E4A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
