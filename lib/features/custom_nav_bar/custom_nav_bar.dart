import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/theming/font_weight_helper.dart';
import 'package:transportation_app/core/widgets/basic_container.dart';
import 'package:transportation_app/features/custom_nav_bar/custom_bottom_nav_bar.dart';
import 'package:transportation_app/features/home/presentation/views/screen/home_screen.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => CustomNavBarState();
}

class CustomNavBarState extends State<CustomNavBar> {
  int currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final List<Widget> _screens = [
    HomeScreen(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
  ];
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: currentIndex == 0,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) {
          print("Page successfully popped with result: $result");
        } else {
          setState(() {
            currentIndex = 0;
          });
          print("Pop was blocked.");
        }
      },
      child: Scaffold(
        body: BasicContainer(
          child: Stack(
            children: [
              Positioned.fill(
                child: IndexedStack(index: currentIndex, children: _screens),
              ),
              Align(
                alignment: AlignmentGeometry.bottomCenter,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 0, color: Color(0xFF255a91)),
                    ),
                    color: Color(0xFF1b357d),
                  ),
                  child: _navBarIcons(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _navBarIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomBottomNavBarItem(
          isActive: currentIndex == 0,
          icon: FontAwesomeIcons.house,
          label: "Home",
          onTap: () {
            _onItemTapped(0);
          },
        ),
        CustomBottomNavBarItem(
          isActive: currentIndex == 1,
          icon: FontAwesomeIcons.magnifyingGlass,
          label: "Search",
          onTap: () {
            _onItemTapped(1);
          },
        ),
        CustomBottomNavBarItem(
          isActive: currentIndex == 2,
          icon: FontAwesomeIcons.ticket,
          label: "Tickets",
          onTap: () {
            _onItemTapped(2);
          },
        ),
        CustomBottomNavBarItem(
          isActive: currentIndex == 3,
          icon: FontAwesomeIcons.user,
          label: "Profile",
          onTap: () {
            _onItemTapped(3);
          },
        ),
        CustomBottomNavBarItem(
          isActive: currentIndex == 4,
          icon: FontAwesomeIcons.bell,
          label: "More",
          onTap: () {
            _onItemTapped(4);
          },
        ),
      ],
    );
  }
}
