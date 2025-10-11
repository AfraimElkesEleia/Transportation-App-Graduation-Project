import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/features/onboarding/data/page_view_model.dart';
import 'package:transportation_app/features/onboarding/presentation/widgets/page_of_page_view.dart';

class OnBoardingScreenPageView extends StatelessWidget {
  final void Function(int)? onPageChanged;
  final PageController pageController;
  final bool isOut;
  static const List<PageViewModel> pageViewModels = [
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
  const OnBoardingScreenPageView({
    super.key,
    this.onPageChanged,
    required this.pageController,
    required this.isOut,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandablePageView.builder(
      physics: NeverScrollableScrollPhysics(),
      controller: pageController,
      onPageChanged: onPageChanged,
      itemCount: 3,
      itemBuilder: (context, index) {
        print(pageController.position.isScrollingNotifier);
        return PageOfPageView(
          pageViewModel: pageViewModels[index],
          isOut: isOut,
        );
      },
    );
  }
}
