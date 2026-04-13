import 'package:equatable/equatable.dart';

class StationEntity extends Equatable {
  final int    id;
  final String arabicName;
  final String englishName;
  final String slug;
  final String city;

  const StationEntity({
    required this.id,
    required this.arabicName,
    required this.englishName,
    required this.slug,
    required this.city,
  });

  String get displayName => '$englishName ($arabicName)';

  @override
  List<Object> get props => [id];
}