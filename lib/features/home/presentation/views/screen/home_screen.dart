import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/notfications/notfication_permission_manager.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/theming/styles.dart';
import 'package:transportation_app/core/widgets/app_shimmer.dart';
import 'package:transportation_app/core/widgets/block_container.dart';
import 'package:transportation_app/features/home/domain/usecases/get_stations_use_case.dart';
import 'package:transportation_app/features/home/presentation/cubit/stations_cubit.dart';
import 'package:transportation_app/features/home/presentation/cubit/stations_state.dart';
import 'package:transportation_app/features/home/presentation/cubit/popular_routes_cubit.dart';
import 'package:transportation_app/features/notfication/presentation/cubit/notfication_cubit.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/app_bar_in_home_screen.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/plan_your_journey_block.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/recent_searches_block.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/popular_routes_section.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    NotficationPermissionManager.requestIfNeeded(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              StationsCubit(getStationsUseCase: sl<GetStationsUseCase>())
                ..loadStations(),
        ),
        BlocProvider(create: (_) => sl<PopularRoutesCubit>()..load()),
        BlocProvider(
          create: (_) => sl<NotificationCubit>()..loadNotifications(),
        ),
      ],
      child: const _HomeContent(),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
              SliverToBoxAdapter(child: verticalSpace(space: 16)),
              SliverToBoxAdapter(child: const PopularRoutesSection()),
              SliverToBoxAdapter(child: verticalSpace(space: 16)),
              SliverToBoxAdapter(
                child: BlockContainer(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.timeline,
                            color: ColorsManager.cyanBlue,
                          ),
                          horizontalSpace(space: 8),
                          Text(
                            l10n.recentSearches,
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
    final l10n = AppLocalizations.of(context)!;
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
              label: Text(l10n.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.accentCyan,
                foregroundColor: Colors.white,
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
