import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/styles.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/notfication/presentation/cubit/notfication_cubit.dart';
import 'package:transportation_app/features/notfication/presentation/cubit/notfication_state.dart';

class AppBarInHomeScreen extends StatelessWidget {
  const AppBarInHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.blue)),
          gradient: LinearGradient(
            colors: [Color(0xFF142a68), Color(0XFF183176)],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            WelcomeSentenceAppBar(),
            Row(
              children: [
                BlocBuilder<NotificationCubit, NotificationState>(
                  builder: (context, state) {
                    final unread = state is NotificationLoaded ? state.unreadCount : 0;
                    return Stack(children: [
                      IconButton(
                        icon: Icon(Icons.notifications_outlined, color: Colors.white),
                        onPressed: () => context.pushNamed(AppRoutes.notificationsScreen),
                      ),
                      if (unread > 0)
                        Positioned(
                          right: 6, top: 6,
                          child: Container(
                            width: 16, height: 16,
                            decoration: BoxDecoration(
                              color: ColorsManager.accentCyan,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              unread > 9 ? '9+' : '$unread',
                              style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ]);
                  },
                ),
                IconButton(
                  onPressed: () {
                    context.pushNamed(AppRoutes.cartScreen);
                  },
                  icon: Icon(FontAwesomeIcons.cartShopping, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomeSentenceAppBar extends StatelessWidget {
  const WelcomeSentenceAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.welcome,
          style: AppStyles.bold18DarkBlue(
            context,
          ).copyWith(color: Colors.white, fontSize: 24),
        ),
        Text(
          l10n.whereToGoToday,
          style: AppStyles.regular16CyanBlue(
            context,
          ).copyWith(color: Color(0xFF7abbe8)),
        ),
      ],
    );
  }
}
