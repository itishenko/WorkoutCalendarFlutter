import 'package:flutter/foundation.dart';
import 'package:workout_calendar_flutter/core/utils/workout_formatters.dart';

@immutable
class WorkoutMetadata {
  const WorkoutMetadata({
    required this.workoutKey,
    required this.activityType,
    required this.startedAt,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.maxLayer,
    required this.maxSubLayer,
    required this.avgHumidity,
    required this.avgTemperature,
    required this.comment,
    required this.photoBefore,
    required this.photoAfter,
    required this.heartRateGraph,
    required this.activityGraph,
    required this.map,
  });

  factory WorkoutMetadata.fromJson(Map<String, dynamic> json) {
    return WorkoutMetadata(
      workoutKey: json['workoutKey'] as String? ?? '',
      activityType: json['workoutActivityType'] as String? ?? 'Unknown',
      startedAt: WorkoutFormatters.parseApiDate(
        json['workoutStartDate'] as String?,
      ),
      distanceMeters: double.tryParse(json['distance'] as String? ?? ''),
      durationSeconds: double.tryParse(json['duration'] as String? ?? ''),
      maxLayer: json['maxLayer'] as int? ?? 0,
      maxSubLayer: json['maxSubLayer'] as int? ?? 0,
      avgHumidity: double.tryParse(json['avg_humidity'] as String? ?? ''),
      avgTemperature: double.tryParse(json['avg_temp'] as String? ?? ''),
      comment: json['comment'] as String? ?? '',
      photoBefore: json['photoBefore'] as String?,
      photoAfter: json['photoAfter'] as String?,
      heartRateGraph: json['heartRateGraph'] as String?,
      activityGraph: json['activityGraph'] as String?,
      map: json['map'] as String?,
    );
  }

  final String workoutKey;
  final String activityType;
  final DateTime? startedAt;
  final double? distanceMeters;
  final double? durationSeconds;
  final int maxLayer;
  final int maxSubLayer;
  final double? avgHumidity;
  final double? avgTemperature;
  final String comment;
  final String? photoBefore;
  final String? photoAfter;
  final String? heartRateGraph;
  final String? activityGraph;
  final String? map;
}
