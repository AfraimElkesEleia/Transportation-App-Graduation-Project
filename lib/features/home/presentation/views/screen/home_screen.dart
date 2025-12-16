import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/theming/styles.dart';
import 'package:transportation_app/core/widgets/block_container.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/app_bar_in_home_screen.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/latest_news_block.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/plan_your_journey_block.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/popular_trip_block.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/private_car_rides_block.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/recent_searches_block.dart';

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
                      "Recent Searches",
                      style: AppStyles.semiBold18White(context),
                    ),
                  ],
                ),
                verticalSpace(space: 16),
                Column(children: [RecentSearchItem(), RecentSearchItem()]),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: PrivateCarRidesBlock()),
        SliverToBoxAdapter(child: LatestNewsBlock()),
      ],
    );
  }
}
