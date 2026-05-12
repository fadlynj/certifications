// Date/time formatting helpers.
import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _dateFmt = DateFormat('dd MMM yyyy');
  static final DateFormat _dateTimeFmt = DateFormat('dd MMM yyyy, HH:mm');
  static final DateFormat _timeFmt = DateFormat('HH:mm');

  /// e.g. "11 May 2026"
  static String formatDate(DateTime dt) => _dateFmt.format(dt);

  /// e.g. "11 May 2026, 14:30"
  static String formatDateTime(DateTime dt) => _dateTimeFmt.format(dt);

  /// e.g. "14:30"
  static String formatTime(DateTime dt) => _timeFmt.format(dt);

  /// Returns "Today", "Tomorrow", or the formatted date.
  static String formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dDay = DateTime(deadline.year, deadline.month, deadline.day);
    final diff = dDay.difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff < 0) return 'Overdue · ${formatDate(deadline)}';
    return formatDate(deadline);
  }
}
