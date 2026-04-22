import 'package:flutter/material.dart';
import 'package:workout_calendar_flutter/app/theme/app_theme.dart';
import 'package:workout_calendar_flutter/core/utils/workout_formatters.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/entities/workout.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/entities/workout_metadata.dart';
import 'package:workout_calendar_flutter/shared/widgets/workout_activity_avatar.dart';

class WorkoutTile extends StatelessWidget {
  const WorkoutTile({
    required this.workout,
    this.metadata,
    this.onTap,
    super.key,
  });

  final Workout workout;
  final WorkoutMetadata? metadata;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final style = WorkoutActivityStyle.fromType(workout.activityType);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.outline),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                WorkoutActivityAvatar(activityType: workout.activityType),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              style.label,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          if (metadata?.distanceMeters != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: style.color.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                WorkoutFormatters.formatDistance(
                                  metadata?.distanceMeters,
                                ),
                                style: TextStyle(
                                  color: style.color,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        WorkoutFormatters.formatTime(workout.startedAt),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.black54,
                            ),
                      ),
                      if ((metadata?.comment ?? '').isNotEmpty) ...<Widget>[
                        const SizedBox(height: 8),
                        Text(
                          metadata!.comment,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.black87,
                                  ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.black45,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
