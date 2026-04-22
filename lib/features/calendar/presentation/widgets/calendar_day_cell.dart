import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:workout_calendar_flutter/app/theme/app_theme.dart';

class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.hasWorkouts,
    this.onTap,
    super.key,
  });

  final DateTime? date;
  final bool isSelected;
  final bool isToday;
  final bool hasWorkouts;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (date == null) {
          return const SizedBox.expand();
        }

        final day = date!.day.toString();
        final foregroundColor = isSelected
            ? Colors.white
            : isToday
                ? AppTheme.accent
                : Colors.black87;

        final cellWidth = constraints.maxWidth;
        final cellHeight =
            constraints.maxHeight.isFinite ? constraints.maxHeight : cellWidth;
        final circleSize = math.max(28, math.min(40, cellWidth - 4)).toDouble();
        final dotSize =
            math.max(5, math.min(7, circleSize * 0.16)).toDouble();
        final gap = math.max(
          0,
          math.min(4, cellHeight - circleSize - dotSize),
        ).toDouble();
        final fontSize =
            math.max(13, math.min(16, circleSize * 0.38)).toDouble();

        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.accent : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isToday ? AppTheme.accent : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: foregroundColor,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: gap),
                SizedBox(
                  width: dotSize,
                  height: dotSize,
                  child: Center(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 180),
                      opacity: hasWorkouts ? 1 : 0,
                      child: Container(
                        width: dotSize,
                        height: dotSize,
                        decoration: const BoxDecoration(
                          color: AppTheme.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
