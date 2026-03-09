import 'package:dartz/dartz.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/core/utils/token_manager.dart';
import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/login/data/datasources/login_remote_data_source.dart';
import 'package:transportation_app/features/login/domain/repositories/login_repository.dart';
import 'package:transportation_app/features/signup/domain/entities/auth_response.dart';

class LoginRepositoryImp extends LoginRepository {
  final LoginRemoteDataSource remoteDataSource;
  final TokenManager tokenManager;

  LoginRepositoryImp({
    required this.remoteDataSource,
    required this.tokenManager,
  });

  @override
  ResultFuture<AuthResponseEntity> login({
    required String email,
    required String password,
    String? deviceInfo,
    required bool rememberMe
  }) async {
    try {
      final result = await remoteDataSource.login(
        email: email,
        password: password,
        deviceInfo: deviceInfo,
        rememberMe: rememberMe
      );
      await tokenManager.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      await tokenManager.saveRememberMe(rememberMe);
      await tokenManager.saveUser(result.user);
      return Right(result);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, errors: e.errors));
    } on NetworkException {
      return Left(const NetworkFailure());
    }
  }

  @override
  ResultVoid forgotPassword({required String email}) async {
    try {
      await remoteDataSource.forgotPassword(email: email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(const NetworkFailure());
    }
  }

  @override
  ResultVoid resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await remoteDataSource.resetPassword(
        email: email,
        token: token,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, errors: e.errors));
    } on NetworkException {
      return Left(const NetworkFailure());
    }
  }

  @override
  ResultVoid changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return const Right(null);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(const NetworkFailure());
    }
  }

  @override
  ResultFuture<AuthResponseEntity> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final result = await remoteDataSource.refreshToken(
        refreshToken: refreshToken,
      );
      await tokenManager.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      await tokenManager.saveUser(result.user);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(const NetworkFailure());
    }
  }
}
