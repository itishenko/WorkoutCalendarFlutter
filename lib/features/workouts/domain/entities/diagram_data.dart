import 'package:flutter/foundation.dart';
import 'package:workout_calendar_flutter/core/utils/workout_formatters.dart';

@immutable
class DiagramData {
  const DiagramData({
    required this.description,
    required this.data,
    required this.states,
  });

  factory DiagramData.fromJson(Map<String, dynamic> json) {
    final rawPoints = json['data'] as List<dynamic>? ?? const <dynamic>[];
    final rawStates = json['states'] as List<dynamic>? ?? const <dynamic>[];

    return DiagramData(
      description: json['description'] as String? ?? '',
      data: rawPoints
          .map(
            (dynamic item) => DiagramPoint.fromJson(
              Map<String, dynamic>.from(item as Map<dynamic, dynamic>),
            ),
          )
          .toList(growable: false),
      states: rawStates.map((dynamic item) => item.toString()).toList(
            growable: false,
          ),
    );
  }

  final String description;
  final List<DiagramPoint> data;
  final List<String> states;
}

@immutable
class DiagramPoint {
  const DiagramPoint({
    required this.timeNumeric,
    required this.heartRate,
    required this.speedKmh,
    required this.distanceMeters,
    required this.steps,
    required this.elevation,
    required this.latitude,
    required this.longitude,
    required this.temperatureCelsius,
    required this.currentLayer,
    required this.currentSubLayer,
    required this.currentTimestamp,
  });

  factory DiagramPoint.fromJson(Map<String, dynamic> json) {
    return DiagramPoint(
      timeNumeric: json['time_numeric'] as int? ?? 0,
      heartRate: json['heartRate'] as int? ?? 0,
      speedKmh: (json['speed_kmh'] as num? ?? 0).toDouble(),
      distanceMeters: json['distanceMeters'] as int? ?? 0,
      steps: json['steps'] as int? ?? 0,
      elevation: (json['elevation'] as num? ?? 0).toDouble(),
      latitude: (json['latitude'] as num? ?? 0).toDouble(),
      longitude: (json['longitude'] as num? ?? 0).toDouble(),
      temperatureCelsius: (json['temperatureCelsius'] as num? ?? 0).toDouble(),
      currentLayer: json['currentLayer'] as int? ?? 0,
      currentSubLayer: json['currentSubLayer'] as int? ?? 0,
      currentTimestamp: WorkoutFormatters.parseApiDate(
        json['currentTimestamp'] as String?,
      ),
    );
  }

  final int timeNumeric;
  final int heartRate;
  final double speedKmh;
  final int distanceMeters;
  final int steps;
  final double elevation;
  final double latitude;
  final double longitude;
  final double temperatureCelsius;
  final int currentLayer;
  final int currentSubLayer;
  final DateTime? currentTimestamp;
}
