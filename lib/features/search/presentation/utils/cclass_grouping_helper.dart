import '../../domain/entities/coach_class_entity.dart';

class FloorClassSummary {
  final String floorName;
  final int totalSeats;
  final int singleSeats;
  final int doubleSeats;
  final double lowestPrice;
  final List<CoachClassEntity> sourceClasses; 

  FloorClassSummary({
    required this.floorName,
    required this.sourceClasses,
  })  : totalSeats = sourceClasses.fold(0, (sum, c) => sum + c.remainingSeats),
        singleSeats = sourceClasses
            .where((c) => c.className.toLowerCase().contains('single'))
            .fold(0, (sum, c) => sum + c.remainingSeats),
        doubleSeats = sourceClasses
            .where((c) => c.className.toLowerCase().contains('double'))
            .fold(0, (sum, c) => sum + c.remainingSeats),
        lowestPrice = sourceClasses.isEmpty
            ? 0
            : sourceClasses.map((c) => c.price).reduce((a, b) => a < b ? a : b);

  bool get hasSeats => totalSeats > 0;

  String get seatBreakdown {
    final parts = <String>[];
    if (singleSeats > 0) parts.add('$singleSeats Single');
    if (doubleSeats > 0) parts.add('$doubleSeats Double');
    return parts.isNotEmpty ? parts.join(', ') : '$totalSeats seats';
  }
}

class ClassGroupingHelper {
  /// Groups raw class list by Floor Name
  static List<FloorClassSummary> groupByFloor(List<CoachClassEntity> classes) {
    final Map<String, List<CoachClassEntity>> grouped = {};

    for (final cls in classes) {
      final floorName = _extractFloorBaseName(cls.className);
      grouped.putIfAbsent(floorName, () => []);
      grouped[floorName]!.add(cls);
    }

    // Convert to List and Sort by Floor Number
    final summaries = grouped.entries
        .map((entry) => FloorClassSummary(
              floorName: entry.key,
              sourceClasses: entry.value,
            ))
        .toList();

    summaries.sort((a, b) {
      final aNum = _extractFloorNumber(a.floorName);
      final bNum = _extractFloorNumber(b.floorName);
      return aNum.compareTo(bNum);
    });

    return summaries;
  }

  static String _extractFloorBaseName(String className) {
    final parts = className.split(' - ');
    final filtered = parts.where((part) {
      final trimmed = part.trim();
      return !trimmed.toLowerCase().contains('single') &&
          !trimmed.toLowerCase().contains('double');
    });
    final result = filtered.join(' - ').trim();
    return result.isEmpty ? className : result;
  }

  static int _extractFloorNumber(String name) {
    final match = RegExp(r'Floor\s*(\d+)').firstMatch(name);
    return match != null ? int.parse(match.group(1)!) : 0;
  }
}