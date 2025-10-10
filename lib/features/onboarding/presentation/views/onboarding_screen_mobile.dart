import 'package:flutter/material.dart';
import 'package:transportation_app/core/widgets/basic_container.dart';

class OnboardingScreenMobile extends StatefulWidget {
  const OnboardingScreenMobile({super.key});

  @override
  State<OnboardingScreenMobile> createState() => _OnboardingScreenMobileState();
}

class _OnboardingScreenMobileState extends State<OnboardingScreenMobile> {
  late final PageController _pageController;
  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BasicContainer(
        child: Column(children: [Expanded(child: PageView())]),
      ),
    );
  }
}
