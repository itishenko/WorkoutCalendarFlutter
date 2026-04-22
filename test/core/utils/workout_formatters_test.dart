import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:workout_calendar_flutter/core/utils/workout_formatters.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en_US');
  });

  group('WorkoutFormatters', () {
    test('parses a valid API date', () {
      final result = WorkoutFormatters.parseApiDate('2025-11-25 09:30:00');

      expect(result, DateTime(2025, 11, 25, 9, 30));
    });

    test('returns null for an invalid API date', () {
      expect(WorkoutFormatters.parseApiDate('invalid-date'), isNull);
    });

    test('formats distance in kilometers and meters', () {
      expect(WorkoutFormatters.formatDistance(5230.5), '5.23 km');
      expect(WorkoutFormatters.formatDistance(800), '800 m');
      expect(WorkoutFormatters.formatDistance(0), '—');
    });

    test('formats duration with hours and minutes', () {
      expect(WorkoutFormatters.formatDuration(3660), '1 h 1 min');
      expect(WorkoutFormatters.formatDuration(300), '5 min');
      expect(WorkoutFormatters.formatDuration(null), '—');
    });

    test('formats English month title', () {
      expect(
        WorkoutFormatters.formatMonthYear(DateTime(2025, 11)),
        'November 2025',
      );
    });

    test('maps activity type to English label', () {
      expect(
        WorkoutFormatters.activityLabel('Walking/Running'),
        'Walking / Running',
      );
      expect(
        WorkoutFormatters.activityLabel('Strength'),
        'Strength Training',
      );
    });
  });
}
