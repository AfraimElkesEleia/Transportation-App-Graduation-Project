import 'package:flutter/material.dart';
import 'package:transportation_app/features/search/domain/entities/indirect_trips_enitity.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/indirect_trip_card.dart';

class IndirectTripsTab extends StatelessWidget {
  final List<IndirectTripEntity> trips;
  const IndirectTripsTab({super.key, required this.trips});

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.alt_route, color: Colors.white24, size: 56),
            SizedBox(height: 16),
            Text(
              'No indirect routes found',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: trips.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) => IndirectTripCard(trip: trips[i]),
    );
  }
}
