import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_calendar_flutter/core/constants/app_strings.dart';
import 'package:workout_calendar_flutter/features/calendar/presentation/pages/calendar_page.dart';
import 'package:workout_calendar_flutter/features/workout_details/presentation/pages/workout_details_page.dart';

enum AppRoute {
  calendar,
  workoutDetails,
}

final appRouterProvider = Provider<GoRouter>((Ref ref) {
  final router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: CalendarPage.routePath,
        name: AppRoute.calendar.name,
        builder: (BuildContext context, GoRouterState state) {
          return const CalendarPage();
        },
      ),
      GoRoute(
        path: WorkoutDetailsPage.routePath,
        name: AppRoute.workoutDetails.name,
        builder: (BuildContext context, GoRouterState state) {
          final workoutKey =
              state.pathParameters[WorkoutDetailsPage.workoutKeyParam];

          if (workoutKey == null || workoutKey.isEmpty) {
            return const Scaffold(
              body: Center(
                child: Text(AppStrings.workoutNotFound),
              ),
            );
          }

          return WorkoutDetailsPage(workoutKey: workoutKey);
        },
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
