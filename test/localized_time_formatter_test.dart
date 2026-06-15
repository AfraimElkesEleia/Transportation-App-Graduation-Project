import 'package:flutter_test/flutter_test.dart';
import 'package:transportation_app/core/utils/localized_time_formatter.dart';

void main() {
  group('formatLocalizedTime', () {
    test('formats English 12-hour times with AM and PM', () {
      expect(
        formatLocalizedTime(
          DateTime(2026, 6, 15, 0, 5),
          amLabel: 'AM',
          pmLabel: 'PM',
        ),
        '12:05 AM',
      );
      expect(
        formatLocalizedTime(
          DateTime(2026, 6, 15, 12),
          amLabel: 'AM',
          pmLabel: 'PM',
        ),
        '12:00 PM',
      );
      expect(
        formatLocalizedTime(
          DateTime(2026, 6, 15, 13, 30),
          amLabel: 'AM',
          pmLabel: 'PM',
        ),
        '01:30 PM',
      );
      expect(
        formatLocalizedTime(
          DateTime(2026, 6, 15, 23, 59),
          amLabel: 'AM',
          pmLabel: 'PM',
        ),
        '11:59 PM',
      );
    });

    test('formats Arabic 12-hour times with localized period labels', () {
      expect(
        formatLocalizedTime(
          DateTime(2026, 6, 15, 0, 5),
          amLabel: 'ص',
          pmLabel: 'م',
        ),
        '12:05 ص',
      );
      expect(
        formatLocalizedTime(
          DateTime(2026, 6, 15, 12),
          amLabel: 'ص',
          pmLabel: 'م',
        ),
        '12:00 م',
      );
      expect(
        formatLocalizedTime(
          DateTime(2026, 6, 15, 13, 30),
          amLabel: 'ص',
          pmLabel: 'م',
        ),
        '01:30 م',
      );
      expect(
        formatLocalizedTime(
          DateTime(2026, 6, 15, 23, 59),
          amLabel: 'ص',
          pmLabel: 'م',
        ),
        '11:59 م',
      );
    });
  });
}
