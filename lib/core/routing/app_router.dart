import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_cubit.dart';
import 'package:transportation_app/features/custom_nav_bar/custom_nav_bar.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/home/domain/usecases/get_stations_use_case.dart';
import 'package:transportation_app/features/home/presentation/cubit/stations_cubit.dart';
import 'package:transportation_app/features/login/presentation/cubit/login_cubit/login_cubit.dart';
import 'package:transportation_app/features/login/presentation/screens/login_screen.dart';
import 'package:transportation_app/features/multidestination/presentation/screens/multidestination_screen.dart';
import 'package:transportation_app/features/multidestination/presentation/screens/multidestination_summary_screen.dart';
import 'package:transportation_app/features/multidestination/presentation/cubit/multi_destination_booking_cubit.dart';
import 'package:transportation_app/features/multidestination/presentation/screens/multi_destination_booking_screen.dart';
import 'package:transportation_app/features/multidestination/presentation/screens/multi_destination_passenger_form_screen.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/screen/market_place.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/screen/resell_tickets.dart';
import 'package:transportation_app/features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/profile/presentation/views/screen/edit_profile_screen.dart';
import 'package:transportation_app/features/search/data/datasources/recent_search_local_data_source.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';
import 'package:transportation_app/features/search/domain/usecases/search_indirect_trips_usecase.dart';
import 'package:transportation_app/features/search/domain/usecases/search_trips_usecase.dart';
import 'package:transportation_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:transportation_app/features/booking/presentation/views/passenger_form_screen.dart';
import 'package:transportation_app/features/booking/presentation/views/result_view.dart';
import 'package:transportation_app/features/booking/presentation/views/cart_screen.dart';
import 'package:transportation_app/features/booking/presentation/cubit/cart_cubit.dart';
import 'package:transportation_app/features/booking/presentation/views/indirect_booking_screen.dart';
import 'package:transportation_app/features/booking/presentation/cubit/indirect_booking_cubit.dart';
import 'package:transportation_app/features/booking/presentation/views/indirect_passenger_form_screen.dart';
import 'package:transportation_app/features/search/presentation/views/search_view.dart';
import 'package:transportation_app/features/booking/presentation/cubit/round_trip_booking_cubit.dart';
import 'package:transportation_app/features/booking/presentation/views/round_trip_booking_screen.dart';
import 'package:transportation_app/features/booking/presentation/views/round_trip_passenger_form_screen.dart';
import 'package:transportation_app/features/signup/presentation/cubit/signup_cubit.dart';
import 'package:transportation_app/features/signup/presentation/screen/sign_up_screen.dart';
class AppRouter {
  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case AppRoutes.homeScreen:
        return MaterialPageRoute(builder: (_) => CustomNavBar());
      case AppRoutes.multidestinationScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => StationsCubit(
              getStationsUseCase: sl<GetStationsUseCase>(),
            )..loadStations(),
            child: const MultidestinationScreen(),
          ),
        );
      case AppRoutes.multidestinationSummaryScreen:
        final legs = settings.arguments as List<MultiDestinationLegSummary>;
        return MaterialPageRoute(
          builder: (_) => MultidestinationSummaryScreen(legs: legs),
        );
      case AppRoutes.multidestinationBookingScreen:
        final legs = settings.arguments as List<MultiDestinationLegSummary>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => MultiDestinationBookingCubit(
              legs: legs,
              searchTripsUseCase: sl(),
              bookingRemoteDatasource: sl(),
            ),
            child: const MultiDestinationBookingScreen(),
          ),
        );
      case AppRoutes.multidestinationPassengerFormScreen:
        final cubit = settings.arguments as MultiDestinationBookingCubit;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: const MultiDestinationPassengerFormScreen(),
          ),
        );
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
        final SearchParams params = settings.arguments as SearchParams;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => SearchCubit(
              searchTripsUseCase: sl<SearchTripsUseCase>(),
              searchIndirectTripsUseCase: sl<SearchIndirectTripsUseCase>(),
              recentSearchLocalDataSource: sl<RecentSearchLocalDataSource>(),
            )..search(params),
            child: TransportSearchScreen(searchParams: params),
          ),
        );
      // AppRouter — resultScreen case
      case AppRoutes.resultScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final trip = args['trip'] as TripResultEntity;
        final coachClass = args['coachClass'] as CoachClassEntity;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                SeatMapCubit(datasource: sl<BookingRemoteDatasource>())
                  ..loadSeatMap(trip.tripOccurrenceId, coachClass.coachClassId),
            child: SeatSelectionScreen(trip: trip, coachClass: coachClass),
          ),
        );
      case AppRoutes.passengerFormScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final trip = args['trip'] as TripResultEntity;
        final coachClass = args['coachClass'] as CoachClassEntity;
        final seats = args['seats'] as List<String>;
        final isTrain = args['isTrain'] as bool;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                SeatMapCubit(datasource: sl<BookingRemoteDatasource>()),
            child: PassengerFormScreen(
              trip: trip,
              coachClass: coachClass,
              selectedSeats: seats,
              isTrain: isTrain,
            ),
          ),
        );
      case AppRoutes.cartScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => CartCubit(datasource: sl<BookingRemoteDatasource>()),
            child: const CartScreen(),
          ),
        );
      case AppRoutes.indirectBookingScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final trip = args['indirectTrip'] as dynamic;
        final d1 = args['dateLeg1'] as DateTime;
        final d2 = args['dateLeg2'] as DateTime;
        final params = args['activeParams'] as dynamic; // SearchParams
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => IndirectBookingCubit(
              searchTripsUseCase: sl<SearchTripsUseCase>(),
            ),
            child: IndirectBookingScreen(
              indirectTrip: trip,
              dateLeg1: d1,
              dateLeg2: d2,
              activeParams: params,
            ),
          ),
        );
      case AppRoutes.indirectPassengerFormScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final state = args['state'] as dynamic;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                SeatMapCubit(datasource: sl<BookingRemoteDatasource>()),
            child: IndirectPassengerFormScreen(bookingState: state),
          ),
        );
      case AppRoutes.roundTripBookingScreen:
        final SearchParams params = settings.arguments as SearchParams;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => RoundTripBookingCubit(
              searchTripsUseCase: sl<SearchTripsUseCase>(),
              bookingRemoteDatasource: sl<BookingRemoteDatasource>(),
            ),
            child: RoundTripBookingScreen(activeParams: params),
          ),
        );
      case AppRoutes.roundTripPassengerFormScreen:
        final cubit = settings.arguments as RoundTripBookingCubit;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: const RoundTripPassengerFormScreen(),
          ),
        );
      case AppRoutes.multidestinationScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (c) =>
                    StationsCubit(getStationsUseCase: sl<GetStationsUseCase>())..loadStations(),
              ),
            ],
            child: MultidestinationScreen(),
          ),
        );
      default:
        return null;
    }
  }
}
