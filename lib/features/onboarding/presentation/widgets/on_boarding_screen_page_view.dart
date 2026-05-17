import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/features/onboarding/data/page_view_model.dart';
import 'package:transportation_app/features/onboarding/presentation/widgets/page_of_page_view.dart';

class OnBoardingScreenPageView extends StatelessWidget {
  final void Function(int)? onPageChanged;
  final PageController pageController;
  final bool isOut;
  static List<PageViewModel> getPageViewModels(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      PageViewModel(
        subtitle: l10n.onboardingSubtitle1,
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDesc1,
        icon: FontAwesomeIcons.locationDot,
      ),
      PageViewModel(
        subtitle: l10n.onboardingSubtitle2,
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDesc2,
        icon: FontAwesomeIcons.clock,
      ),
      PageViewModel(
        subtitle: l10n.onboardingSubtitle3,
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDesc3,
        icon: Icons.shield,
      ),
    ];
  }

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
        return PageOfPageView(
          pageViewModel: getPageViewModels(context)[index],
          isOut: isOut,
        );
      },
    );
  }
}
