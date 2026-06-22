import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';

void main() {
  group('SearchParams.copyWith time filters', () {
    test('clears one time field while preserving the others', () {
      const params = SearchParams(
        travelDate: '2026-06-20',
        passengers: 1,
        fromDisplayName: 'Cairo',
        toDisplayName: 'Alexandria',
        departureFrom: TimeOfDay(hour: 8, minute: 0),
        departureTo: TimeOfDay(hour: 12, minute: 0),
        arrivalFrom: TimeOfDay(hour: 14, minute: 0),
      );

      final updated = params.copyWith(departureFrom: null);

      expect(updated.departureFrom, isNull);
      expect(updated.departureTo, params.departureTo);
      expect(updated.arrivalFrom, params.arrivalFrom);
      expect(updated.hasTimeFilters, isTrue);
    });

    test('clears all time fields when every field is passed as null', () {
      const params = SearchParams(
        travelDate: '2026-06-20',
        passengers: 1,
        fromDisplayName: 'Cairo',
        toDisplayName: 'Alexandria',
        departureFrom: TimeOfDay(hour: 8, minute: 0),
        departureTo: TimeOfDay(hour: 12, minute: 0),
        arrivalFrom: TimeOfDay(hour: 14, minute: 0),
        arrivalTo: TimeOfDay(hour: 18, minute: 0),
      );

      final updated = params.copyWith(
        departureFrom: null,
        departureTo: null,
        arrivalFrom: null,
        arrivalTo: null,
      );

      expect(updated.departureFrom, isNull);
      expect(updated.departureTo, isNull);
      expect(updated.arrivalFrom, isNull);
      expect(updated.arrivalTo, isNull);
      expect(updated.hasTimeFilters, isFalse);
    });

    test('clearTimeFilters clears all time fields', () {
      const params = SearchParams(
        travelDate: '2026-06-20',
        passengers: 1,
        fromDisplayName: 'Cairo',
        toDisplayName: 'Alexandria',
        departureFrom: TimeOfDay(hour: 8, minute: 0),
        departureTo: TimeOfDay(hour: 12, minute: 0),
        arrivalFrom: TimeOfDay(hour: 14, minute: 0),
        arrivalTo: TimeOfDay(hour: 18, minute: 0),
      );

      final updated = params.copyWith(clearTimeFilters: true);

      expect(updated.departureFrom, isNull);
      expect(updated.departureTo, isNull);
      expect(updated.arrivalFrom, isNull);
      expect(updated.arrivalTo, isNull);
      expect(updated.hasTimeFilters, isFalse);
    });
  });
}
