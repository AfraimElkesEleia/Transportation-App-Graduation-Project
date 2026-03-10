import 'package:get_it/get_it.dart';
import 'package:transportation_app/core/networking/dio_client.dart';
import 'package:transportation_app/core/utils/token_manager.dart';
import 'package:transportation_app/features/login/data/datasources/login_remote_data_source.dart';
import 'package:transportation_app/features/login/data/repositories/login_repository_imp.dart';
import 'package:transportation_app/features/login/domain/repositories/login_repository.dart';
import 'package:transportation_app/features/login/domain/usecase/login_usecase.dart';
import 'package:transportation_app/features/login/presentation/cubit/login_cubit/login_cubit.dart';
import 'package:transportation_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:transportation_app/features/profile/data/repositories/profile_repository_imp.dart';
import 'package:transportation_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:transportation_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/logout_usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/update_profile_picture_usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:transportation_app/features/profile/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
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
  sl.registerFactory(() => SignupCubit(registerUseCase: sl<RegisterUseCase>()));

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
    tokenManager:     sl<TokenManager>(),
  ),
);
sl.registerLazySingleton(() => GetProfileUseCase(sl<ProfileRepository>()));
sl.registerLazySingleton(() => LogoutUseCase(sl<ProfileRepository>()));
sl.registerLazySingleton(() => UpdateProfileUseCase(sl<ProfileRepository>()));
sl.registerLazySingleton(() => UploadProfilePictureUseCase(sl<ProfileRepository>()));
sl.registerFactory(() => ProfileCubit(
  getProfileUseCase:   sl<GetProfileUseCase>(),
  updateProfileUseCase: sl<UpdateProfileUseCase>(),
  uploadPictureUseCase: sl<UploadProfilePictureUseCase>(),
));
sl.registerFactory(() => LogoutCubit(logoutUseCase: sl<LogoutUseCase>()));
}
