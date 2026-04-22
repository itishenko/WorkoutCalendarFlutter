import 'package:flutter/material.dart';
import 'package:workout_calendar_flutter/core/utils/workout_formatters.dart';

class WorkoutActivityStyle {
  const WorkoutActivityStyle({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  static WorkoutActivityStyle fromType(String activityType) {
    switch (activityType) {
      case 'Walking/Running':
        return const WorkoutActivityStyle(
          label: 'Walking / Running',
          icon: Icons.directions_run_rounded,
          color: Color(0xFF2E8B57),
        );
      case 'Cycling':
        return const WorkoutActivityStyle(
          label: 'Cycling',
          icon: Icons.directions_bike_rounded,
          color: Color(0xFF146C94),
        );
      case 'Yoga':
        return const WorkoutActivityStyle(
          label: 'Yoga',
          icon: Icons.self_improvement_rounded,
          color: Color(0xFFC96B3C),
        );
      case 'Water':
        return const WorkoutActivityStyle(
          label: 'Cold Water',
          icon: Icons.pool_rounded,
          color: Color(0xFF159895),
        );
      case 'Strength':
        return const WorkoutActivityStyle(
          label: 'Strength Training',
          icon: Icons.fitness_center_rounded,
          color: Color(0xFFB55239),
        );
      default:
        return WorkoutActivityStyle(
          label: WorkoutFormatters.activityLabel(activityType),
          icon: Icons.monitor_heart_outlined,
          color: const Color(0xFF546A7B),
        );
    }
  }
}

class WorkoutActivityAvatar extends StatelessWidget {
  const WorkoutActivityAvatar({
    required this.activityType,
    this.size = 56,
    super.key,
  });

  final String activityType;
  final double size;

  @override
  Widget build(BuildContext context) {
    final style = WorkoutActivityStyle.fromType(activityType);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: 0.14),
        shape: BoxShape.circle,
      ),
      child: Icon(
        style.icon,
        size: size * 0.48,
        color: style.color,
      ),
    );
  }
}
