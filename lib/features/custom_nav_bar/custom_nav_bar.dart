import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/widgets/basic_container.dart';
import 'package:transportation_app/features/custom_nav_bar/custom_bottom_nav_bar.dart';
import 'package:transportation_app/features/home/presentation/views/screen/home_screen.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/screen/my_tickets.dart';
import 'package:transportation_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/logout_usecase.dart';
import 'package:transportation_app/features/profile/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/profile/presentation/views/screen/profile_screen.dart';

class NavItem {
  final IconData icon;
  final String label;

  NavItem({required this.icon, required this.label});
}

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => CustomNavBarState();
}

class CustomNavBarState extends State<CustomNavBar> {
  int currentIndex = 0;

  final List<NavItem> _navItems = [
    NavItem(icon: FontAwesomeIcons.house, label: "Home"),
    NavItem(icon: FontAwesomeIcons.ticket, label: "Tickets"),
    NavItem(icon: FontAwesomeIcons.user, label: "Profile"),
    NavItem(icon: FontAwesomeIcons.bell, label: "More"),
  ];

  late final List<Widget> _screens = [
    const HomeScreen(),
    const MyTickets(),
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LogoutCubit(logoutUseCase: sl<LogoutUseCase>()),
        ),
        BlocProvider(
          create: (context) =>
              ProfileCubit(getProfileUseCase: sl<GetProfileUseCase>())
                ..loadProfile(),
        ),
      ],
      child: const ProfileScreen(),
    ),
    const Center(child: Text("More")),
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: currentIndex == 0,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) {
          setState(() => currentIndex = 0);
        }
      },
      child: Scaffold(
        body: BasicContainer(
          child: IndexedStack(index: currentIndex, children: _screens),
        ),

        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(top: 10),
          decoration: const BoxDecoration(
            color: Color(0xFF1b357d),
            border: Border(top: BorderSide(color: Color(0xFF255a91))),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_navItems.length, (idx) {
                  final item = _navItems[idx];
                  return CustomBottomNavBarItem(
                    isActive: currentIndex == idx,
                    icon: item.icon,
                    label: item.label,
                    onTap: () => _onItemTapped(idx),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
