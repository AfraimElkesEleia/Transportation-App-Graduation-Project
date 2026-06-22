import 'package:equatable/equatable.dart';

class RouteStopEntity extends Equatable {
  final String stationName;
  final String? arabicName;
  final String? governorateAr;
  final String? arrivalTime;
  final String? departureTime;
  final int stopSequence;

  const RouteStopEntity({
    required this.stationName,
    this.arabicName,
    this.governorateAr,
    required this.arrivalTime,
    required this.departureTime,
    required this.stopSequence,
  });

  String formatTime(String? timeValue) {
    if (timeValue == null || timeValue.isEmpty) return '--:--';
    if (timeValue.length >= 5) {
      return timeValue.substring(0, 5);
    }
    return timeValue;
  }

  String get displayTime => formatTime(departureTime ?? arrivalTime);
  bool get isOrigin => arrivalTime == '' && departureTime != '';
  bool get isDestination => departureTime == '' && arrivalTime != '';

  @override
  List<Object?> get props => [
    stationName,
    arabicName,
    governorateAr,
    arrivalTime,
    departureTime,
    stopSequence,
  ];
}
