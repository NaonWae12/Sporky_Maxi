class AppClock {
  AppClock._();

  static const String timezone = 'Asia/Jakarta';
  static const Duration _jakartaOffset = Duration(hours: 7);

  static DateTime now() {
    return DateTime.now().toUtc().add(_jakartaOffset);
  }

  static String todayDateString() {
    final today = now();
    final year = today.year.toString().padLeft(4, '0');
    final month = today.month.toString().padLeft(2, '0');
    final day = today.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
