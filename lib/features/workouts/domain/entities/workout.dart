import 'package:flutter/foundation.dart';
import 'package:workout_calendar_flutter/core/utils/workout_formatters.dart';

@immutable
class Workout {
  const Workout({
    required this.workoutKey,
    required this.activityType,
    required this.startedAt,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      workoutKey: json['workoutKey'] as String? ?? '',
      activityType: json['workoutActivityType'] as String? ?? 'Unknown',
      startedAt: WorkoutFormatters.parseApiDate(
        json['workoutStartDate'] as String?,
      ),
    );
  }

  final String workoutKey;
  final String activityType;
  final DateTime? startedAt;
}
