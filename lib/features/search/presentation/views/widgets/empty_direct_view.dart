import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';

class EmptyDirectView extends StatelessWidget {
  final VoidCallback onSearchIndirect;
  final bool showIndirectOption;

  const EmptyDirectView({
    super.key,
    required this.onSearchIndirect,
    this.showIndirectOption = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, color: Colors.white24, size: 64),
            const SizedBox(height: 20),
            Text(
              l10n.noDirectTripsFound,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              showIndirectOption
                  ? l10n.trySearchingIndirect
                  : l10n.tryRemovingFilters,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            if (showIndirectOption) ...[
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: onSearchIndirect,
                icon: const Icon(Icons.alt_route),
                label: Text(l10n.searchIndirectTrips),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A2E4A),
                  foregroundColor: const Color(0xFF00E5FF),
                  side: const BorderSide(color: Color(0xFF00E5FF)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
