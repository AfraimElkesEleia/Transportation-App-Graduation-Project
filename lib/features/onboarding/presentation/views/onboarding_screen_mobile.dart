import 'dart:async';

import 'package:flutter/material.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/styles.dart';
import 'package:transportation_app/core/widgets/basic_container.dart';
import 'package:transportation_app/features/onboarding/presentation/widgets/next_button.dart';
import 'package:transportation_app/features/onboarding/presentation/widgets/on_boarding_screen_page_view.dart';
import 'package:transportation_app/features/onboarding/presentation/widgets/page_view_indicator.dart';

class OnboardingScreenMobile extends StatefulWidget {
  const OnboardingScreenMobile({super.key});

  @override
  State<OnboardingScreenMobile> createState() => _OnboardingScreenMobileState();
}

class _OnboardingScreenMobileState extends State<OnboardingScreenMobile> {
  late final PageController _pageController;
  int index = 0;
  bool isOut = false;
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
        child: Column(
          children: [
            verticalSpace(space: 16),
            skipButton(context),
            Spacer(),
            OnBoardingScreenPageView(
              isOut: isOut,
              onPageChanged: (value) {
                setState(() {
                  index = value;
                });
                Timer(const Duration(milliseconds: 250), () {
                  setState(() {
                    isOut = !isOut;
                  });
                });
              },
              pageController: _pageController,
            ),
            verticalSpace(space: 32),
            PageViewIndicator(index: index),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: NextButton(
                isLastPage: index == 2,
                onPressed: () {
                  if (index == 2) {
                    context.pushReplacementNamed(AppRoutes.homeScreen);
                  } else {
                    _pageController.animateToPage(
                      index + 1,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.linear,
                    );
                    setState(() {
                      isOut = !isOut;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row skipButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            context.pushReplacementNamed(AppRoutes.homeScreen);
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          child: Text(
            "Skip",
            style: AppStyles.semiBold18White
          ),
        ),
      ],
    );
  }
}
