import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';

class CoachClassModel extends CoachClassEntity {
  const CoachClassModel({
    required super.coachClassId,
    required super.className,
    required super.remainingSeats,
    required super.price,
  });

  factory CoachClassModel.fromJson(Map<String, dynamic> json) {
    return CoachClassModel(
      coachClassId: json['coachClassId'] as int,
      className: json['className'] as String? ?? '', 
      remainingSeats: json['remainingSeats'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }
}
