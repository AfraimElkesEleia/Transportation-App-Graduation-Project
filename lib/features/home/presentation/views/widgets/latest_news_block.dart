import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/theming/styles.dart';
import 'package:transportation_app/core/widgets/block_container.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/latest_news_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/features/notfication/presentation/cubit/notfication_cubit.dart';
import 'package:transportation_app/features/notfication/presentation/cubit/notfication_state.dart';

class LatestNewsBlock extends StatelessWidget {
  const LatestNewsBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NotificationCubit>().state;
    final latestNotif =
        (state is NotificationLoaded && state.notifications.isNotEmpty)
        ? state.notifications.first
        : null;

    return BlockContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(FontAwesomeIcons.newspaper, color: ColorsManager.cyanBlue),
              horizontalSpace(space: 8),
              Text(
                AppLocalizations.of(context)!.latestNews,
                style: AppStyles.semiBold18White(context),
              ),
            ],
          ),
          verticalSpace(space: 8),
          LatestNewsItem(notification: latestNotif),
        ],
      ),
    );
  }
}
