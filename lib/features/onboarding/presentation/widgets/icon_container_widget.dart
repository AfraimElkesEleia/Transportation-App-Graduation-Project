import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/theming/colors.dart';

class IconContainerWidget extends StatelessWidget {
  final Object icon;
  const IconContainerWidget({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 2.5,
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: ShapeDecoration(
            shadows: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.30),
                blurRadius: 10,
                spreadRadius: 3,
                offset: Offset(0, 8),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(32),
            ),
            gradient: LinearGradient(
              colors: [ColorsManager.brightBlue, ColorsManager.cyanBlue],
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: switch (icon) {
              final FaIconData faIcon => FaIcon(
                faIcon,
                size: MediaQuery.of(context).size.width / 4.5,
                color: Colors.white,
              ),
              final IconData materialIcon => Icon(
                materialIcon,
                size: MediaQuery.of(context).size.width / 4.5,
                color: Colors.white,
              ),
              _ => const SizedBox.shrink(),
            },
          ),
        ),
      ),
    );
  }
}
