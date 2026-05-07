import 'package:hive/hive.dart';
import 'package:transportation_app/features/search/data/models/recent_search_model.dart';
import 'package:intl/intl.dart';

abstract class RecentSearchLocalDataSource {
  Future<void> saveSearch(RecentSearchModel search);
  Future<List<RecentSearchModel>> getRecentSearches();
  Future<void> deleteSearch(String id);
}

class RecentSearchLocalDataSourceImpl implements RecentSearchLocalDataSource {
  static const String boxName = 'recent_searches_box';
  static const int maxSearches = 3;

  @override
  Future<void> saveSearch(RecentSearchModel search) async {
    final box = Hive.box<RecentSearchModel>(boxName);

    final existingKey = _findIdenticalSearchKey(box, search);
    if (existingKey != null) {
      await box.delete(existingKey);
    }

    await box.add(search);

    if (box.length > maxSearches) {
      final keys = box.keys.toList();
      await box.delete(keys.first);
    }
  }

  @override
  Future<List<RecentSearchModel>> getRecentSearches() async {
    final box = Hive.box<RecentSearchModel>(boxName);
    final allSearches = box.values.toList();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final validSearches = allSearches.where((search) {
      DateTime dateToCheck;
      try {
        if (search.isRoundTrip && search.returnDate != null) {
          dateToCheck = DateFormat('yyyy-MM-dd').parse(search.returnDate!);
        } else {
          dateToCheck = DateFormat('yyyy-MM-dd').parse(search.travelDate);
        }
      } catch (e) {
        return false;
      }

      // Keep only if date is today or in future
      return !dateToCheck.isBefore(today);
    }).toList();

    validSearches.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    // Return only the 3 most recent valid searches
    return validSearches.take(maxSearches).toList();
  }

  @override
  Future<void> deleteSearch(String id) async {
    final box = Hive.box<RecentSearchModel>(boxName);
    final keyToDelete = box.keys.cast<dynamic>().firstWhere(
      (key) => box.get(key)?.id == id,
      orElse: () => null,
    );

    if (keyToDelete != null) {
      await box.delete(keyToDelete);
    }
  }

  dynamic _findIdenticalSearchKey(
    Box<RecentSearchModel> box,
    RecentSearchModel search,
  ) {
    for (var key in box.keys) {
      final item = box.get(key);
      if (item != null &&
          item.fromGovernorate == search.fromGovernorate &&
          item.fromStationId == search.fromStationId &&
          item.toGovernorate == search.toGovernorate &&
          item.toStationId == search.toStationId &&
          item.travelDate == search.travelDate &&
          item.isRoundTrip == search.isRoundTrip &&
          item.returnDate == search.returnDate &&
          item.passengers == search.passengers) {
        return key;
      }
    }
    return null;
  }
}
