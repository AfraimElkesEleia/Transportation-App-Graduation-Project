import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/theming/styles.dart';
import 'package:transportation_app/core/widgets/block_container.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/latest_news_item.dart';

class LatestNewsBlock extends StatelessWidget {
  const LatestNewsBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return BlockContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(FontAwesomeIcons.newspaper, color: ColorsManager.cyanBlue),
              horizontalSpace(space: 8),
              Text("Latest News", style: AppStyles.semiBold18White(context)),
            ],
          ),
          verticalSpace(space: 8),
          LatestNewsItem(),
        ],
      ),
    );
  }
}
