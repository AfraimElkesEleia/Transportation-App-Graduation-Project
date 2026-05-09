import 'package:transportation_app/features/home/domain/entities/page_result_entity.dart';
import 'package:transportation_app/features/search/data/model/trip_result_model.dart';

class PageResultModel<T> extends PagedResultEntity {
  PageResultModel({
    required super.items,
    required super.totalCount,
    required super.totalPages,
    required super.currentPage,
    required super.pageSize,
  });
  factory PageResultModel.fromJson(dynamic json) {
    final data = json['data'] as Map<String, dynamic>;
    return PageResultModel(
      items: (data['items'] as List<dynamic>? ?? [])
          .map((t) => TripResultModel.fromJson(t as Map<String, dynamic>))
          .toList(),
      totalCount: data['totalCount'] as int,
      totalPages: data['totalPages'] as int,
      currentPage: data['currentPage'] as int,
      pageSize: data['pageSize'] as int,
    );
  }
}
