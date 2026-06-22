import 'package:dartz/dartz.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/search/data/datasources/recent_search_local_data_source.dart';
import 'package:transportation_app/features/search/data/models/recent_search_model.dart';
import 'package:transportation_app/features/search/domain/entities/recent_search_entity.dart';
import 'package:transportation_app/features/search/domain/repository/recent_search_repository.dart';

class RecentSearchRepositoryImpl implements RecentSearchRepository {
  final RecentSearchLocalDataSource localDataSource;

  RecentSearchRepositoryImpl({required this.localDataSource});

  @override
  ResultFuture<void> saveSearch(RecentSearchEntity search) async {
    try {
      await localDataSource.saveSearch(RecentSearchModel.fromEntity(search));
      return const Right(null);
    } catch (_) {
      return const Left(ServerFailure(message: 'Failed to save recent search'));
    }
  }

  @override
  ResultFuture<List<RecentSearchEntity>> getRecentSearches() async {
    try {
      return Right(await localDataSource.getRecentSearches());
    } catch (_) {
      return const Left(ServerFailure(message: 'Failed to load recent searches'));
    }
  }

  @override
  ResultFuture<void> deleteSearch(String id) async {
    try {
      await localDataSource.deleteSearch(id);
      return const Right(null);
    } catch (_) {
      return const Left(ServerFailure(message: 'Failed to delete recent search'));
    }
  }
}
