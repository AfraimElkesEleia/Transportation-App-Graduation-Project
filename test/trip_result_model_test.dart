import 'package:flutter_test/flutter_test.dart';
import 'package:transportation_app/features/search/data/model/trip_result_model.dart';

void main() {
  group('TripResultModel.fromJson time mapping', () {
    test('uses boardingTime and dropoffTime for UI-facing times', () {
      final model = TripResultModel.fromJson(
        _tripJson(
          boardingTime: '2026-03-20T07:20:00',
          dropoffTime: '2026-03-20T10:00:00',
          departureTime: '2026-03-20T07:00:00',
          arrivalTime: '2026-03-20T10:40:00',
        ),
      );

      expect(model.departureTime, DateTime(2026, 3, 20, 7, 20));
      expect(model.arrivalTime, DateTime(2026, 3, 20, 10));
    });

    test('ignores occurrence-level departureTime and arrivalTime', () {
      final model = TripResultModel.fromJson(
        _tripJson(
          boardingTime: '2026-03-20T06:30:00',
          dropoffTime: '2026-03-20T09:30:00',
          departureTime: '2026-03-20T06:00:00',
          arrivalTime: '2026-03-20T10:00:00',
        ),
      );

      expect(model.departureTime, isNot(DateTime(2026, 3, 20, 6)));
      expect(model.arrivalTime, isNot(DateTime(2026, 3, 20, 10)));
      expect(model.departureTime, DateTime(2026, 3, 20, 6, 30));
      expect(model.arrivalTime, DateTime(2026, 3, 20, 9, 30));
    });

    test('sets arrivalTime to null when dropoffTime is missing', () {
      final model = TripResultModel.fromJson(
        _tripJson(
          boardingTime: '2026-03-20T07:20:00',
          dropoffTime: null,
          departureTime: '2026-03-20T07:00:00',
          arrivalTime: '2026-03-20T10:40:00',
        ),
      );

      expect(model.departureTime, DateTime(2026, 3, 20, 7, 20));
      expect(model.arrivalTime, isNull);
    });
  });
}

Map<String, dynamic> _tripJson({
  required String boardingTime,
  required String? dropoffTime,
  required String departureTime,
  required String arrivalTime,
}) {
  return {
    'tripOccurrenceId': 10,
    'tripId': 20,
    'agencyName': 'GoBus',
    'agencyNameAr': 'جو باص',
    'boardingTime': boardingTime,
    'dropoffTime': dropoffTime,
    'departureTime': departureTime,
    'arrivalTime': arrivalTime,
    'totalDurationMinutes': 160,
    'originStationId': 1,
    'originStationName': 'Ramses',
    'originStationNameAr': 'رمسيس',
    'originGovernorate': 'Cairo',
    'originGovernorateAr': 'القاهرة',
    'destinationStationId': 2,
    'destinationStationName': 'Sidi Gaber',
    'destinationStationNameAr': 'سيدي جابر',
    'destinationGovernorate': 'Alexandria',
    'destinationGovernorateAr': 'الاسكندرية',
    'availableClasses': [
      {
        'coachClassId': 1,
        'className': 'Business',
        'classNameAr': 'درجة رجال الاعمال',
        'remainingSeats': 12,
        'price': 180.0,
      },
    ],
    'routeStops': const [],
  };
}
