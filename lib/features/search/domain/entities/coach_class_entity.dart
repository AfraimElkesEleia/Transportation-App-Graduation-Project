import 'package:equatable/equatable.dart';

class CoachClassEntity extends Equatable {
  final int    coachClassId;
  final String className;
  final int    remainingSeats;
  final double price;

  const CoachClassEntity({
    required this.coachClassId,
    required this.className,
    required this.remainingSeats,
    required this.price,
  });

  bool get hasSeats => remainingSeats > 0;

  @override
  List<Object> get props => [coachClassId];
}