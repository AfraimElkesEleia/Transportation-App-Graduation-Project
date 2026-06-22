import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/search/domain/entities/recent_search_entity.dart';

abstract class RecentSearchRepository {
  ResultFuture<void> saveSearch(RecentSearchEntity search);
  ResultFuture<List<RecentSearchEntity>> getRecentSearches();
  ResultFuture<void> deleteSearch(String id);
}
