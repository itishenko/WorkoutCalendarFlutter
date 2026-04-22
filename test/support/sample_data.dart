import 'package:workout_calendar_flutter/features/workouts/domain/entities/diagram_data.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/entities/workout.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/entities/workout_metadata.dart';

Workout sampleWorkout({
  String workoutKey = 'w1',
  String activityType = 'Walking/Running',
  DateTime? startedAt,
}) {
  return Workout(
    workoutKey: workoutKey,
    activityType: activityType,
    startedAt: startedAt ?? DateTime(2025, 11, 25, 9, 30),
  );
}

WorkoutMetadata sampleMetadata({
  String workoutKey = 'w1',
  String activityType = 'Walking/Running',
  DateTime? startedAt,
  double? distanceMeters = 5230.5,
  double? durationSeconds = 2700,
  double? avgHumidity = 65,
  double? avgTemperature = 12.5,
  String comment = 'Morning run',
}) {
  return WorkoutMetadata(
    workoutKey: workoutKey,
    activityType: activityType,
    startedAt: startedAt ?? DateTime(2025, 11, 25, 9, 30),
    distanceMeters: distanceMeters,
    durationSeconds: durationSeconds,
    maxLayer: 2,
    maxSubLayer: 4,
    avgHumidity: avgHumidity,
    avgTemperature: avgTemperature,
    comment: comment,
    photoBefore: null,
    photoAfter: null,
    heartRateGraph: null,
    activityGraph: null,
    map: null,
  );
}

DiagramData sampleDiagramData({
  String description = 'Test chart',
  List<int> heartRates = const <int>[72, 75, 79, 82],
}) {
  return DiagramData(
    description: description,
    data: heartRates.asMap().entries.map((entry) {
      final index = entry.key;
      final heartRate = entry.value;

      return DiagramPoint(
        timeNumeric: index * 60,
        heartRate: heartRate,
        speedKmh: 10 + index.toDouble(),
        distanceMeters: index * 250,
        steps: index * 300,
        elevation: 15 + index.toDouble(),
        latitude: 55.0,
        longitude: 37.0,
        temperatureCelsius: 12.5,
        currentLayer: 0,
        currentSubLayer: 0,
        currentTimestamp: DateTime(2025, 11, 25, 9, 30 + index),
      );
    }).toList(growable: false),
    states: const <String>[],
  );
}
