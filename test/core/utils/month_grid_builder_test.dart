import 'package:flutter_test/flutter_test.dart';
import 'package:workout_calendar_flutter/core/utils/month_grid_builder.dart';

void main() {
  group('MonthGridBuilder', () {
    test('builds November 2025 with Monday-first offset', () {
      final result = MonthGridBuilder.build(DateTime(2025, 11));

      expect(result, hasLength(35));
      expect(result.whereType<DateTime>(), hasLength(30));
      expect(result.indexWhere((DateTime? date) => date != null), 5);
      expect(result.firstWhere((DateTime? date) => date != null), DateTime(2025, 11, 1));
    });

    test('pads trailing cells until the week is complete', () {
      final result = MonthGridBuilder.build(DateTime(2025, 2));

      expect(result.length % 7, 0);
      expect(result.whereType<DateTime>(), hasLength(28));
    });
  });
}
