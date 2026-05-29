import 'package:equatable/equatable.dart';

class CoachClassEntity extends Equatable {
  final int coachClassId;
  final String className;
  final String? classNameAr;
  final int remainingSeats;
  final double price;

  const CoachClassEntity({
    required this.coachClassId,
    required this.className,
    this.classNameAr,
    required this.remainingSeats,
    required this.price,
  });

  bool get hasSeats => remainingSeats > 0;
  int? get floorNumber {
    final match = RegExp(r'[Ff]loor\s*(\d+)').firstMatch(className);
    return match != null ? int.tryParse(match.group(1) ?? '') : null;
  }

  String get seatType {
    final match = RegExp(r'[Ff]loor\s*\d+\s+(\w+)').firstMatch(className);
    if (match != null) return match.group(1) ?? '';
    final parts = className.trim().split(RegExp(r'[\s\-]+'));
    return parts.isNotEmpty ? parts.last : className;
  }

  String get groupName {
    final idx = className.toLowerCase().indexOf('floor');

    String raw;
    if (idx > 0) {
      raw = className.substring(0, idx);
    } else {
      raw = className; // full name — Arabic or no floor pattern
    }

    return raw
        .replaceAll(
          RegExp(r'\s*-\s*$'),
          '',
        ) // 1. Clean up the trailing dash at the end
        .replaceAll(
          RegExp(r'\s*-\s*'),
          '\n',
        ) // 2. FORCE newline on ANY dash, ignoring weird spaces
        .trim();
  }

  @override
  List<Object> get props => [coachClassId];
}
