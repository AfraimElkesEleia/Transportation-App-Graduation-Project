import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/theming/styles.dart';
import 'package:transportation_app/core/widgets/app_shimmer.dart';
import 'package:transportation_app/core/widgets/block_container.dart';
import 'package:transportation_app/features/home/domain/usecases/get_stations_use_case.dart';
import 'package:transportation_app/features/home/presentation/cubit/stations_cubit.dart';
import 'package:transportation_app/features/home/presentation/cubit/stations_state.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/app_bar_in_home_screen.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/latest_news_block.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/plan_your_journey_block.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/popular_trip_block.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/recent_searches_block.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StationsCubit(
        getStationsUseCase: sl<GetStationsUseCase>(),
      )..loadStations(),    // ← load once, cached for entire session
      child: const _HomeContent(),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StationsCubit, StationsState>(
      builder: (context, state) {
        // ── Loading state → show shimmer ──────────────────────────────────
        if (state is StationsInitial || state is StationsLoading) {
          return const HomeShimmer();
        }

        // ── Error state → show retry screen ──────────────────────────────
        if (state is StationsError) {
          return _HomeErrorView(message: state.message);
        }

        // ── Loaded state → show full home content ─────────────────────────
        return RefreshIndicator(
          color: ColorsManager.accentCyan,
          backgroundColor: ColorsManager.surfaceDark,
          onRefresh: () => context.read<StationsCubit>().refresh(),
          child: CustomScrollView(
            slivers: [
              AppBarInHomeScreen(),
              SliverToBoxAdapter(child: verticalSpace(space: 16)),
              SliverToBoxAdapter(child: PlanYourJourneyBlock()),
              SliverToBoxAdapter(child: verticalSpace(space: 8)),
              SliverToBoxAdapter(child: PopularTripBlock()),
              SliverToBoxAdapter(
                child: BlockContainer(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.timeline,
                            color: ColorsManager.cyanBlue,
                          ),
                          horizontalSpace(space: 8),
                          Text(
                            'Recent Searches',
                            style: AppStyles.semiBold18White(context),
                          ),
                        ],
                      ),
                      verticalSpace(space: 16),
                      const RecentSearchesList(),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: LatestNewsBlock()),
            ],
          ),
        );
      },
    );
  }
}

// ── Error / Retry view ────────────────────────────────────────────────────────
class _HomeErrorView extends StatelessWidget {
  final String message;
  const _HomeErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: Colors.red, size: 56),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<StationsCubit>().loadStations(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.accentCyan,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}