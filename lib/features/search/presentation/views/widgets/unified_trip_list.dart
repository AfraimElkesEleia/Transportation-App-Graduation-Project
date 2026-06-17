import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/features/search/domain/entities/indirect_trips_enitity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';
import 'package:transportation_app/features/search/presentation/cubit/search_states.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/empty_direct_view.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/indirect_trip_card.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/trips_result_card.dart';

// ── Single unified list — direct → prompt → indirect ──────────
class UnifiedTripList extends StatelessWidget {
  final SearchLoaded state;
  final ScrollController scrollController;
  final VoidCallback onSearchIndirect;
  final VoidCallback onLoadMoreDirect;

  const UnifiedTripList({
    super.key,
    required this.state,
    required this.scrollController,
    required this.onSearchIndirect,
    required this.onLoadMoreDirect,
  });

  @override
  Widget build(BuildContext context) {
    _scheduleDirectPaginationIfNeeded();

    if (state.directItems.isEmpty &&
        !state.isFetchingMoreDirect &&
        !state.hasMoreDirectPages &&
        !state.indirectSearched) {
      return EmptyDirectView(
        onSearchIndirect: onSearchIndirect,
        showIndirectOption: state.activeParams.activeFilterCount == 0,
      );
    }

    // Build item list:
    // [direct trips...] + [direct spinner?] + [prompt?] +
    // [indirect header?] + [indirect trips...] + [indirect spinner?]
    final items = <_ListItem>[];

    // Direct trips
    for (final trip in state.directItems) {
      items.add(_DirectTripItem(trip));
    }

    // Direct "load more" spinner
    if (state.isFetchingMoreDirect ||
        (state.directItems.isEmpty && state.hasMoreDirectPages)) {
      items.add(const _LoadingSpinnerItem());
    }

    // Indirect prompt — show when direct pages exhausted
    // if (state.showIndirectPrompt) {
    //   items.add(const _IndirectPromptItem());
    // }

    // Indirect section
    if (state.indirectSearched) {
      // Indirect loading (first page)
      if (state.indirectLoading) {
        items.add(const _IndirectLoadingItem());
      }
      // Indirect error
      else if (state.indirectError != null) {
        items.add(_IndirectErrorItem(state.indirectError!));
      }
      // Indirect empty
      else if (state.indirectItems.isEmpty) {
        items.add(const _IndirectEmptyItem());
      }
      // Indirect results
      else {
        items.add(const _IndirectHeaderItem());
        for (final trip in state.indirectItems) {
          items.add(_IndirectTripItem(trip));
        }
        if (state.isFetchingMoreIndirect) {
          items.add(const _LoadingSpinnerItem());
        }
      }
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildItem(context, item);
      },
    );
  }

  void _scheduleDirectPaginationIfNeeded() {
    if (!state.hasMoreDirectPages || state.isFetchingMoreDirect) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      final position = scrollController.position;
      final isTooShortToScroll = position.maxScrollExtent <= 0;
      final isNearBottom =
          position.pixels >= position.maxScrollExtent - 300;

      if (isTooShortToScroll || isNearBottom) {
        onLoadMoreDirect();
      }
    });
  }

  Widget _buildItem(BuildContext context, _ListItem item) {
    if (item is _DirectTripItem) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TripResultCard(trip: item.trip),
      );
    }
    if (item is _IndirectTripItem) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: IndirectTripCard(
          trip: item.trip,
          activeParams: state.activeParams,
        ),
      );
    }
    if (item is _LoadingSpinnerItem) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF00E5FF)),
        ),
      );
    }

    if (item is _IndirectLoadingItem) {
      return  Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(color: Color(0xFF00E5FF)),
               SizedBox(height: 12),
              Text(
                AppLocalizations.of(context)!.searchingConnectingRoutes,
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }
    if (item is _IndirectErrorItem) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            item.message,
            style: const TextStyle(color: Colors.white54),
          ),
        ),
      );
    }
    if (item is _IndirectEmptyItem) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.noConnectingRoutes,
            style: const TextStyle(color: Colors.white54),
          ),
        ),
      );
    }
    if (item is _IndirectHeaderItem) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12, top: 8),
        child: Row(
          children: [
            const Icon(Icons.alt_route, color: Color(0xFF00E5FF), size: 18),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.connectingRoutes,
              style: const TextStyle(
                color: Color(0xFF00E5FF),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

////////////////////////////////////////////////////
abstract class _ListItem {
  const _ListItem();
}

class _DirectTripItem extends _ListItem {
  final TripResultEntity trip;
  _DirectTripItem(this.trip);
}

class _IndirectTripItem extends _ListItem {
  final IndirectTripEntity trip;
  _IndirectTripItem(this.trip);
}

class _LoadingSpinnerItem extends _ListItem {
  const _LoadingSpinnerItem();
}


class _IndirectLoadingItem extends _ListItem {
  const _IndirectLoadingItem();
}

class _IndirectHeaderItem extends _ListItem {
  const _IndirectHeaderItem();
}

class _IndirectEmptyItem extends _ListItem {
  const _IndirectEmptyItem();
}

class _IndirectErrorItem extends _ListItem {
  final String message;
  _IndirectErrorItem(this.message);
}
