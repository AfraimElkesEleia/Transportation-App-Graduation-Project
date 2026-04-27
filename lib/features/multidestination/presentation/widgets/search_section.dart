import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/widgets/block_container.dart';
import 'package:transportation_app/features/home/domain/entities/station_entity.dart';
import 'package:transportation_app/features/home/domain/entities/station_group_entity.dart';
import 'package:transportation_app/features/home/presentation/cubit/stations_cubit.dart';
import 'package:transportation_app/features/home/presentation/cubit/stations_state.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/date_time_field.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/governorate_selector.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/plan_your_journey_header.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/search_trip_button.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/features/multidestination/presentation/screens/multidestination_summary_screen.dart';

class TripLegState {
  final Key key = UniqueKey();

  StationGroupEntity? fromGroup;
  StationEntity? fromStation;
  StationGroupEntity? toGroup;
  StationEntity? toStation;

  final TextEditingController fromGovController = TextEditingController();
  final TextEditingController fromSubController = TextEditingController();
  final TextEditingController toGovController = TextEditingController();
  final TextEditingController toSubController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  DateTime? parsedDate;
  bool isFromLocked = false;
  bool isToLocked = false;

  String? fromError;
  String? toError;
  String? dateError;

  void dispose() {
    fromGovController.dispose();
    fromSubController.dispose();
    toGovController.dispose();
    toSubController.dispose();
    dateController.dispose();
  }
}

class SearchSection extends StatefulWidget {
  const SearchSection({super.key});

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  final List<TripLegState> _legs = [TripLegState()];
  bool _showAutoButtons = true;

  @override
  void dispose() {
    for (var leg in _legs) {
      leg.dispose();
    }
    super.dispose();
  }

  void _addLeg() {
    setState(() {
      final newLeg = TripLegState();
      final lastLeg = _legs.last;
      if (lastLeg.toGroup != null) {
        newLeg.fromGroup = lastLeg.toGroup;
        newLeg.fromStation = lastLeg.toStation;
        newLeg.fromGovController.text = lastLeg.toGovController.text;
        newLeg.fromSubController.text = lastLeg.toSubController.text;
        newLeg.isFromLocked = true;
      }
      _legs.add(newLeg);
    });
  }

  void _onReverseStepByStep() {
    final lastLeg = _legs.last;
    if (lastLeg.fromGroup == null || lastLeg.toGroup == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill From and To before reversing.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() {
      final int initialCount = _legs.length;
      for (int i = initialCount - 1; i >= 0; i--) {
        final currentLeg = _legs[i];
        final newLeg = TripLegState();
        
        newLeg.fromGroup = currentLeg.toGroup;
        newLeg.fromStation = currentLeg.toStation;
        newLeg.fromGovController.text = currentLeg.toGovController.text;
        newLeg.fromSubController.text = currentLeg.toSubController.text;

        newLeg.toGroup = currentLeg.fromGroup;
        newLeg.toStation = currentLeg.fromStation;
        newLeg.toGovController.text = currentLeg.fromGovController.text;
        newLeg.toSubController.text = currentLeg.fromSubController.text;

        newLeg.isFromLocked = true;
        newLeg.isToLocked = true;

        _legs.add(newLeg);
      }
      _showAutoButtons = false;
    });
  }

  void _onDirectReturn() {
    final lastLeg = _legs.last;
    if (lastLeg.fromGroup == null || lastLeg.toGroup == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill From and To before returning.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() {
      final firstLeg = _legs.first;
      final lastLeg = _legs.last;

      final newLeg = TripLegState();
      newLeg.fromGroup = lastLeg.toGroup;
      newLeg.fromStation = lastLeg.toStation;
      newLeg.fromGovController.text = lastLeg.toGovController.text;
      newLeg.fromSubController.text = lastLeg.toSubController.text;

      newLeg.toGroup = firstLeg.fromGroup;
      newLeg.toStation = firstLeg.fromStation;
      newLeg.toGovController.text = firstLeg.fromGovController.text;
      newLeg.toSubController.text = firstLeg.fromSubController.text;

      newLeg.isFromLocked = true;
      newLeg.isToLocked = true;

      _legs.add(newLeg);
      _showAutoButtons = false;
    });
  }

  void _removeLeg(int index) {
    if (index > 0 && index < _legs.length) {
      setState(() {
        final removedLeg = _legs.removeAt(index);
        removedLeg.dispose();
      });
    }
  }

  bool _validateAll() {
    bool isValid = true;
    for (int i = 0; i < _legs.length; i++) {
      var leg = _legs[i];
      String? fErr;
      String? tErr;
      String? dErr;

      if (leg.fromGroup == null) fErr = 'Please select departure governorate';
      if (leg.toGroup == null) tErr = 'Please select destination governorate';

      if (leg.fromGroup != null &&
          leg.toGroup != null &&
          leg.fromGroup!.governorate == leg.toGroup!.governorate) {
        if (leg.fromStation != null &&
            leg.toStation != null &&
            leg.fromStation!.id == leg.toStation!.id) {
          tErr = 'Destination must differ from departure';
        } else if (leg.fromStation == null && leg.toStation == null) {
          tErr = 'Destination governorate must differ from departure';
        }
      }

      if (leg.dateController.text.trim().isEmpty) {
        dErr = 'Please select departure date';
      } else if (i > 0 && leg.parsedDate != null && _legs[i-1].parsedDate != null) {
        if (leg.parsedDate!.isBefore(_legs[i-1].parsedDate!)) {
          dErr = 'Date cannot be earlier than previous leg';
        }
      }

      setState(() {
        leg.fromError = fErr;
        leg.toError = tErr;
        leg.dateError = dErr;
      });

      if (fErr != null || tErr != null || dErr != null) {
        isValid = false;
      }
    }
    return isValid;
  }

  void _onSearch() {
    if (_validateAll()) {
      final summaries = _legs.map((leg) {
        final fromDisplay =
            leg.fromStation?.englishName ?? leg.fromGroup!.governorate;
        final toDisplay =
            leg.toStation?.englishName ?? leg.toGroup!.governorate;
        
        final d = leg.parsedDate!;
        final apiDate = '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

        return MultiDestinationLegSummary(
          from: fromDisplay,
          to: toDisplay,
          date: leg.dateController.text,
          apiDate: apiDate,
        );
      }).toList();

      context.pushNamed(
        AppRoutes.multidestinationSummaryScreen,
        arguments: summaries,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StationsCubit, StationsState>(
      builder: (context, state) {
        if (state is StationsInitial || state is StationsLoading) {
          return const BlockContainer(
            isVip: true,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    CircularProgressIndicator(color: Colors.cyan),
                    SizedBox(height: 12),
                    Text(
                      'Loading stations...',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is StationsError) {
          return BlockContainer(
            isVip: true,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    const Icon(Icons.wifi_off, color: Colors.red, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.white54),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () =>
                          context.read<StationsCubit>().loadStations(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final items = (state as StationsLoaded).groups;

        return Column(
          children: [
            const BlockContainer(isVip: true, child: PlanYourJourneyHeader()),
            verticalSpace(space: 16),
            ..._legs.asMap().entries.map((entry) {
              final index = entry.key;
              final leg = entry.value;

              return Padding(
                key: leg.key,
                padding: const EdgeInsets.only(bottom: 16),
                child: BlockContainer(
                  isVip: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Trip ${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (index > 1)
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _removeLeg(index),
                            ),
                        ],
                      ),
                      verticalSpace(space: 16),
                      IgnorePointer(
                        ignoring: leg.isFromLocked,
                        child: Opacity(
                          opacity: leg.isFromLocked ? 0.6 : 1.0,
                          child: GovernorateSelector(
                            title: "From Governorate",
                            controller: leg.fromGovController,
                            subCityController: leg.fromSubController,
                            selectedGroup: leg.fromGroup,
                            selectedStation: leg.fromStation,
                            onGroupSelected: (group) {
                              setState(() {
                                leg.fromGroup = group;
                                leg.fromStation = null;
                                leg.fromGovController.text =
                                    group?.governorate ?? '';
                                leg.fromSubController.clear();
                              });
                            },
                            onStationSelected: (station) {
                              setState(() {
                                leg.fromStation = station;
                                leg.fromSubController.text =
                                    station?.englishName ?? '';
                              });
                            },
                            items: items,
                            errorText: leg.fromError,
                          ),
                        ),
                      ),
                      verticalSpace(space: 12),
                      IgnorePointer(
                        ignoring: leg.isToLocked,
                        child: Opacity(
                          opacity: leg.isToLocked ? 0.6 : 1.0,
                          child: GovernorateSelector(
                            title: "To Governorate",
                            controller: leg.toGovController,
                            subCityController: leg.toSubController,
                            selectedGroup: leg.toGroup,
                            selectedStation: leg.toStation,
                            onGroupSelected: (group) {
                              setState(() {
                                leg.toGroup = group;
                                leg.toStation = null;
                                leg.toGovController.text = group?.governorate ?? '';
                                leg.toSubController.clear();
                              });
                            },
                            onStationSelected: (station) {
                              setState(() {
                                leg.toStation = station;
                                leg.toSubController.text =
                                    station?.englishName ?? '';
                              });
                            },
                            items: items,
                            errorText: leg.toError,
                          ),
                        ),
                      ),
                      verticalSpace(space: 16),
                      DateTimeField(
                        controller: leg.dateController,
                        errorText: leg.dateError,
                        minimumDate: index > 0 ? _legs[index - 1].parsedDate : null,
                        onDateSelected: (date) {
                          setState(() {
                            leg.parsedDate = date;
                            for (int j = index + 1; j < _legs.length; j++) {
                              if (_legs[j].parsedDate != null && _legs[j].parsedDate!.isBefore(date)) {
                                _legs[j].parsedDate = null;
                                _legs[j].dateController.clear();
                              }
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),

            if (_showAutoButtons)
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Note: Choose one of these options only after completing your full trip plan.',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _onReverseStepByStep,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.cyan),
                            ),
                            child: const Text(
                              'Step-by-Step Reverse',
                              style: TextStyle(color: Colors.cyan, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _onDirectReturn,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.cyan),
                            ),
                            child: const Text(
                              'Direct Return',
                              style: TextStyle(color: Colors.cyan, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      final lastLeg = _legs.last;
                      if (lastLeg.fromGroup != null && lastLeg.toGroup != null) {
                        _addLeg();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill From and To before adding a new trip.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.add, color: Colors.blueAccent),
                    label: const Text(
                      'Add another destination',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),

            verticalSpace(space: 16),
            BlockContainer(
              isVip: true,
              child: SearchTripButton(
                onPressed: _onSearch,
                label: "Search Multi-Destination",
              ),
            ),
            verticalSpace(space: 32),
          ],
        );
      },
    );
  }
}
