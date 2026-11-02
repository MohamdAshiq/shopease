// Extension for formatting DateTime
extension DateFormatter on DateTime {
  static const List<String> _shortWeekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static const List<String> _shortMonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const List<String> _fullMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  // Formats date to '31 Oct 2026'
  String get formattedDate => '$day ${_shortMonths[month - 1]} $year';

  // Formats date with weekday to 'Mon, 02 Nov 2026'
  String get formattedDateWithWeekday {
    final weekdayStr = _shortWeekdays[weekday - 1];
    final dayStr = day.toString().padLeft(2, '0');
    final monthStr = _shortMonths[month - 1];
    return '$weekdayStr, $dayStr $monthStr $year';
  }

  // Formats date and time to '31 Oct 2026, 10:30 AM'
  String get formattedDateTime {
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final period = hour >= 12 ? 'PM' : 'AM';
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$day ${_shortMonths[month - 1]} $year, $hour12:$minuteStr $period';
  }

  // Formats short date and 24h time to '28 Oct, 09:30'
  String get formattedShortDateTime {
    final monthStr = _shortMonths[month - 1];
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$day $monthStr, $hourStr:$minuteStr';
  }

  // Formats full date and 24h time to '28 October 2026, 09:30'
  String get formattedFullDateTime {
    final monthStr = _fullMonths[month - 1];
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$day $monthStr $year, $hourStr:$minuteStr';
  }
}

// Extension on nullable DateTime for convenient formatting with fallback
extension NullableDateFormatter on DateTime? {
  String get formattedShortDateTime =>
      this != null ? this!.formattedShortDateTime : '—';

  String get formattedFullDateTime =>
      this != null ? this!.formattedFullDateTime : '—';
}
