import 'package:dartz/dartz.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/core/models/paged_result.dart';
import 'package:transportation_app/features/profile/domain/entities/point_transaction.dart';
import 'package:transportation_app/features/profile/domain/repositories/loyalty_repository.dart';

class GetPointHistoryUsecase {
  final LoyaltyRepository repository;

  GetPointHistoryUsecase(this.repository);

  Future<Either<Failure, PagedResult<PointTransaction>>> call({
    int pageNumber = 1,
    int pageSize = 10,
  }) {
    return repository.getPointHistory(pageNumber: pageNumber, pageSize: pageSize);
  }
}
