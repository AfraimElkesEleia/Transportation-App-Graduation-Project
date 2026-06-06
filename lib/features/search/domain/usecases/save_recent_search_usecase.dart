import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/search/domain/entities/recent_search_entity.dart';
import 'package:transportation_app/features/search/domain/repository/recent_search_repository.dart';

class SaveRecentSearchUseCase {
  final RecentSearchRepository repository;

  SaveRecentSearchUseCase(this.repository);

  ResultFuture<void> call(RecentSearchEntity search) {
    return repository.saveSearch(search);
  }
}
