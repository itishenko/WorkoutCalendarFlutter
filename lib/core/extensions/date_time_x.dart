extension DateTimeX on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get monthStart => DateTime(year, month);

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  DateTime shiftMonthClamped(int delta) {
    final targetMonth = DateTime(year, month + delta);
    final lastDay = DateTime(targetMonth.year, targetMonth.month + 1, 0).day;
    final safeDay = day.clamp(1, lastDay).toInt();

    return DateTime(targetMonth.year, targetMonth.month, safeDay);
  }
}
