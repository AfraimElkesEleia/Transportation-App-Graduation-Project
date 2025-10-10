import 'package:flutter/material.dart';
import 'package:transportation_app/core/widgets/adaptive_layout.dart';
import 'package:transportation_app/features/onboarding/presentation/views/onboarding_screen_mobile.dart';
import 'package:transportation_app/features/onboarding/presentation/views/onboarding_screen_tablet.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      mobileLayout: (context) => OnboardingScreenMobile(),
      tabletLayout: (context) => OnboardingScreenTablet(),
    );
  }
}
