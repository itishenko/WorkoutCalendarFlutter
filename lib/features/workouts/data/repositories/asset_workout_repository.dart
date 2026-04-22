import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:workout_calendar_flutter/core/constants/app_assets.dart';
import 'package:workout_calendar_flutter/core/errors/app_exception.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/entities/diagram_data.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/entities/workout.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/entities/workout_metadata.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/repositories/workout_repository.dart';

class AssetWorkoutRepository implements WorkoutRepository {
  AssetWorkoutRepository({required AssetBundle assetBundle})
      : _assetBundle = assetBundle;

  final AssetBundle _assetBundle;

  List<Workout>? _workoutsCache;
  Map<String, WorkoutMetadata>? _metadataCache;
  Map<String, DiagramData>? _diagramCache;

  @override
  Future<List<Workout>> fetchWorkouts() async {
    if (_workoutsCache != null) {
      return _workoutsCache!;
    }

    final json = await _loadJsonMap(AppAssets.workouts);
    final rawItems = json['data'];

    if (rawItems is! List<dynamic>) {
      throw const AppException(
        'The workout list file has an invalid format.',
      );
    }

    _workoutsCache = rawItems
        .map(
          (dynamic item) => Workout.fromJson(
            Map<String, dynamic>.from(item as Map<dynamic, dynamic>),
          ),
        )
        .toList(growable: false);

    return _workoutsCache!;
  }

  @override
  Future<WorkoutMetadata?> fetchMetadata(String workoutKey) async {
    final metadata = await fetchAllMetadata();
    return metadata[workoutKey];
  }

  @override
  Future<Map<String, WorkoutMetadata>> fetchAllMetadata() async {
    if (_metadataCache != null) {
      return _metadataCache!;
    }

    final json = await _loadJsonMap(AppAssets.metadata);
    final rawWorkouts = json['workouts'];

    if (rawWorkouts is! Map<dynamic, dynamic>) {
      throw const AppException(
        'The workout metadata file has an invalid format.',
      );
    }

    _metadataCache = rawWorkouts.map(
      (dynamic key, dynamic value) => MapEntry<String, WorkoutMetadata>(
        key.toString(),
        WorkoutMetadata.fromJson(
          Map<String, dynamic>.from(value as Map<dynamic, dynamic>),
        ),
      ),
    );

    return _metadataCache!;
  }

  @override
  Future<DiagramData?> fetchDiagramData(String workoutKey) async {
    if (_diagramCache == null) {
      final json = await _loadJsonMap(AppAssets.diagramData);
      final rawWorkouts = json['workouts'];

      if (rawWorkouts is! Map<dynamic, dynamic>) {
        throw const AppException(
          'The workout chart file has an invalid format.',
        );
      }

      _diagramCache = rawWorkouts.map(
        (dynamic key, dynamic value) => MapEntry<String, DiagramData>(
          key.toString(),
          DiagramData.fromJson(
            Map<String, dynamic>.from(value as Map<dynamic, dynamic>),
          ),
        ),
      );
    }

    return _diagramCache![workoutKey];
  }

  Future<Map<String, dynamic>> _loadJsonMap(String assetPath) async {
    try {
      final rawJson = await _assetBundle.loadString(assetPath);
      final decoded = jsonDecode(rawJson);

      if (decoded is! Map<dynamic, dynamic>) {
        throw const AppException('The root JSON value must be an object.');
      }

      return Map<String, dynamic>.from(decoded);
    } on AppException {
      rethrow;
    } catch (_) {
      throw AppException('Failed to load data from $assetPath.');
    }
  }
}
