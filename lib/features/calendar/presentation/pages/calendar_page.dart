import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_calendar_flutter/app/router/app_router.dart';
import 'package:workout_calendar_flutter/app/theme/app_theme.dart';
import 'package:workout_calendar_flutter/core/constants/app_strings.dart';
import 'package:workout_calendar_flutter/core/errors/app_exception.dart';
import 'package:workout_calendar_flutter/core/utils/workout_formatters.dart';
import 'package:workout_calendar_flutter/features/calendar/presentation/controllers/calendar_controller.dart';
import 'package:workout_calendar_flutter/features/calendar/presentation/controllers/calendar_state.dart';
import 'package:workout_calendar_flutter/features/calendar/presentation/widgets/calendar_day_cell.dart';
import 'package:workout_calendar_flutter/features/calendar/presentation/widgets/workout_tile.dart';
import 'package:workout_calendar_flutter/features/workout_details/presentation/pages/workout_details_page.dart';
import 'package:workout_calendar_flutter/shared/widgets/app_error_view.dart';
import 'package:workout_calendar_flutter/shared/widgets/app_loading_view.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  static const String routePath = '/';

  static const List<String> _weekdays = <String>[
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarControllerProvider);
    final controller = ref.read(calendarControllerProvider.notifier);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: AppTheme.pageGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: calendarState.when(
            loading: () => const AppLoadingView(),
            error: (Object error, StackTrace stackTrace) {
              return AppErrorView(
                message: error.readableMessage,
                onRetry: controller.reload,
              );
            },
            data: (CalendarState state) {
              final selectedDayWorkouts = state.selectedDayWorkouts;
              final bottomInset = MediaQuery.paddingOf(context).bottom;

              return RefreshIndicator(
                onRefresh: controller.reload,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: _CalendarHeader(
                        state: state,
                        onPreviousMonth: controller.goToPreviousMonth,
                        onNextMonth: controller.goToNextMonth,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        child: _CalendarCard(
                          state: state,
                          onSelectDate: controller.selectDate,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                        child: Text(
                          '${AppStrings.dayEventsTitle} · ${WorkoutFormatters.formatSelectedDate(state.selectedDate)}',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                      ),
                    ),
                    if (selectedDayWorkouts.isEmpty)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 24),
                          child: _EmptyDayState(),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final workout = selectedDayWorkouts[index];

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: index == selectedDayWorkouts.length - 1
                                      ? 0
                                      : 12,
                                ),
                                child: WorkoutTile(
                                  workout: workout,
                                  metadata:
                                      state.metadataFor(workout.workoutKey),
                                  onTap: () {
                                    context.pushNamed(
                                      AppRoute.workoutDetails.name,
                                      pathParameters: <String, String>{
                                        WorkoutDetailsPage.workoutKeyParam:
                                            workout.workoutKey,
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                            childCount: selectedDayWorkouts.length,
                          ),
                        ),
                      ),
                    SliverPadding(
                      padding: EdgeInsets.only(bottom: bottomInset),
                      sliver: const SliverToBoxAdapter(
                        child: SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.state,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  final CalendarState state;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppTheme.outline),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppStrings.calendarTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'This month: ${state.currentMonthWorkoutCount} workouts. Selected day: ${state.selectedDayWorkoutCount}.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                    ),
              ),
              const SizedBox(height: 18),
              Row(
                children: <Widget>[
                  _MonthButton(
                    icon: Icons.chevron_left_rounded,
                    onPressed: onPreviousMonth,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      WorkoutFormatters.formatMonthYear(state.currentMonth),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _MonthButton(
                    icon: Icons.chevron_right_rounded,
                    onPressed: onNextMonth,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthButton extends StatelessWidget {
  const _MonthButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.shell,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(icon, color: AppTheme.accentDeep),
      ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  const _CalendarCard({
    required this.state,
    required this.onSelectDate,
  });

  final CalendarState state;
  final ValueChanged<DateTime> onSelectDate;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.card.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppTheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child: Column(
          children: <Widget>[
            Row(
              children: CalendarPage._weekdays
                  .map(
                    (String label) => Expanded(
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.black54,
                            ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.daysInMonth.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 0.76,
              ),
              itemBuilder: (BuildContext context, int index) {
                final date = state.daysInMonth[index];
                return CalendarDayCell(
                  date: date,
                  isSelected: date != null && state.isSelected(date),
                  isToday: date != null && _isToday(date),
                  hasWorkouts: date != null && state.hasWorkouts(date),
                  onTap: date == null ? null : () => onSelectDate(date),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year && now.month == date.month && now.day == date.day;
  }
}

class _EmptyDayState extends StatelessWidget {
  const _EmptyDayState();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            const Icon(
              Icons.event_busy_rounded,
              size: 48,
              color: AppTheme.accentDeep,
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.emptyDayTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.emptyDaySubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
