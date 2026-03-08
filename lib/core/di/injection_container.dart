import 'package:get_it/get_it.dart';
import 'package:transportation_app/core/networking/dio_client.dart';
import 'package:transportation_app/core/utils/token_manager.dart';
import 'package:transportation_app/features/login/data/datasources/login_remote_data_source.dart';
import 'package:transportation_app/features/login/data/repositories/login_repository_imp.dart';
import 'package:transportation_app/features/login/domain/repositories/login_repository.dart';
import 'package:transportation_app/features/login/domain/usecase/login_usecase.dart';
import 'package:transportation_app/features/login/presentation/cubit/login_cubit/login_cubit.dart';
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
}
