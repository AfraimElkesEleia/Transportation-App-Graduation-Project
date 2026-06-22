import 'package:flutter/material.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/widgets/basic_container.dart';
import 'package:transportation_app/core/widgets/block_container.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/search_trip_button.dart';
import 'package:transportation_app/core/routing/routes.dart';

class MultiDestinationLegSummary {
  final String fromGov;
  final String? fromSub;
  final String toGov;
  final String? toSub;
  final String from;
  final String to;
  final String date;
  final String apiDate;

  MultiDestinationLegSummary({
    required this.fromGov,
    this.fromSub,
    required this.toGov,
    this.toSub,
    required this.from,
    required this.to,
    required this.date,
    required this.apiDate,
  });
}

class MultidestinationSummaryScreen extends StatelessWidget {
  final List<MultiDestinationLegSummary> legs;

  const MultidestinationSummaryScreen({super.key, required this.legs});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.journeySummary,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: BasicContainer(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: legs.length,
                  itemBuilder: (context, index) {
                    final leg = legs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: BlockContainer(
                        isVip: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.legN('${index + 1}'),
                              style: const TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            verticalSpace(space: 12),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.cyan,
                                  size: 20,
                                ),
                                horizontalSpace(space: 8),
                                Expanded(
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Text(
                                        '${loc.from}: ',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        _locationLabel(
                                          context,
                                          leg.fromGov,
                                          leg.fromSub,
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            verticalSpace(space: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.redAccent,
                                  size: 20,
                                ),
                                horizontalSpace(space: 8),
                                Expanded(
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Text(
                                        '${loc.to}: ',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        _locationLabel(
                                          context,
                                          leg.toGov,
                                          leg.toSub,
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            verticalSpace(space: 12),
                            const Divider(color: Colors.white24, height: 1),
                            verticalSpace(space: 12),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                                horizontalSpace(space: 8),
                                Text(
                                  '${loc.departure}: ${leg.date}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: BlockContainer(
                  isVip: true,
                  child: SearchTripButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.multidestinationBookingScreen,
                        arguments: legs,
                      );
                    },
                    label: loc.searchTrip,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _locationLabel(BuildContext context, String governorate, String? sub) {
  final gov = governorate.toLocalizedGov(context);
  if (sub?.trim().isNotEmpty != true) return gov;

  return '$gov - ${sub!.toLocalizedStation(context)}';
}
