import 'package:get_it/get_it.dart';
import 'package:transportation_app/core/l10n/locale_cubit.dart';
import 'package:transportation_app/core/networking/dio_client.dart';
import 'package:transportation_app/core/utils/token_manager.dart';
import 'package:transportation_app/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:transportation_app/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:transportation_app/features/booking/domain/repositories/booking_repository.dart';
import 'package:transportation_app/features/booking/domain/usecases/add_to_cart_usecase.dart';
import 'package:transportation_app/features/booking/domain/usecases/cancel_cart_item_usecase.dart';
import 'package:transportation_app/features/booking/domain/usecases/checkout_usecase.dart';
import 'package:transportation_app/features/booking/domain/usecases/get_cart_usecase.dart';
import 'package:transportation_app/features/booking/domain/usecases/get_seat_map_usecase.dart';
import 'package:transportation_app/features/booking/presentation/cubit/cart_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/round_trip_booking_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_cubit.dart';
import 'package:transportation_app/features/multidestination/presentation/cubit/multi_destination_booking_cubit.dart';
import 'package:transportation_app/features/multidestination/presentation/screens/multidestination_summary_screen.dart';
import 'package:transportation_app/features/my_tickets/data/datasources/my_tickets_remote_datasource.dart';
import 'package:transportation_app/features/my_tickets/data/repositories/my_tickets_repository_impl.dart';
import 'package:transportation_app/features/my_tickets/domain/repositories/my_tickets_repository.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/my_tickets_cubit.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_cubit.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/passenger_boarding_pass_cubit.dart';
import 'package:transportation_app/features/notfication/data/datasources/notfication_remote_datasource.dart';
import 'package:transportation_app/features/notfication/data/repositories/notfication_repository_impl.dart';
import 'package:transportation_app/features/notfication/domain/repositories/notfication_repository.dart';
import 'package:transportation_app/features/notfication/domain/usecases/get_notifications_usecase.dart';
import 'package:transportation_app/features/notfication/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:transportation_app/features/notfication/domain/usecases/mark_notification_read_usecase.dart';
import 'package:transportation_app/features/notfication/presentation/cubit/notfication_cubit.dart';
import 'package:transportation_app/core/notfications/fcm_token_datasource.dart';
import 'package:transportation_app/features/home/data/datasource/stations_remote_datasource.dart';
import 'package:transportation_app/features/home/data/repositories/stations_repository_imp.dart';
import 'package:transportation_app/features/home/domain/repositories/station_repository.dart';
import 'package:transportation_app/features/home/domain/usecases/get_stations_use_case.dart';
import 'package:transportation_app/features/home/presentation/cubit/stations_cubit.dart';
import 'package:transportation_app/features/home/data/datasource/popular_routes_datasource.dart';
import 'package:transportation_app/features/home/data/repositories/popular_routes_repository_impl.dart';
import 'package:transportation_app/features/home/domain/repositories/popular_routes_repository.dart';
import 'package:transportation_app/features/home/domain/usecases/get_popular_routes_usecase.dart';
import 'package:transportation_app/features/home/presentation/cubit/popular_routes_cubit.dart';
import 'package:transportation_app/features/login/data/datasources/login_remote_data_source.dart';
import 'package:transportation_app/features/login/data/repositories/login_repository_imp.dart';
import 'package:transportation_app/features/login/domain/repositories/login_repository.dart';
import 'package:transportation_app/features/login/domain/usecase/login_usecase.dart';
import 'package:transportation_app/features/login/domain/usecase/forgot_password_usecase.dart';
import 'package:transportation_app/features/login/domain/usecase/reset_password_usecase.dart';
import 'package:transportation_app/features/login/domain/usecase/change_password_usecase.dart';
import 'package:transportation_app/features/login/presentation/cubit/login_cubit/login_cubit.dart';
import 'package:transportation_app/features/login/presentation/cubit/password_cubit/password_cubit.dart';
import 'package:transportation_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:transportation_app/features/profile/data/repositories/profile_repository_imp.dart';
import 'package:transportation_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:transportation_app/features/profile/domain/usecases/deposit_wallet_usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/logout_usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/update_language_usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/update_profile_picture_usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:transportation_app/features/profile/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:transportation_app/features/profile/data/datasources/loyalty_remote_datasource.dart';
import 'package:transportation_app/features/profile/data/repositories/loyalty_repository_impl.dart';
import 'package:transportation_app/features/profile/domain/repositories/loyalty_repository.dart';
import 'package:transportation_app/features/profile/domain/usecases/get_challenge_history_usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/get_point_history_usecase.dart';
import 'package:transportation_app/features/profile/presentation/cubit/loyalty_hub_cubit/loyalty_hub_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/search/data/datasources/recent_search_local_data_source.dart';
import 'package:transportation_app/features/search/data/datasources/search_remote_datasource.dart';
import 'package:transportation_app/features/search/data/repositories/recent_search_repository_impl.dart';
import 'package:transportation_app/features/search/data/repositories/search_repository_imp.dart';
import 'package:transportation_app/features/search/domain/repository/recent_search_repository.dart';
import 'package:transportation_app/features/search/domain/repository/search_repository.dart';
import 'package:transportation_app/features/search/domain/usecases/get_recent_searches_usecase.dart';
import 'package:transportation_app/features/search/domain/usecases/save_recent_search_usecase.dart';
import 'package:transportation_app/features/search/domain/usecases/search_indirect_trips_usecase.dart';
import 'package:transportation_app/features/search/domain/usecases/search_trips_usecase.dart';
import 'package:transportation_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:transportation_app/features/signup/data/datasources/auth_remote_data_source.dart';
import 'package:transportation_app/features/signup/data/repositories/signup_repository_impl.dart.dart';
import 'package:transportation_app/features/signup/domain/repositories/register_repository.dart';
import 'package:transportation_app/features/signup/domain/usecases/register_use_case.dart';
import 'package:transportation_app/features/signup/presentation/cubit/signup_cubit.dart';
import 'package:transportation_app/features/support/cubit/support_cubit.dart';
import 'package:transportation_app/features/support/cubit/support_tickets_cubit.dart';
import 'package:transportation_app/features/support/data/datasources/support_remote_datasource.dart';
import 'package:transportation_app/features/support/data/repositories/support_repository_impl.dart';
import 'package:transportation_app/features/support/domain/repositories/support_repository.dart';
import 'package:transportation_app/features/support/domain/usecases/get_support_tickets_usecase.dart';
import 'package:transportation_app/features/support/domain/usecases/submit_support_ticket_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => TokenManager());
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: DioClient.getInstance()),
  );
  sl.registerLazySingleton<RegisterRepository>(
    () => SignupRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      tokenManager: sl<TokenManager>(),
    ),
  );
  sl.registerLazySingleton(() => RegisterUseCase(sl<RegisterRepository>()));
  sl.registerFactory(
    () => SignupCubit(
      registerUseCase: sl<RegisterUseCase>(),
      uploadPictureUseCase: sl<UploadProfilePictureUseCase>(),
    ),
  );

  sl.registerFactory<LoginCubit>(
    () => LoginCubit(loginUseCase: sl<LoginUsecase>()),
  );
  sl.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(loginRepository: sl<LoginRepository>()),
  );
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImp(
      remoteDataSource: sl<LoginRemoteDataSource>(),
      tokenManager: sl<TokenManager>(),
    ),
  );
  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(dio: DioClient.getInstance()),
  );
  // ── Password (forgot / reset / change) ────────────────────────────
  sl.registerLazySingleton(
    () => ForgotPasswordUsecase(loginRepository: sl<LoginRepository>()),
  );
  sl.registerLazySingleton(
    () => ResetPasswordUsecase(loginRepository: sl<LoginRepository>()),
  );
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl<LoginRepository>()));
  sl.registerFactory(
    () => PasswordCubit(
      forgotPasswordUseCase: sl<ForgotPasswordUsecase>(),
      resetPasswordUseCase: sl<ResetPasswordUsecase>(),
      changePasswordUseCase: sl<ChangePasswordUseCase>(),
    ),
  );
  sl.registerLazySingleton<ProfileRemoteDatasource>(
    () => ProfileRemoteDatasourceImpl(dio: DioClient.getInstance()),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImp(
      remoteDataSource: sl<ProfileRemoteDatasource>(),
      tokenManager: sl<TokenManager>(),
    ),
  );
  sl.registerLazySingleton(() => GetProfileUseCase(sl<ProfileRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<ProfileRepository>()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl<ProfileRepository>()));
  sl.registerLazySingleton(() => UpdateLanguageUseCase(sl<ProfileRepository>()));
  sl.registerLazySingleton(
    () => UploadProfilePictureUseCase(sl<ProfileRepository>()),
  );
  sl.registerLazySingleton(() => DepositWalletUseCase(sl<ProfileRepository>()));
  sl.registerFactory(
    () => ProfileCubit(
      getProfileUseCase: sl<GetProfileUseCase>(),
      updateProfileUseCase: sl<UpdateProfileUseCase>(),
      uploadPictureUseCase: sl<UploadProfilePictureUseCase>(),
      depositWalletUseCase: sl<DepositWalletUseCase>(),
      profileRepository: sl<ProfileRepository>(),
    ),
  );
  sl.registerFactory(() => LogoutCubit(logoutUseCase: sl<LogoutUseCase>()));
  sl.registerLazySingleton<StationsRemoteDatasource>(
    () => StationsRemoteDatasourceImpl(dio: DioClient.getInstance()),
  );
  sl.registerLazySingleton<StationsRepository>(
    () => StationsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetStationsUseCase(sl<StationsRepository>()));
  sl.registerFactory(() => StationsCubit(getStationsUseCase: sl()));

  // Popular Routes
  sl.registerLazySingleton<PopularRoutesDatasource>(
    () => PopularRoutesDatasourceImpl(dio: DioClient.getInstance()),
  );
  sl.registerLazySingleton<PopularRoutesRepository>(
    () => PopularRoutesRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetPopularRoutesUsecase(sl()));
  sl.registerFactory(() => PopularRoutesCubit(sl()));

  sl.registerLazySingleton<SearchRemoteDatasource>(
    () => SearchRemoteDatasourceImpl(dio: DioClient.getInstance()),
  );
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<RecentSearchLocalDataSource>(
    () => RecentSearchLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<RecentSearchRepository>(
    () => RecentSearchRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => SearchTripsUseCase(sl<SearchRepository>()));
  sl.registerLazySingleton(
    () => SearchIndirectTripsUseCase(sl<SearchRepository>()),
  );
  sl.registerLazySingleton(() => SaveRecentSearchUseCase(sl()));
  sl.registerLazySingleton(() => GetRecentSearchesUseCase(sl()));
  sl.registerFactory(
    () => SearchCubit(
      searchTripsUseCase: sl(),
      searchIndirectTripsUseCase: sl(),
      saveRecentSearchUseCase: sl(),
    ),
  );
  sl.registerLazySingleton<BookingRemoteDatasource>(
    () => BookingRemoteDatasourceImpl(dio: DioClient.getInstance()),
  );
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton(() => GetCartUseCase(sl()));
  sl.registerLazySingleton(() => GetSeatMapUseCase(sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => CheckoutUseCase(sl()));
  sl.registerLazySingleton(() => CancelCartItemUsecase(sl()));
  sl.registerFactory(
    () => SeatMapCubit(
      getSeatMapUseCase: sl(),
      addToCartUseCase: sl(),
      getCartUseCase: sl(),
      checkoutUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => CartCubit(
      getCartUseCase: sl(),
      checkoutUseCase: sl(),
      cancelCartItemUsecase: sl(),
    ),
  );
  sl.registerFactoryParam<RoundTripBookingCubit, void, void>(
    (_, _) => RoundTripBookingCubit(
      searchTripsUseCase: sl(),
      addToCartUseCase: sl(),
      checkoutUseCase: sl(),
    ),
  );
  sl.registerFactoryParam<
    MultiDestinationBookingCubit,
    List<MultiDestinationLegSummary>,
    void
  >(
    (legs, _) => MultiDestinationBookingCubit(
      legs: legs,
      searchTripsUseCase: sl(),
      addToCartUseCase: sl(),
      checkoutUseCase: sl(),
    ),
  );

  // ── My Tickets feature ─────────────────────────────────────────────
  sl.registerLazySingleton<MyTicketsRemoteDatasource>(
    () => MyTicketsRemoteDatasourceImpl(dio: DioClient.getInstance()),
  );
  sl.registerLazySingleton<MyTicketsRepository>(
    () => MyTicketsRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerFactory(
    () => MyTicketsCubit(repository: sl<MyTicketsRepository>()),
  );
  sl.registerFactory(
    () => MarketplaceCubit(repository: sl<MyTicketsRepository>()),
  );
  sl.registerFactory(
    () => PassengerBoardingPassCubit(repository: sl<MyTicketsRepository>()),
  );

  // ── Loyalty Hub feature ─────────────────────────────────────────────
  sl.registerLazySingleton<LoyaltyRemoteDatasource>(
    () => LoyaltyRemoteDatasourceImpl(dio: DioClient.getInstance()),
  );
  sl.registerLazySingleton<LoyaltyRepository>(
    () => LoyaltyRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton(() => GetPointHistoryUsecase(sl()));
  sl.registerLazySingleton(() => GetChallengeHistoryUsecase(sl()));
  sl.registerFactory(() => LoyaltyHubCubit(sl(), sl()));
  sl.registerLazySingleton<NotficationRemoteDatasource>(
    () => NotficationRemoteDatasourceImpl(dio: DioClient.getInstance()),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkNotificationReadUseCase(sl()));
  sl.registerLazySingleton(() => MarkAllNotificationsReadUseCase(sl()));
  sl.registerFactory(
    () => NotificationCubit(
      getNotificationsUseCase: sl(),
      markNotificationReadUseCase: sl(),
      markAllNotificationsReadUseCase: sl(),
    ),
  );
  sl.registerLazySingleton<FcmTokenDatasource>(
    () => FcmTokenDatasource(DioClient.getInstance()),
  );

  // ── Support Tickets ─────────────────────────────────────────────────
  sl.registerLazySingleton<SupportRemoteDatasource>(
    () => SupportRemoteDatasourceImpl(dio: DioClient.getInstance()),
  );
  sl.registerLazySingleton<SupportRepository>(
    () => SupportRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton(() => SubmitSupportTicketUseCase(sl()));
  sl.registerLazySingleton(() => GetSupportTicketsUseCase(sl()));
  sl.registerFactory<SupportCubit>(() => SupportCubit(sl()));
  sl.registerFactory<SupportTicketsCubit>(() => SupportTicketsCubit(sl()));

  sl.registerLazySingleton(
    () => LocaleCubit(
      tokenManager: sl<TokenManager>(),
      updateLanguageUseCase: sl<UpdateLanguageUseCase>(),
    ),
  );
}
