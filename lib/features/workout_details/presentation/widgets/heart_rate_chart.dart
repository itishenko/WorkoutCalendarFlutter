import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:workout_calendar_flutter/app/theme/app_theme.dart';
import 'package:workout_calendar_flutter/core/constants/app_strings.dart';
import 'package:workout_calendar_flutter/features/workouts/domain/entities/diagram_data.dart';

class HeartRateChart extends StatelessWidget {
  const HeartRateChart({
    required this.points,
    super.key,
  });

  final List<DiagramPoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppTheme.outline),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Text(AppStrings.noHeartRateData),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: SizedBox(
          height: 220,
          child: CustomPaint(
            painter: _HeartRateChartPainter(points),
          ),
        ),
      ),
    );
  }
}

class _HeartRateChartPainter extends CustomPainter {
  _HeartRateChartPainter(this.points);

  final List<DiagramPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) {
      return;
    }

    const horizontalPadding = 8.0;
    const verticalPadding = 12.0;

    final chartRect = Rect.fromLTWH(
      horizontalPadding,
      verticalPadding,
      size.width - horizontalPadding * 2,
      size.height - verticalPadding * 2,
    );

    final heartRates = points.map((DiagramPoint point) => point.heartRate);
    final minHeartRate = heartRates.reduce(math.min).toDouble();
    final maxHeartRate = heartRates.reduce(math.max).toDouble();
    final range = math.max(maxHeartRate - minHeartRate, 1);

    final gridPaint = Paint()
      ..color = AppTheme.outline
      ..strokeWidth = 1;

    for (var index = 0; index < 4; index++) {
      final dy = chartRect.top + chartRect.height / 3 * index;
      canvas.drawLine(
        Offset(chartRect.left, dy),
        Offset(chartRect.right, dy),
        gridPaint,
      );
    }

    final linePath = Path();
    final fillPath = Path()
      ..moveTo(chartRect.left, chartRect.bottom);

    for (var index = 0; index < points.length; index++) {
      final point = points[index];
      final denominator = math.max(points.length - 1, 1);
      final x = chartRect.left + chartRect.width * index / denominator;
      final normalized = (point.heartRate - minHeartRate) / range;
      final y = chartRect.bottom - chartRect.height * normalized;
      final offset = Offset(x, y);

      if (index == 0) {
        linePath.moveTo(offset.dx, offset.dy);
        fillPath.lineTo(offset.dx, offset.dy);
      } else {
        linePath.lineTo(offset.dx, offset.dy);
        fillPath.lineTo(offset.dx, offset.dy);
      }
    }

    fillPath
      ..lineTo(chartRect.right, chartRect.bottom)
      ..close();

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          Color(0x44B55239),
          Color(0x11B55239),
        ],
      ).createShader(chartRect);

    final linePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: <Color>[
          Color(0xFFB55239),
          Color(0xFFC96B3C),
        ],
      ).createShader(chartRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant _HeartRateChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
