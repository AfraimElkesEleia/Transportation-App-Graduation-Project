import 'package:dartz/dartz.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/core/utils/token_manager.dart';
import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/signup/data/datasources/auth_remote_data_source.dart';
import 'package:transportation_app/features/signup/domain/entities/auth_response.dart';
import 'package:transportation_app/features/signup/domain/repositories/register_repository.dart';

class SignupRepositoryImpl implements RegisterRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenManager tokenManager;

  SignupRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenManager,
  });

  @override
  ResultFuture<AuthResponseEntity> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String firstName,
    required String lastName,
    required String familyName,
    required int gender,
    required String dateOfBirth,
    required String countryCode,
    String? nationalIdNumber,
  }) async {
    try {
      final result = await remoteDataSource.register(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        phoneNumber: phoneNumber,
        firstName: firstName,
        lastName: lastName,
        familyName: familyName,
        gender: gender,
        dateOfBirth: dateOfBirth,
        countryCode: countryCode,
        nationalIdNumber: nationalIdNumber,
      );
      await tokenManager.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      await tokenManager.saveUser(result.user);
      return Right(result);
    } on ServerException catch (e) {
      print('🟠 [Repository] ServerException caught: ${e.message}');
      return Left(ServerFailure(message: e.message, errors: e.errors));
    } on NetworkException {
      print('🟠 [Repository] NetworkException caught');
      return Left(const NetworkFailure());
    }
  }
}
