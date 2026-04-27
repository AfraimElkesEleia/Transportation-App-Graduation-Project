import 'package:get_it/get_it.dart';
import 'package:transportation_app/core/networking/dio_client.dart';
import 'package:transportation_app/core/utils/token_manager.dart';
import 'package:transportation_app/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_cubit.dart';
import 'package:transportation_app/features/my_tickets/data/datasources/my_tickets_remote_datasource.dart';
import 'package:transportation_app/features/my_tickets/data/repositories/my_tickets_repository_impl.dart';
import 'package:transportation_app/features/my_tickets/domain/repositories/my_tickets_repository.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/my_tickets_cubit.dart';
import 'package:transportation_app/features/home/data/datasource/stations_remote_datasource.dart';
import 'package:transportation_app/features/home/data/repositories/stations_repository_imp.dart';
import 'package:transportation_app/features/home/domain/repositories/station_repository.dart';
import 'package:transportation_app/features/home/domain/usecases/get_stations_use_case.dart';
import 'package:transportation_app/features/home/presentation/cubit/stations_cubit.dart';
import 'package:transportation_app/features/login/data/datasources/login_remote_data_source.dart';
import 'package:transportation_app/features/login/data/repositories/login_repository_imp.dart';
import 'package:transportation_app/features/login/domain/repositories/login_repository.dart';
import 'package:transportation_app/features/login/domain/usecase/login_usecase.dart';
import 'package:transportation_app/features/login/presentation/cubit/login_cubit/login_cubit.dart';
import 'package:transportation_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:transportation_app/features/profile/data/repositories/profile_repository_imp.dart';
import 'package:transportation_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:transportation_app/features/profile/domain/usecases/deposit_wallet_usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/logout_usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/update_profile_picture_usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:transportation_app/features/profile/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/search/data/datasources/recent_search_local_data_source.dart';
import 'package:transportation_app/features/search/data/datasources/search_remote_datasource.dart';
import 'package:transportation_app/features/search/data/repositories/search_repository_imp.dart';
import 'package:transportation_app/features/search/domain/repository/search_repository.dart';
import 'package:transportation_app/features/search/domain/usecases/search_indirect_trips_usecase.dart';
import 'package:transportation_app/features/search/domain/usecases/search_trips_usecase.dart';
import 'package:transportation_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:transportation_app/features/signup/data/datasources/auth_remote_data_source.dart';
import 'package:transportation_app/features/signup/data/repositories/signup_repository_impl.dart.dart';
import 'package:transportation_app/features/signup/domain/repositories/register_repository.dart';
import 'package:transportation_app/features/signup/domain/usecases/register_use_case.dart';
import 'package:transportation_app/features/signup/presentation/cubit/signup_cubit.dart';

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
  sl.registerLazySingleton<SearchRemoteDatasource>(
    () => SearchRemoteDatasourceImpl(dio: DioClient.getInstance()),
  );
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<RecentSearchLocalDataSource>(
    () => RecentSearchLocalDataSourceImpl(),
  );
  sl.registerLazySingleton(() => SearchTripsUseCase(sl<SearchRepository>()));
  sl.registerLazySingleton(
    () => SearchIndirectTripsUseCase(sl<SearchRepository>()),
  );
  sl.registerFactory(
    () =>
        SearchCubit(searchTripsUseCase: sl(), searchIndirectTripsUseCase: sl(),recentSearchLocalDataSource: sl()),
  );
  sl.registerLazySingleton<BookingRemoteDatasource>(
    () => BookingRemoteDatasourceImpl(dio: DioClient.getInstance()),
  );
  sl.registerFactory(() => SeatMapCubit(datasource: sl()));

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
}
