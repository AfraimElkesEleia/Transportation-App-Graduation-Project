import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:transportation_app/features/search/presentation/cubit/search_states.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/direct_trips_tab.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/filter_bottom_sheet.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/indirect_trips_tab.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/search_error_view.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/search_header.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/search_loading_view.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/search_tab_bar.dart';

class TransportSearchScreen extends StatefulWidget {
  const TransportSearchScreen({super.key});

  @override
  State<TransportSearchScreen> createState() => _TransportSearchScreenState();
}

class _TransportSearchScreenState extends State<TransportSearchScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
    final params = ModalRoute.of(context)?.settings.arguments as SearchParams?;
    return Scaffold(
      backgroundColor: ColorsManager.searchBg,
      body: SafeArea(
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            final directCount = state is SearchLoaded
                ? state.filteredDirect.length
                : 0;
            final indirectCount = state is SearchLoaded
                ? state.filteredIndirect.length
                : 0;
            final filterCount = state is SearchLoaded
                ? state.activeParams.activeFilterCount
                : 0;

            return Column(
              children: [
                // ── Header ─────────────────────────────
                SearchHeader(
                  params: state is SearchLoaded ? state.activeParams : null,
                  filterCount: filterCount,
                  onFilter: state is SearchLoaded
                      ? () => _openFilter(context, state)
                      : null,
                ),

                // ── Tab bar ────────────────────────────
                SearchTabBar(
                  controller: _tabController,
                  directCount: directCount,
                  indirectCount: indirectCount,
                ),
                const SizedBox(height: 8),

                // ── Content ────────────────────────────
                Expanded(child: _buildContent(context, state, params)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SearchState state,
    SearchParams? params,
  ) {
    if (state is SearchLoading) {
      return const SearchLoadingView();
    }

    if (state is SearchError) {
      return SearchErrorView(
        message: state.message,
        onRetry: params != null
            ? () => context.read<SearchCubit>().search(params)
            : null,
      );
    }

    if (state is SearchLoaded) {
      return TabBarView(
        controller: _tabController,
        children: [
          DirectTripsTab(trips: state.filteredDirect),
          IndirectTripsTab(trips: state.filteredIndirect),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
