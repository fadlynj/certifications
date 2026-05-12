// String utility extensions.
extension StringX on String {
  /// True when the string contains only letters, digits and underscores.
  bool get isAlphanumericOrUnderscore =>
      RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(this);

  /// True when the string has at least one uppercase, lowercase and digit.
  bool get isStrongPassword =>
      RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).+$').hasMatch(this);

  /// Capitalises the first letter.
  String get capitalised =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Removes leading/trailing whitespace and collapses internal whitespace.
  String get sanitised => trim().replaceAll(RegExp(r'\s+'), ' ');

  /// Returns null when the string (after trimming) is empty.
  String? get nullIfEmpty => trim().isEmpty ? null : trim();

  /// Truncates to [maxLength] and appends '…' if necessary.
  String truncate(int maxLength) =>
      length <= maxLength ? this : '${substring(0, maxLength)}…';
}

extension NullableStringX on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
