import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/features/custom_nav_bar/custom_nav_bar.dart';
import 'package:transportation_app/features/login/presentation/cubit/login_cubit/login_cubit.dart';
import 'package:transportation_app/features/login/presentation/screens/login_screen.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/screen/market_place.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/screen/resell_tickets.dart';
import 'package:transportation_app/features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/profile/presentation/views/screen/edit_profile_screen.dart';
import 'package:transportation_app/features/search/presentation/views/result_view.dart';
import 'package:transportation_app/features/search/presentation/views/search_view.dart';
import 'package:transportation_app/features/signup/presentation/cubit/signup_cubit.dart';
import 'package:transportation_app/features/signup/presentation/screen/sign_up_screen.dart';

class AppRouter {
  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case AppRoutes.homeScreen:
        return MaterialPageRoute(builder: (_) => CustomNavBar());
      case AppRoutes.marketPlaceScreen:
        return MaterialPageRoute(builder: (_) => MarketplaceScreen());
      case AppRoutes.resellTicketsScreen:
        return MaterialPageRoute(builder: (_) => ResellTicketsScreen());
      case AppRoutes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<LoginCubit>(),
            child: LoginScreen(),
          ),
        );
      case AppRoutes.signUpScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (c) => sl<SignupCubit>(),
            child: SignupScreen(),
          ),
        );
      case AppRoutes.editProfile:
        final args = settings.arguments as Map<String, dynamic>;
        final ProfileEntity profileEntity = args['profile'] as ProfileEntity;
        final ProfileCubit profileCubit = args['cubit'] as ProfileCubit;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: profileCubit,
            child: EditProfileScreen(profile: profileEntity),
          ),
        );
      case AppRoutes.searchScreen:
        return MaterialPageRoute(builder: (_) => TransportSearchScreen());
      case AppRoutes.resultScreen:
        return MaterialPageRoute(builder: (_) => SeatSelectionScreen());
      default:
        return null;
    }
  }
}
