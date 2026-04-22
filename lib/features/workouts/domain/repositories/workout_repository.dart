import 'package:workout_calendar_flutter/features/workouts/domain/entities/diagram_data.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/entities/workout.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/entities/workout_metadata.dart';

abstract class WorkoutRepository {
  Future<List<Workout>> fetchWorkouts();

  Future<WorkoutMetadata?> fetchMetadata(String workoutKey);

  Future<Map<String, WorkoutMetadata>> fetchAllMetadata();

  Future<DiagramData?> fetchDiagramData(String workoutKey);
}
