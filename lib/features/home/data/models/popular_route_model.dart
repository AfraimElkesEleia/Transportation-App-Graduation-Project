import 'package:transportation_app/features/home/domain/entities/popular_route.dart';

class PopularRouteModel extends PopularRoute {
  const PopularRouteModel({
    required super.originGov,
    required super.destinationGov,
  });

  factory PopularRouteModel.fromJson(Map<String, dynamic> json) {
    return PopularRouteModel(
      originGov: json['originGov'] as String? ?? '',
      destinationGov: json['destinationGov'] as String? ?? '',
    );
  }
}

