import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:transportation_app/features/search/presentation/cubit/search_states.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/filter_bottom_sheet.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/search_error_view.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/search_header.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/search_loading_view.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/unified_trip_list.dart';

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
      builder: (_) => FilterBottomSheet(
        activeParams: state.activeParams,
        onApply: (newParams) {
          context.read<SearchCubit>().applyFilters(newParams);
        },
        onReset: () {
          final reset = state.activeParams.copyWith(
            transport: TransportType.all,
            sortBy: SortBy.departureTime,
            clearMaxPrice: true,
            clearTimeFilters: true,
            newPage: 1,
          );
          context.read<SearchCubit>().applyFilters(reset);
        },
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
      return SearchErrorView(
        message: state.message,
        onRetry: () => context.read<SearchCubit>().search(widget.searchParams),
      );
    }

    // ── Loaded — single unified list ──────────────────────
    if (state is SearchLoaded) {
      return UnifiedTripList(
        state: state,
        scrollController: _scrollController,
        onSearchIndirect: () => context.read<SearchCubit>().searchIndirect(),
      );
    }

    return const SizedBox.shrink();
  }
}
