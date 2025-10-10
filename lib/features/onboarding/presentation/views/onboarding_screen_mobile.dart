import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/widgets/basic_container.dart';
import 'package:transportation_app/features/onboarding/data/page_view_model.dart';
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
  final List<PageViewModel> pageViewModels = [
    PageViewModel(
      subtitle: "TRAVEL SMART",
      title: "Discover Egypt",
      description:
          "Explore every corner of Egypt with our comprehensive bus and train network connecting all major cities",
      icon: FontAwesomeIcons.locationDot,
    ),
    PageViewModel(
      subtitle: "STAY INFORMED",
      title: "Real-Time Updates",
      description:
          "Get instant notifications about schedules, delays, and platform changes. Never miss your journey",
      icon: FontAwesomeIcons.clock,
    ),
    PageViewModel(
      subtitle: "TRAVEL CONFIDENT",
      title: "Secure & Reliable",
      description:
          "Book with confidence using our secure payment system and reliable transportation partners",
      icon: Icons.shield,
    ),
  ];
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            OnBoardingScreenPageView(
              onPageChanged: (value) {
                setState(() {
                  index = value;
                });
              },
              pageController: _pageController,
              pageViewModel: pageViewModels[index],
            ),
            verticalSpace(space: 64),
            PageViewIndicator(index: index),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: NextButton(pageController: _pageController, index: index),
            ),
          ],
        ),
      ),
    );
  }
}
