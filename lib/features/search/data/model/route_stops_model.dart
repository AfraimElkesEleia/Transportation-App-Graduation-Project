class RouteStopsModel {
  final String stationName;
  final String? arrivalTime;
  final String? departureTime;
  final int stopSequence;

  RouteStopsModel({
    required this.stationName,
    required this.arrivalTime,
    required this.departureTime,
    required this.stopSequence,
  });
  factory RouteStopsModel.fromJson(Map<String, dynamic> json) {
    return RouteStopsModel(
      stationName: json['stationName'] as String? ?? '',
      arrivalTime: json['arrivalTime'] as String? ?? '',
      departureTime: json['departureTime'] as String? ?? '',
      stopSequence: json['stopSequence'] as int,
    );
  }
  String formatTime(String? timeValue) {
    if (timeValue == null || timeValue.isEmpty) return '--:--';
    if (timeValue.length >= 5) {
      return timeValue.substring(0, 5);
    }
    return timeValue; // fallback for edge cases
  }

  String get displayTime => formatTime(departureTime ?? arrivalTime);
  bool get isOrigin => arrivalTime == '' && departureTime != '';
  bool get isDestination => departureTime == '' && arrivalTime != '';
}
