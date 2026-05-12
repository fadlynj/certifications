// DateTime utility extensions.
extension DateTimeX on DateTime {
  /// Returns the Monday of this date's ISO week.
  DateTime get startOfWeek {
    final daysFromMonday = weekday - 1; // weekday: 1=Mon … 7=Sun
    return subtract(
      Duration(days: daysFromMonday),
    ).copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
  }

  /// Returns the Sunday of this date's ISO week.
  DateTime get endOfWeek => startOfWeek.add(const Duration(days: 6));

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isPast => isBefore(DateTime.now());

  bool get isFuture => isAfter(DateTime.now());

  /// Returns date-only comparison (ignores time component).
  bool isSameDayAs(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// Short label for use in charts (Mon, Tue, …).
  String get weekdayShort {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return labels[weekday - 1];
  }
}
