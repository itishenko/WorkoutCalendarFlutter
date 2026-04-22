import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_calendar_flutter/features/calendar/presentation/controllers/calendar_controller.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/entities/workout.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/entities/workout_metadata.dart';
import 'package:workout_calendar_flutter/shared/providers/app_providers.dart';

import '../../../../support/fake_workout_repository.dart';
import '../../../../support/sample_data.dart';

void main() {
  group('CalendarController', () {
    test('opens on the most recent workout month and day', () async {
      final repository = FakeWorkoutRepository(
        workouts: <Workout>[
          sampleWorkout(
            workoutKey: 'w1',
            startedAt: DateTime(2025, 11, 24, 7, 15),
          ),
          sampleWorkout(
            workoutKey: 'w2',
            startedAt: DateTime(2025, 11, 25, 9, 30),
          ),
          sampleWorkout(
            workoutKey: 'w3',
            startedAt: DateTime(2025, 11, 25, 18),
          ),
        ],
        metadata: <String, WorkoutMetadata>{
          'w1': sampleMetadata(workoutKey: 'w1'),
          'w2': sampleMetadata(workoutKey: 'w2'),
          'w3': sampleMetadata(workoutKey: 'w3'),
        },
      );

      final container = ProviderContainer(
        overrides: [
          workoutRepositoryProvider.overrideWith((Ref ref) => repository),
          currentDateProvider.overrideWith(
            (Ref ref) => () => DateTime(2026, 4, 22),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(calendarControllerProvider.future);

      expect(state.currentMonth, DateTime(2025, 11));
      expect(state.selectedDate, DateTime(2025, 11, 25));
      expect(state.selectedDayWorkoutCount, 2);
    });

    test('shifts month and keeps the selected day clamped', () async {
      final repository = FakeWorkoutRepository(
        workouts: <Workout>[
          sampleWorkout(startedAt: DateTime(2025, 11, 25, 9, 30)),
        ],
        metadata: <String, WorkoutMetadata>{
          'w1': sampleMetadata(),
        },
      );

      final container = ProviderContainer(
        overrides: [
          workoutRepositoryProvider.overrideWith((Ref ref) => repository),
          currentDateProvider.overrideWith(
            (Ref ref) => () => DateTime(2026, 4, 22),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(calendarControllerProvider.future);
      container.read(calendarControllerProvider.notifier).goToPreviousMonth();

      final updatedState = container.read(calendarControllerProvider).requireValue;

      expect(updatedState.currentMonth, DateTime(2025, 10));
      expect(updatedState.selectedDate, DateTime(2025, 10, 25));
    });

    test('selectDate updates visible month and selected day', () async {
      final repository = FakeWorkoutRepository(
        workouts: <Workout>[
          sampleWorkout(
            workoutKey: 'w1',
            startedAt: DateTime(2025, 11, 24, 7, 15),
          ),
          sampleWorkout(
            workoutKey: 'w2',
            startedAt: DateTime(2025, 11, 24, 17, 45),
          ),
        ],
        metadata: <String, WorkoutMetadata>{
          'w1': sampleMetadata(workoutKey: 'w1'),
          'w2': sampleMetadata(workoutKey: 'w2'),
        },
      );

      final container = ProviderContainer(
        overrides: [
          workoutRepositoryProvider.overrideWith((Ref ref) => repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(calendarControllerProvider.future);
      container
          .read(calendarControllerProvider.notifier)
          .selectDate(DateTime(2025, 11, 24));

      final updatedState = container.read(calendarControllerProvider).requireValue;

      expect(updatedState.selectedDate, DateTime(2025, 11, 24));
      expect(updatedState.currentMonth, DateTime(2025, 11));
      expect(updatedState.selectedDayWorkoutCount, 2);
    });
  });
}
