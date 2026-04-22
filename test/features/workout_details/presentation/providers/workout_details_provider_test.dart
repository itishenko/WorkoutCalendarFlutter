import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_calendar_flutter/core/errors/app_exception.dart';
import 'package:workout_calendar_flutter/features/workout_details/presentation/providers/workout_details_provider.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/entities/diagram_data.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/entities/workout_metadata.dart';
import 'package:workout_calendar_flutter/shared/providers/app_providers.dart';

import '../../../../support/fake_workout_repository.dart';
import '../../../../support/sample_data.dart';

void main() {
  group('workoutDetailsProvider', () {
    test('loads detail state with formatted values', () async {
      final repository = FakeWorkoutRepository(
        metadata: <String, WorkoutMetadata>{
          'w1': sampleMetadata(),
        },
        diagramData: <String, DiagramData>{
          'w1': sampleDiagramData(heartRates: const <int>[72, 76, 81]),
        },
      );

      final container = ProviderContainer(
        overrides: [
          workoutRepositoryProvider.overrideWith((Ref ref) => repository),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(workoutDetailsProvider('w1').future);

      expect(state.title, 'Walking / Running');
      expect(state.distanceLabel, '5.23 km');
      expect(state.durationLabel, '45 min');
      expect(state.averageHeartRate, 76);
      expect(state.maxHeartRate, 81);
    });

    test('throws AppException when workout is missing', () async {
      final container = ProviderContainer(
        overrides: [
          workoutRepositoryProvider.overrideWith(
            (Ref ref) => FakeWorkoutRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(workoutDetailsProvider('missing').future),
        throwsA(isA<AppException>()),
      );
    });
  });
}
