import 'package:flutter/material.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/features/onboarding/presentation/views/onboarding_screen.dart';

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      default:
        return MaterialPageRoute(builder: (_) => Placeholder());
    }
  }
}
