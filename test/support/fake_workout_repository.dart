import 'package:workout_calendar_flutter/features/workouts/domain/entities/diagram_data.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/entities/workout.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/entities/workout_metadata.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/repositories/workout_repository.dart';

class FakeWorkoutRepository implements WorkoutRepository {
  FakeWorkoutRepository({
    this.workouts = const <Workout>[],
    this.metadata = const <String, WorkoutMetadata>{},
    this.diagramData = const <String, DiagramData>{},
  });

  final List<Workout> workouts;
  final Map<String, WorkoutMetadata> metadata;
  final Map<String, DiagramData> diagramData;

  @override
  Future<List<Workout>> fetchWorkouts() async => workouts;

  @override
  Future<WorkoutMetadata?> fetchMetadata(String workoutKey) async {
    return metadata[workoutKey];
  }

  @override
  Future<Map<String, WorkoutMetadata>> fetchAllMetadata() async => metadata;

  @override
  Future<DiagramData?> fetchDiagramData(String workoutKey) async {
    return diagramData[workoutKey];
  }
}
