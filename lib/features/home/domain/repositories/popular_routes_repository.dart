import 'package:dartz/dartz.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/features/home/domain/entities/popular_route.dart';

abstract class PopularRoutesRepository {
  Future<Either<Failure, List<PopularRoute>>> getPopularRoutes();
}
