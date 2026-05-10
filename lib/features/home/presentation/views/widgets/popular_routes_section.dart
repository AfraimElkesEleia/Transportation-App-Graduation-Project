import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/widgets/app_shimmer.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/home/domain/entities/popular_route.dart';
import 'package:transportation_app/features/home/presentation/cubit/popular_routes_cubit.dart';
import 'package:transportation_app/features/home/presentation/cubit/popular_routes_states.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';

class PopularRoutesSection extends StatelessWidget {
  const PopularRoutesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PopularRoutesCubit, PopularRoutesState>(
      builder: (context, state) {
        if (state is PopularRoutesLoading) {
          return const _ShimmerChips();
        }
        if (state is! PopularRoutesLoaded || state.routes.isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🔥 Popular Routes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100, // Fixed height for horizontal list
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.routes.length,
                  itemBuilder: (context, index) {
                    final route = state.routes[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: _RouteCard(route: route),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RouteCard extends StatelessWidget {
  final PopularRoute route;

  const _RouteCard({required this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final searchParams = SearchParams(
          fromDisplayName: route.originGov,
          toDisplayName: route.destinationGov,
          fromGovernorate: route.originGov,
          toGovernorate: route.destinationGov,
          travelDate: DateTime.now().toIso8601String().split('T').first,
          passengers: 1,
        );
        Navigator.pushNamed(
          context,
          AppRoutes.searchScreen,
          arguments: searchParams,
        );
      },
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: const Color(0XFF11255E),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: ColorsManager.cyanBlue),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.route, color: ColorsManager.cyanBlue, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    route.originGov,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '➔',
                      style: TextStyle(
                        color: ColorsManager.cyanBlue,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    route.destinationGov,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerChips extends StatelessWidget {
  const _ShimmerChips();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppShimmer(width: 120, height: 20, borderRadius: 4),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              3,
              (index) =>
                  const AppShimmer(width: 100, height: 36, borderRadius: 20),
            ),
          ),
        ],
      ),
    );
  }
}
