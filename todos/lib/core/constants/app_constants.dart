/// App-wide non-string constants.
class AppConstants {
  AppConstants._();

  // ── Auth ──────────────────────────────────────────────────────────────────
  static const int maxLoginAttempts = 5;
  static const int lockoutDurationMinutes = 15;
  static const int sessionExpiryDays = 7;
  static const int hashIterations = 10000;
  static const int saltLengthBytes = 32;

  // ── Validation ────────────────────────────────────────────────────────────
  static const int usernameMinLength = 3;
  static const int usernameMaxLength = 50;
  static const int passwordMinLength = 6;
  static const int passwordMaxLength = 100;
  static const int todoTitleMaxLength = 100;
  static const int todoDescriptionMaxLength = 500;

  // ── UI ────────────────────────────────────────────────────────────────────
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;
  static const double inputBorderRadius = 12.0;
  static const double pagePadding = 16.0;
  static const double listItemSpacing = 12.0;
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);

  // ── Seed ──────────────────────────────────────────────────────────────────
  static const String seedUsername = 'admin';
  static const String seedPassword = 'Admin@123';

  // ── Secure storage keys ───────────────────────────────────────────────────
  static const String storageSessionToken = 'session_token';
  static const String storageFailedAttempts = 'failed_attempts';
  static const String storageLockoutTime = 'lockout_time';
}
