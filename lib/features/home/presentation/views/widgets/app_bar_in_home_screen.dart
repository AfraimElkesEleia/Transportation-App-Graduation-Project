import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/theming/styles.dart';

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
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    FontAwesomeIcons.sun,
                    color: Color(0xFF40e0d0),
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    FontAwesomeIcons.bell,
                    color: Color(0xFF40e0d0),
                    size: 20,
                  ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome!",
          style: AppStyles.bold18DarkBlue(
            context,
          ).copyWith(color: Colors.white, fontSize: 24),
        ),
        Text(
          "Where would you like to go today?",
          style: AppStyles.regular16CyanBlue(
            context,
          ).copyWith(color: Color(0xFF7abbe8)),
        ),
      ],
    );
  }
}
