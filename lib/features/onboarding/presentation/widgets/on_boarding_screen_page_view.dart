import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/onboarding/data/page_view_model.dart';
import 'package:transportation_app/features/onboarding/presentation/widgets/icon_container_widget.dart';

class OnBoardingScreenPageView extends StatelessWidget {
  final void Function(int)? onPageChanged;
  final PageController pageController;
  final PageViewModel pageViewModel;
  const OnBoardingScreenPageView({
    super.key,
    this.onPageChanged,
    required this.pageController,
    required this.pageViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandablePageView.builder(
      controller: pageController,
      onPageChanged: onPageChanged,
      itemCount: 3,
      itemBuilder: (context, index) {
        return OnBoardingPage(pageViewModel: pageViewModel);
      },
    );
  }
}

class OnBoardingPage extends StatelessWidget {
  final PageViewModel pageViewModel;
  const OnBoardingPage({super.key, required this.pageViewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconContainerWidget(icon: pageViewModel.icon),
        verticalSpace(space: 32),
        Text(
          pageViewModel.subtitle,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorsManager.cyanBlue,
          ),
        ),
        verticalSpace(space: 8),
        Text(
          pageViewModel.subtitle,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        verticalSpace(space: 8),
        Text(
          pageViewModel.description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: ColorsManager.cyanBlue,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
