import 'package:flutter/foundation.dart';
import 'package:workout_calendar_flutter/core/extensions/date_time_x.dart';
import 'package:workout_calendar_flutter/core/utils/month_grid_builder.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/entities/workout.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/entities/workout_metadata.dart';

@immutable
class CalendarState {
  const CalendarState({
    required this.currentMonth,
    required this.selectedDate,
    required this.workouts,
    required this.metadataByWorkoutKey,
  });

  final DateTime currentMonth;
  final DateTime selectedDate;
  final List<Workout> workouts;
  final Map<String, WorkoutMetadata> metadataByWorkoutKey;

  List<DateTime?> get daysInMonth => MonthGridBuilder.build(currentMonth);

  List<Workout> get selectedDayWorkouts {
    final result = workouts.where((Workout workout) {
      final workoutDate = workout.startedAt;
      return workoutDate != null && workoutDate.isSameDay(selectedDate);
    }).toList();

    result.sort((Workout left, Workout right) {
      final leftDate = left.startedAt ?? selectedDate;
      final rightDate = right.startedAt ?? selectedDate;
      return leftDate.compareTo(rightDate);
    });

    return result;
  }

  int get currentMonthWorkoutCount {
    return workouts.where((Workout workout) {
      final workoutDate = workout.startedAt;
      return workoutDate != null && workoutDate.isSameMonth(currentMonth);
    }).length;
  }

  int get selectedDayWorkoutCount => selectedDayWorkouts.length;

  bool isSelected(DateTime date) => date.isSameDay(selectedDate);

  bool hasWorkouts(DateTime date) {
    return workouts.any((Workout workout) {
      final workoutDate = workout.startedAt;
      return workoutDate != null && workoutDate.isSameDay(date);
    });
  }

  WorkoutMetadata? metadataFor(String workoutKey) {
    return metadataByWorkoutKey[workoutKey];
  }

  CalendarState copyWith({
    DateTime? currentMonth,
    DateTime? selectedDate,
    List<Workout>? workouts,
    Map<String, WorkoutMetadata>? metadataByWorkoutKey,
  }) {
    return CalendarState(
      currentMonth: currentMonth ?? this.currentMonth,
      selectedDate: selectedDate ?? this.selectedDate,
      workouts: workouts ?? this.workouts,
      metadataByWorkoutKey: metadataByWorkoutKey ?? this.metadataByWorkoutKey,
    );
  }
}
