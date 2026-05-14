import 'package:dartz/dartz.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/core/models/paged_result.dart';
import 'package:transportation_app/features/profile/data/datasources/loyalty_remote_datasource.dart';
import 'package:transportation_app/features/profile/domain/entities/challenge_history.dart';
import 'package:transportation_app/features/profile/domain/entities/point_transaction.dart';
import 'package:transportation_app/features/profile/domain/repositories/loyalty_repository.dart';

class LoyaltyRepositoryImpl implements LoyaltyRepository {
  final LoyaltyRemoteDatasource remoteDatasource;

  LoyaltyRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, PagedResult<ChallengeHistory>>> getChallengeHistory({bool? isCompleted, int pageNumber = 1, int pageSize = 10}) async {
    try {
      final res = await remoteDatasource.getChallengeHistory(
        isCompleted: isCompleted,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure(message: 'No internet connection'));
    } catch (e) {
      return const Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, PagedResult<PointTransaction>>> getPointHistory({int pageNumber = 1, int pageSize = 10}) async {
    try {
      final res = await remoteDatasource.getPointHistory(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure(message: 'No internet connection'));
    } catch (e) {
      return const Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }
}
