class MonthGridBuilder {
  const MonthGridBuilder._();

  static List<DateTime?> build(DateTime month) {
    final normalizedMonth = DateTime(month.year, month.month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingEmptyCells = (normalizedMonth.weekday + 6) % 7;

    final result = List<DateTime?>.filled(
      leadingEmptyCells,
      null,
      growable: true,
    );

    for (var day = 1; day <= daysInMonth; day++) {
      result.add(DateTime(month.year, month.month, day));
    }

    final trailingEmptyCells = (7 - result.length % 7) % 7;
    result.addAll(List<DateTime?>.filled(trailingEmptyCells, null));

    return List<DateTime?>.unmodifiable(result);
  }
}
