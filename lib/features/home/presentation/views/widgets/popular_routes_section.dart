import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
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
        final loc = AppLocalizations.of(context)!;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.popularRoutes,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 110,
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

  Future<void> _onTap(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final now = DateTime.now();

    // First selectable date is tomorrow
    final firstDate = DateTime(now.year, now.month, now.day + 1);
    final lastDate = DateTime(now.year + 1, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: loc.selectTravelDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: ColorsManager.cyanBlue,
              onPrimary: Colors.white,
              surface: Color(0xFF11255E),
              onSurface: Colors.white,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF0A1744),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return; // user cancelled

    // Double-check: picked must not be today
    final isToday =
        picked.year == now.year &&
        picked.month == now.month &&
        picked.day == now.day;

    if (isToday) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.dateCannotBeToday),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    if (!context.mounted) return;

    final travelDate =
        '${picked.year}-'
        '${picked.month.toString().padLeft(2, '0')}-'
        '${picked.day.toString().padLeft(2, '0')}';

    final searchParams = SearchParams(
      fromDisplayName: route.originGovEn,
      toDisplayName: route.destinationGovEn,
      fromDisplayNameAr: route.originGovAr,
      toDisplayNameAr: route.destinationGovAr,
      fromGovernorate: route.originGovEn,
      toGovernorate: route.destinationGovEn,
      travelDate: travelDate,
      passengers: 1,
    );

    Navigator.pushNamed(
      context,
      AppRoutes.searchScreen,
      arguments: searchParams,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
        width: 280,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                    isAr ? route.originGovAr : route.originGovEn,
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
                    isAr ? route.destinationGovAr : route.destinationGovEn,
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
            // Calendar icon hint
            const Icon(
              Icons.calendar_today_outlined,
              color: ColorsManager.cyanBlue,
              size: 18,
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
