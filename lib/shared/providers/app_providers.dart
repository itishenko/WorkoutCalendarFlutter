import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_calendar_flutter/features/workouts/data/repositories/asset_workout_repository.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/repositories/workout_repository.dart';

typedef DateTimeFactory = DateTime Function();

final assetBundleProvider = Provider<AssetBundle>((Ref ref) {
  return rootBundle;
});

final currentDateProvider = Provider<DateTimeFactory>((Ref ref) {
  return DateTime.now;
});

final workoutRepositoryProvider = Provider<WorkoutRepository>((Ref ref) {
  final assetBundle = ref.watch(assetBundleProvider);
  return AssetWorkoutRepository(assetBundle: assetBundle);
});
