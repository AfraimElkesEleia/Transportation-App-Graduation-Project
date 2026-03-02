import 'package:flutter/material.dart';
import 'package:transportation_app/features/onboarding/presentation/widgets/dot_indicator.dart';

class PageViewIndicator extends StatelessWidget {
  const PageViewIndicator({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DotIndicator(isActive: index == 0),
        DotIndicator(isActive: index == 1),
        DotIndicator(isActive: index == 2),
      ],
    );
  }
}