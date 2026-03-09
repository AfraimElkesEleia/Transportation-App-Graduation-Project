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
  final TokenManager tokenManager;

  ProfileRepositoryImp({
    required this.remoteDataSource,
    required this.tokenManager,
  });
  @override
  ResultFuture<ProfileEntity> getProfile() async {
      try {
      final user = await tokenManager.getUser();

      if (user == null) {
        return Left(
          const ServerFailure(message: 'No user data found. Please login again.'),
        );
      }

      return Right(ProfileEntity(
        userId:            user.userId,
        email:             user.email,
        fullName:          user.fullName,
        phoneNumber:       user.phoneNumber,
        countryCode:       user.countryCode,
        countryName:       user.countryName,
        totalTrips:        20,
        totalDistanceKm:   2000,
        loyaltyPoints:     120,
      ));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
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