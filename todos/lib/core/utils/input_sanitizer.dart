// Input sanitisation helpers — applied before persisting any user input.
class InputSanitizer {
  InputSanitizer._();

  /// Removes leading/trailing whitespace and collapses internal runs.
  static String sanitize(String input) =>
      input.trim().replaceAll(RegExp(r'\s+'), ' ');

  /// Sanitise and enforce [maxLength]; returns trimmed string.
  static String sanitizeWithLimit(String input, int maxLength) {
    final cleaned = sanitize(input);
    return cleaned.length > maxLength
        ? cleaned.substring(0, maxLength)
        : cleaned;
  }

  /// Removes characters outside of printable ASCII range.
  static String stripNonPrintable(String input) =>
      input.replaceAll(RegExp(r'[^\x20-\x7E]'), '');

  /// Returns true when [username] only contains letters, digits, underscores
  /// and is within the allowed length range.
  static bool isValidUsername(String username, {int min = 3, int max = 50}) {
    if (username.length < min || username.length > max) return false;
    return RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username);
  }
}
