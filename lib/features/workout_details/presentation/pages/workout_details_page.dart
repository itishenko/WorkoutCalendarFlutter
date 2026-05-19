import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_calendar_flutter/app/theme/app_theme.dart';
import 'package:workout_calendar_flutter/core/constants/app_strings.dart';
import 'package:workout_calendar_flutter/core/errors/app_exception.dart';
import 'package:workout_calendar_flutter/features/workout_details/presentation/providers/workout_details_provider.dart';
import 'package:workout_calendar_flutter/features/workout_details/presentation/widgets/heart_rate_chart.dart';
import 'package:workout_calendar_flutter/shared/widgets/app_error_view.dart';
import 'package:workout_calendar_flutter/shared/widgets/app_loading_view.dart';
import 'package:workout_calendar_flutter/shared/widgets/metric_card.dart';
import 'package:workout_calendar_flutter/shared/widgets/workout_activity_avatar.dart';

class WorkoutDetailsPage extends ConsumerWidget {
  const WorkoutDetailsPage({
    required this.workoutKey,
    super.key,
  });

  static const String workoutKeyParam = 'workoutKey';
  static const String routePath = '/workout/:workoutKey';

  final String workoutKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(workoutDetailsProvider(workoutKey));
    final appBarTitle = details.maybeWhen(
      data: (WorkoutDetailsState state) => state.title,
      orElse: () => AppStrings.workoutFallbackTitle,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.accentDeep,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text(appBarTitle),
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.accentDeep,
              fontWeight: FontWeight.w800,
            ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: AppTheme.pageGradient,
        ),
        child: SafeArea(
          top: false,
          child: details.when(
            loading: () => const AppLoadingView(),
            error: (Object error, StackTrace stackTrace) {
              return AppErrorView(message: error.readableMessage);
            },
            data: (WorkoutDetailsState state) {
              final activityStyle =
                  WorkoutActivityStyle.fromType(state.metadata.activityType);
              final chartPoints = state.diagramData?.data ?? const [];
              final hasHeartRateData = chartPoints.isNotEmpty;

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                children: <Widget>[
                  DecoratedBox(
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
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          WorkoutActivityAvatar(
                            activityType: state.metadata.activityType,
                            size: 88,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            state.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.dateTimeLabel,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.black54,
                                    ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: <Widget>[
                              Chip(
                                avatar: Icon(
                                  activityStyle.icon,
                                  size: 18,
                                  color: activityStyle.color,
                                ),
                                label: Text(
                                  activityStyle.label,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              Chip(
                                avatar: const Icon(
                                  Icons.water_drop_outlined,
                                  size: 18,
                                ),
                                label: Text(
                                  state.humidityLabel,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              Chip(
                                avatar: const Icon(
                                  Icons.thermostat_rounded,
                                  size: 18,
                                ),
                                label: Text(
                                  state.temperatureLabel,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppStrings.statistics,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.05,
                    children: <Widget>[
                      MetricCard(
                        label: AppStrings.distance,
                        value: state.distanceLabel,
                        icon: Icons.straighten_rounded,
                        color: const Color(0xFF146C94),
                      ),
                      MetricCard(
                        label: AppStrings.duration,
                        value: state.durationLabel,
                        icon: Icons.schedule_rounded,
                        color: const Color(0xFF2E8B57),
                      ),
                      MetricCard(
                        label: AppStrings.temperature,
                        value: state.temperatureLabel,
                        icon: Icons.thermostat_rounded,
                        color: const Color(0xFFC96B3C),
                      ),
                      MetricCard(
                        label: AppStrings.humidity,
                        value: state.humidityLabel,
                        icon: Icons.water_drop_rounded,
                        color: const Color(0xFF159895),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppStrings.description,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 12),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: AppTheme.outline),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        state.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppStrings.heartRate,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 12),
                  if (hasHeartRateData) ...<Widget>[
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        Chip(
                          avatar: const Icon(
                            Icons.monitor_heart_rounded,
                            color: Color(0xFFB55239),
                          ),
                          label:
                              Text('${AppStrings.average} ${state.averageHeartRate} bpm'),
                        ),
                        Chip(
                          avatar: const Icon(
                            Icons.favorite_rounded,
                            color: Color(0xFFC96B3C),
                          ),
                          label:
                              Text('${AppStrings.maximum} ${state.maxHeartRate} bpm'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                  HeartRateChart(points: chartPoints),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
