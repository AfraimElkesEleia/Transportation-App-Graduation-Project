import 'package:dartz/dartz.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/features/home/data/datasource/popular_routes_datasource.dart';
import 'package:transportation_app/features/home/domain/entities/popular_route.dart';
import 'package:transportation_app/features/home/domain/repositories/popular_routes_repository.dart';

class PopularRoutesRepositoryImpl implements PopularRoutesRepository {
  final PopularRoutesDatasource remoteDataSource;

  PopularRoutesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PopularRoute>>> getPopularRoutes() async {
    try {
      final remoteRoutes = await remoteDataSource.getPopularRoutes();
      return Right(remoteRoutes);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure(message: 'No Internet Connection'));
    } catch (e) {
      return const Left(ServerFailure(message: 'Unexpected Error Occurred'));
    }
  }
}
