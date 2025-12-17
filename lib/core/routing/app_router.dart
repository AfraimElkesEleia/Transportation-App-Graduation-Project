import 'package:flutter/material.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/features/custom_nav_bar/custom_nav_bar.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/screen/market_place.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/screen/resell_tickets.dart';
import 'package:transportation_app/features/onboarding/presentation/views/onboarding_screen.dart';

class AppRouter {
  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case AppRoutes.homeScreen:
        return MaterialPageRoute(builder: (_) => CustomNavBar());
      case AppRoutes.marketPlaceScreen:
        return MaterialPageRoute(builder: (_) => MarketplaceScreen());
      case AppRoutes.resellTicketsScreen:
        return MaterialPageRoute(builder: (_) => ResellTicketsScreen());
      default:
        return null;
    }
  }
}
