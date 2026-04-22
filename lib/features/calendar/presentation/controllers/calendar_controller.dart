import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_calendar_flutter/core/extensions/date_time_x.dart';
import 'package:workout_calendar_flutter/features/calendar/presentation/controllers/calendar_state.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/entities/workout.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/repositories/workout_repository.dart';
import 'package:workout_calendar_flutter/shared/providers/app_providers.dart';

final calendarControllerProvider =
    AsyncNotifierProvider<CalendarController, CalendarState>(
  CalendarController.new,
);

class CalendarController extends AsyncNotifier<CalendarState> {
  WorkoutRepository get _repository => ref.read(workoutRepositoryProvider);

  DateTime Function() get _now => ref.read(currentDateProvider);

  @override
  Future<CalendarState> build() => _load();

  Future<void> reload() async {
    state = const AsyncLoading<CalendarState>();
    state = await AsyncValue.guard(_load);
  }

  void goToPreviousMonth() => _shiftMonth(-1);

  void goToNextMonth() => _shiftMonth(1);

  void selectDate(DateTime date) {
    final currentState = state.asData?.value;
    if (currentState == null) {
      return;
    }

    final normalizedDate = date.startOfDay;
    state = AsyncData<CalendarState>(
      currentState.copyWith(
        currentMonth: normalizedDate.monthStart,
        selectedDate: normalizedDate,
      ),
    );
  }

  Future<CalendarState> _load() async {
    final workouts = await _repository.fetchWorkouts();
    final metadata = await _repository.fetchAllMetadata();
    final anchorDate = _resolveAnchorDate(workouts);

    return CalendarState(
      currentMonth: anchorDate.monthStart,
      selectedDate: anchorDate,
      workouts: workouts,
      metadataByWorkoutKey: metadata,
    );
  }

  DateTime _resolveAnchorDate(List<Workout> workouts) {
    final workoutDates = workouts
        .map((Workout workout) => workout.startedAt)
        .whereType<DateTime>()
        .toList();

    if (workoutDates.isEmpty) {
      return _now().startOfDay;
    }

    workoutDates.sort();
    return workoutDates.last.startOfDay;
  }

  void _shiftMonth(int delta) {
    final currentState = state.asData?.value;
    if (currentState == null) {
      return;
    }

    final nextSelectedDate = currentState.selectedDate.shiftMonthClamped(delta);

    state = AsyncData<CalendarState>(
      currentState.copyWith(
        currentMonth: nextSelectedDate.monthStart,
        selectedDate: nextSelectedDate.startOfDay,
      ),
    );
  }
}
