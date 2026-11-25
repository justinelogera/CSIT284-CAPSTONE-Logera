extension DateText on DateTime {
  /// e.g. 2026-12-02
  String get ymd =>
      '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
}