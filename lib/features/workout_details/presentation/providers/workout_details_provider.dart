import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_calendar_flutter/core/constants/app_strings.dart';
import 'package:workout_calendar_flutter/core/errors/app_exception.dart';
import 'package:workout_calendar_flutter/core/utils/workout_formatters.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/entities/diagram_data.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/entities/workout_metadata.dart';
import 'package:workout_calendar_flutter/shared/providers/app_providers.dart';

@immutable
class WorkoutDetailsState {
  const WorkoutDetailsState({
    required this.workoutKey,
    required this.metadata,
    required this.diagramData,
  });

  final String workoutKey;
  final WorkoutMetadata metadata;
  final DiagramData? diagramData;

  String get title => WorkoutFormatters.activityLabel(metadata.activityType);

  String get dateTimeLabel => WorkoutFormatters.formatLongDateTime(
        metadata.startedAt,
      );

  String get description {
    if (metadata.comment.trim().isEmpty) {
      return AppStrings.noDescription;
    }

    return metadata.comment;
  }

  String get distanceLabel => WorkoutFormatters.formatDistance(
        metadata.distanceMeters,
      );

  String get durationLabel => WorkoutFormatters.formatDuration(
        metadata.durationSeconds,
      );

  String get temperatureLabel => WorkoutFormatters.formatTemperature(
        metadata.avgTemperature,
      );

  String get humidityLabel => WorkoutFormatters.formatHumidity(
        metadata.avgHumidity,
      );

  int get averageHeartRate {
    final points = diagramData?.data ?? const <DiagramPoint>[];
    if (points.isEmpty) {
      return 0;
    }

    final total = points.fold<int>(
      0,
      (int sum, DiagramPoint point) => sum + point.heartRate,
    );
    return total ~/ points.length;
  }

  int get maxHeartRate {
    final points = diagramData?.data ?? const <DiagramPoint>[];
    if (points.isEmpty) {
      return 0;
    }

    return points
        .map((DiagramPoint point) => point.heartRate)
        .reduce((int left, int right) => left > right ? left : right);
  }
}

final workoutDetailsProvider =
    FutureProvider.autoDispose.family<WorkoutDetailsState, String>(
  (ref, workoutKey) async {
    final repository = ref.watch(workoutRepositoryProvider);
    final metadata = await repository.fetchMetadata(workoutKey);

    if (metadata == null) {
      throw const AppException(AppStrings.workoutNotFound);
    }

    final diagramData = await repository.fetchDiagramData(workoutKey);

    return WorkoutDetailsState(
      workoutKey: workoutKey,
      metadata: metadata,
      diagramData: diagramData,
    );
  },
);
