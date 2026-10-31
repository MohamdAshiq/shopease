// Extension for formatting DateTime
extension DateFormatter on DateTime {
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

  // Formats date to '31 Oct 2026'
  String get formattedDate => '$day ${_shortMonths[month - 1]} $year';

  // Formats date and time to '31 Oct 2026, 10:30 AM'
  String get formattedDateTime {
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final period = hour >= 12 ? 'PM' : 'AM';
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$day ${_shortMonths[month - 1]} $year, $hour12:$minuteStr $period';
  }
}
