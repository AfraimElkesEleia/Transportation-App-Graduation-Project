import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/search/domain/entities/recent_search_entity.dart';
import 'package:transportation_app/features/search/domain/repository/recent_search_repository.dart';

class GetRecentSearchesUseCase {
  final RecentSearchRepository repository;

  GetRecentSearchesUseCase(this.repository);

  ResultFuture<List<RecentSearchEntity>> call() {
    return repository.getRecentSearches();
  }
}
