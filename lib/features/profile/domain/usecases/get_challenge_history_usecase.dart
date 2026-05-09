import 'package:dartz/dartz.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/core/models/paged_result.dart';
import 'package:transportation_app/features/profile/domain/entities/challenge_history.dart';
import 'package:transportation_app/features/profile/domain/repositories/loyalty_repository.dart';

class GetChallengeHistoryUsecase {
  final LoyaltyRepository repository;

  GetChallengeHistoryUsecase(this.repository);

  Future<Either<Failure, PagedResult<ChallengeHistory>>> call({
    bool? isCompleted,
    int pageNumber = 1,
    int pageSize = 10,
  }) {
    return repository.getChallengeHistory(
      isCompleted: isCompleted,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }
}
