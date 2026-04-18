import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/domain/entities/indirect_trips_enitity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';
import 'package:transportation_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:transportation_app/features/search/presentation/cubit/search_states.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/filter_bottom_sheet.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/indirect_trip_card.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/search_header.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/search_loading_view.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/trips_result_card.dart';

class TransportSearchScreen extends StatefulWidget {
  final SearchParams searchParams;
  const TransportSearchScreen({super.key, required this.searchParams});

  @override
  State<TransportSearchScreen> createState() => _TransportSearchScreenState();
}

class _TransportSearchScreenState extends State<TransportSearchScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    final nearBottom = position.pixels >= position.maxScrollExtent - 300;
    if (!nearBottom) return;

    final state = context.read<SearchCubit>().state;
    if (state is! SearchLoaded) return;

    // Load more direct trips if available
    if (state.hasMoreDirectPages && !state.isFetchingMoreDirect) {
      context.read<SearchCubit>().loadMoreDirectTrips();
      return;
    }

    if (state.indirectSearched &&
        state.hasMoreIndirectPages &&
        !state.isFetchingMoreIndirect) {
      context.read<SearchCubit>().loadMoreIndirectTrips();
    }
  }

  void _openFilter(BuildContext context, SearchLoaded state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<SearchCubit>(),
        child: FilterBottomSheet(activeParams: state.activeParams),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.searchBg,
      body: SafeArea(
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            final filterCount = state is SearchLoaded
                ? state.activeParams.activeFilterCount
                : 0;

            return Column(
              children: [
                // ── Header ────────────────────────────
                SearchHeader(
                  params: widget.searchParams,
                  filterCount: filterCount,
                  onFilter: state is SearchLoaded
                      ? () => _openFilter(context, state)
                      : null,
                ),

                // ── Content ───────────────────────────
                Expanded(child: _buildContent(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, SearchState state) {
    if (state is SearchLoading) {
      return const SearchLoadingView();
    }

    // ── Error ─────────────────────────────────────────────
    if (state is SearchError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 56),
              const SizedBox(height: 16),
              Text(
                state.message,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () =>
                    context.read<SearchCubit>().search(widget.searchParams),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // ── Loaded — single unified list ──────────────────────
    if (state is SearchLoaded) {
      return _UnifiedTripList(
        state: state,
        scrollController: _scrollController,
        onSearchIndirect: () => context.read<SearchCubit>().searchIndirect(),
      );
    }

    return const SizedBox.shrink();
  }
}

// ── Single unified list — direct → prompt → indirect ──────────
class _UnifiedTripList extends StatelessWidget {
  final SearchLoaded state;
  final ScrollController scrollController;
  final VoidCallback onSearchIndirect;

  const _UnifiedTripList({
    required this.state,
    required this.scrollController,
    required this.onSearchIndirect,
  });

  @override
  Widget build(BuildContext context) {
    if (state.directItems.isEmpty &&
        !state.isFetchingMoreDirect &&
        !state.indirectSearched) {
      return _EmptyDirectView(onSearchIndirect: onSearchIndirect);
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
    if (state.isFetchingMoreDirect) {
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
        child: IndirectTripCard(trip: item.trip),
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
    if (item is _IndirectPromptItem) {
      return _IndirectPromptWidget(onTap: onSearchIndirect);
    }
    if (item is _IndirectLoadingItem) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(color: Color(0xFF00E5FF)),
              SizedBox(height: 12),
              Text(
                'Searching for connecting routes...',
                style: TextStyle(color: Colors.white54, fontSize: 13),
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
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'No connecting routes found.',
            style: TextStyle(color: Colors.white54),
          ),
        ),
      );
    }
    if (item is _IndirectHeaderItem) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 12, top: 8),
        child: Row(
          children: [
            Icon(Icons.alt_route, color: Color(0xFF00E5FF), size: 18),
            SizedBox(width: 8),
            Text(
              'Connecting Routes',
              style: TextStyle(
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

// ── Empty direct results with optional indirect search ─────────
class _EmptyDirectView extends StatelessWidget {
  final VoidCallback onSearchIndirect;
  const _EmptyDirectView({required this.onSearchIndirect});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, color: Colors.white24, size: 64),
            const SizedBox(height: 20),
            const Text(
              'No direct trips found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try searching for connecting routes with 1 stop',
              style: TextStyle(color: Colors.white54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onSearchIndirect,
              icon: const Icon(Icons.alt_route),
              label: const Text('Search Indirect Routes'),
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
        ),
      ),
    );
  }
}

// ── Prompt shown at bottom of direct list ─────────────────────
class _IndirectPromptWidget extends StatelessWidget {
  final VoidCallback onTap;
  const _IndirectPromptWidget({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF112240),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.3)),
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

class _IndirectPromptItem extends _ListItem {
  const _IndirectPromptItem();
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
