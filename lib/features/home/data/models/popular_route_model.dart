import 'package:transportation_app/features/home/domain/entities/popular_route.dart';

class PopularRouteModel extends PopularRoute {
  const PopularRouteModel({
    required super.originGov,
    required super.destinationGov,
    required super.originGovAr,
    required super.originGovEn,
    required super.destinationGovAr,
    required super.destinationGovEn,
  });

  factory PopularRouteModel.fromJson(Map<String, dynamic> json) {
    final originGovAr = json['originGovAr'] as String? ?? '';
    final originGovEn = json['originGovEn'] as String? ?? '';
    final destinationGovAr = json['destinationGovAr'] as String? ?? '';
    final destinationGovEn = json['destinationGovEn'] as String? ?? '';

    return PopularRouteModel(
      originGov: json['originGov'] as String? ?? originGovEn,
      destinationGov: json['destinationGov'] as String? ?? destinationGovEn,
      originGovAr: originGovAr,
      originGovEn: originGovEn,
      destinationGovAr: destinationGovAr,
      destinationGovEn: destinationGovEn,
    );
  }
}

