import 'package:flutter/material.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/theming/styles.dart';
import 'package:transportation_app/features/onboarding/data/page_view_model.dart';
import 'package:transportation_app/features/onboarding/presentation/widgets/icon_container_widget.dart';

class PageOfPageView extends StatefulWidget {
  final PageViewModel pageViewModel;
  final bool isOut;
  const PageOfPageView({
    super.key,
    required this.pageViewModel,
    required this.isOut,
  });

  @override
  State<PageOfPageView> createState() => _PageOfPageViewState();
}

class _PageOfPageViewState extends State<PageOfPageView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> doubleAnimation;
  late final Animation<Offset> subtitleAnimation;
  late final Animation<Offset> descriptionAnimation;
  @override
  void initState() {
    print("initState Here");
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 250),
    );
    doubleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    subtitleAnimation = Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
    descriptionAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PageOfPageView oldWidget) {
    print("didUpdateMethod Here");
    super.didUpdateWidget(oldWidget);
    if (widget.isOut) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScaleTransition(
          scale: doubleAnimation,
          child: FadeTransition(
            opacity: doubleAnimation,
            child: IconContainerWidget(icon: widget.pageViewModel.icon),
          ),
        ),
        verticalSpace(space: 32),
        SlideTransition(
          position: subtitleAnimation,
          child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOut,
              ),
            ),
            child: Text(
              widget.pageViewModel.subtitle,
              style: AppStyles.bold16CyanBlue,
            ),
          ),
        ),
        verticalSpace(space: 8),
        FadeTransition(
          opacity: doubleAnimation,
          child: Text(
            widget.pageViewModel.title,
            style: AppStyles.medium32White,
          ),
        ),
        verticalSpace(space: 8),
        SlideTransition(
          position: descriptionAnimation,
          child: FadeTransition(
            opacity: doubleAnimation,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.pageViewModel.description,
                textAlign: TextAlign.center,
                style: AppStyles.regular20CyanBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
