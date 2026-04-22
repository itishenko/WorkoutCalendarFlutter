import 'package:intl/intl.dart';

class WorkoutFormatters {
  const WorkoutFormatters._();

  static DateTime? parseApiDate(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) {
      return null;
    }

    try {
      return DateFormat('yyyy-MM-dd HH:mm:ss').parseStrict(rawDate);
    } catch (_) {
      return null;
    }
  }

  static String formatMonthYear(DateTime date) {
    final value = DateFormat('MMMM yyyy', 'en_US').format(date);
    return value[0].toUpperCase() + value.substring(1);
  }

  static String formatSelectedDate(DateTime date) {
    final value = DateFormat('MMMM d, EEEE', 'en_US').format(date);
    return value[0].toUpperCase() + value.substring(1);
  }

  static String formatLongDateTime(DateTime? date) {
    if (date == null) {
      return '—';
    }

    return DateFormat('MMMM d, yyyy, HH:mm', 'en_US').format(date);
  }

  static String formatTime(DateTime? date) {
    if (date == null) {
      return '—';
    }

    return DateFormat('HH:mm', 'en_US').format(date);
  }

  static String formatDistance(double? distanceMeters) {
    if (distanceMeters == null || distanceMeters <= 0) {
      return '—';
    }

    if (distanceMeters >= 1000) {
      final formatter = NumberFormat.decimalPatternDigits(
        locale: 'en_US',
        decimalDigits: 2,
      );
      return '${formatter.format(distanceMeters / 1000)} km';
    }

    final formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_US',
      decimalDigits: 0,
    );
    return '${formatter.format(distanceMeters)} m';
  }

  static String formatDuration(double? durationSeconds) {
    if (durationSeconds == null) {
      return '—';
    }

    final totalSeconds = durationSeconds.floor();
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;

    if (hours > 0) {
      return '$hours h $minutes min';
    }

    return '$minutes min';
  }

  static String formatTemperature(double? temperatureCelsius) {
    if (temperatureCelsius == null) {
      return '—';
    }

    final formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_US',
      decimalDigits: 1,
    );

    return '${formatter.format(temperatureCelsius)}°C';
  }

  static String formatHumidity(double? humidityPercent) {
    if (humidityPercent == null) {
      return '—';
    }

    final formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_US',
      decimalDigits: 0,
    );

    return '${formatter.format(humidityPercent)}%';
  }

  static String activityLabel(String type) {
    switch (type) {
      case 'Walking/Running':
        return 'Walking / Running';
      case 'Yoga':
        return 'Yoga';
      case 'Water':
        return 'Cold Water';
      case 'Cycling':
        return 'Cycling';
      case 'Strength':
        return 'Strength Training';
      default:
        return type;
    }
  }
}
