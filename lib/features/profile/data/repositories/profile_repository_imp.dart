import 'package:dartz/dartz.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/core/utils/token_manager.dart';
import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';
import 'package:transportation_app/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImp extends ProfileRepository {
  final ProfileRemoteDatasource remoteDataSource;
  final TokenManager            tokenManager;

  ProfileRepositoryImp({
    required this.remoteDataSource,
    required this.tokenManager,
  });

  @override
  ResultFuture<ProfileEntity> getProfile() async {
    try {
      final model = await remoteDataSource.getProfile();
      await tokenManager.saveUser(model);
      return Right(model);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      final cached = await tokenManager.getUser();
      if (cached != null) {
        return Right(ProfileEntity(
          userId:      cached.userId,
          firstName:   cached.firstName,
          lastName:    cached.lastName,
          familyName:  cached.familyName,
          email:       cached.email,
          phoneNumber: cached.phoneNumber,
          gender:      cached.gender,
          countryCode: cached.countryCode,
          countryName: cached.countryName,
        ));
      }
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      final cached = await tokenManager.getUser();
      if (cached != null) return Right(cached);
      return Left(const NetworkFailure());
    }
  }

  @override
  ResultFuture<ProfileEntity> updateProfile({
    required String firstName,
    required String lastName,
    required String familyName,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      final model = await remoteDataSource.updateProfile(
        firstName:   firstName,
        lastName:    lastName,
        familyName:  familyName,
        email:       email,
        phoneNumber: phoneNumber,
      );
      await tokenManager.saveUser(model);
      return Right(model);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, errors: e.errors));
    } on NetworkException {
      return Left(const NetworkFailure());
    }
  }
  @override
  ResultFuture<String> uploadProfilePicture({required String filePath}) async {
    try {
      final url = await remoteDataSource.uploadProfilePicture(filePath: filePath);
      return Right(url);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(const NetworkFailure());
    }
  }
  @override
  ResultVoid logout() async {
    try {
      final refreshToken = await tokenManager.getRefreshToken();
      if (refreshToken != null) {
        await remoteDataSource.revokeToken(refreshToken: refreshToken);
      }
      await tokenManager.clearTokens();
      return const Right(null);
    } on NetworkException {
      await tokenManager.clearTokens();
      return const Right(null);
    } on ServerException catch (e) {
      await tokenManager.clearTokens();
      return Left(ServerFailure(message: e.message));
    }
  }
}