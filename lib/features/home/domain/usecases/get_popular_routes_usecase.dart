import 'package:dartz/dartz.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/features/home/domain/entities/popular_route.dart';
import 'package:transportation_app/features/home/domain/repositories/popular_routes_repository.dart';

class GetPopularRoutesUsecase {
  final PopularRoutesRepository repository;

  GetPopularRoutesUsecase(this.repository);

  Future<Either<Failure, List<PopularRoute>>> call() {
    return repository.getPopularRoutes();
  }
}
