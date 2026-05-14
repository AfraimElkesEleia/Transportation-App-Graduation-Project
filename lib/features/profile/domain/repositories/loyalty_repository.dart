import 'package:dartz/dartz.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/core/models/paged_result.dart';
import 'package:transportation_app/features/profile/domain/entities/challenge_history.dart';
import 'package:transportation_app/features/profile/domain/entities/point_transaction.dart';

abstract class LoyaltyRepository {
  Future<Either<Failure, PagedResult<PointTransaction>>> getPointHistory({
    int pageNumber = 1,
    int pageSize = 10,
  });

  Future<Either<Failure, PagedResult<ChallengeHistory>>> getChallengeHistory({
    bool? isCompleted,
    int pageNumber = 1,
    int pageSize = 10,
  });
}
