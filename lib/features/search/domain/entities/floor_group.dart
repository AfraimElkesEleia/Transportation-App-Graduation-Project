import 'package:equatable/equatable.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';

/// Represents one floor of a bus with all its seat type classes.
///
/// Example — Floor 2 with Single + Double:
///   floorNumber = 2
///   classes = [
///     CoachClassEntity(className: "...Floor 2 Single",  remainingSeats: 16, price: 590)
///     CoachClassEntity(className: "...Floor 2 Double",  remainingSeats: 24, price: 590)
///   ]
///   totalSeats  = 40
///   lowestPrice = 590
///   hasMultipleSeatTypes = true
class FloorGroup extends Equatable {
  final String groupName;
  final int? floorNumber;
  final List<CoachClassEntity> classes;

  const FloorGroup({required this.groupName, required this.floorNumber, required this.classes});
  String get label => floorNumber != null ? 'Floor $floorNumber' : 'Standard';

  int get totalSeats => classes.fold(0, (sum, c) => sum + c.remainingSeats);

  bool get hasSeats => classes.any((c) => c.hasSeats);

  double get lowestPrice => classes.isEmpty
      ? 0
      : classes.map((c) => c.price).reduce((a, b) => a < b ? a : b);

  bool get hasMultipleSeatTypes => classes.length > 1;

  Map<String, int> get seatCountBySeatType {
    final map = <String, int>{};
    for (final cls in classes) {
      map[cls.seatType] = (map[cls.seatType] ?? 0) + cls.remainingSeats;
    }
    return map;
  }

  CoachClassEntity? classForSeatType(String seatType) {
    try {
      return classes.firstWhere(
        (c) => c.seatType.toLowerCase() == seatType.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [floorNumber, classes];
}
