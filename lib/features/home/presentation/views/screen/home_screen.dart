import 'package:flutter/material.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/app_bar_in_home_screen.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/plan_your_journey_block.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/popular_trip_block.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        AppBarInHomeScreen(),
        SliverToBoxAdapter(child: verticalSpace(space: 16)),
        SliverToBoxAdapter(child: PlanYourJourneyBlock()),
        SliverToBoxAdapter(child: verticalSpace(space: 8)),
        SliverToBoxAdapter(child: PopularTripBlock()),
        SliverToBoxAdapter(child: verticalSpace(space: 150)),
      ],
    );
  }
}
