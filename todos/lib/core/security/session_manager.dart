// Session lifecycle manager.
// Handles: token persistence, expiry, brute-force lockout.
import '../constants/app_constants.dart';
import '../services/logger_service.dart';
import 'secure_storage_service.dart';

class SessionManager {
  SessionManager(this._storage);

  final SecureStorageService _storage;

  // ── Session token ─────────────────────────────────────────────────────────

  Future<void> saveToken(String token) async =>
      _storage.write(AppConstants.storageSessionToken, token);

  Future<String?> getToken() async =>
      _storage.read(AppConstants.storageSessionToken);

  Future<void> clearToken() async =>
      _storage.delete(AppConstants.storageSessionToken);

  /// Returns true when a (non-empty) token is stored.
  /// Actual validity is confirmed by the repository (DB lookup + expiry).
  Future<bool> hasStoredToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ── Brute-force protection ────────────────────────────────────────────────

  /// Returns true when the account is currently locked out.
  Future<bool> isLockedOut() async {
    final lockoutTimeStr = await _storage.read(AppConstants.storageLockoutTime);
    if (lockoutTimeStr == null) return false;

    final lockoutTime = DateTime.tryParse(lockoutTimeStr);
    if (lockoutTime == null) return false;

    final unlockTime = lockoutTime.add(
      const Duration(minutes: AppConstants.lockoutDurationMinutes),
    );
    if (DateTime.now().isBefore(unlockTime)) {
      return true;
    }
    // Lockout expired — clear it
    await _clearBruteForceData();
    return false;
  }

  Future<void> recordFailedAttempt() async {
    final countStr = await _storage.read(AppConstants.storageFailedAttempts);
    final count = int.tryParse(countStr ?? '0') ?? 0;
    final newCount = count + 1;

    await _storage.write(
      AppConstants.storageFailedAttempts,
      newCount.toString(),
    );

    AppLogger.w('Failed login attempt #$newCount');

    if (newCount >= AppConstants.maxLoginAttempts) {
      await _storage.write(
        AppConstants.storageLockoutTime,
        DateTime.now().toIso8601String(),
      );
      AppLogger.w('Account locked after $newCount failed attempts');
    }
  }

  Future<void> clearFailedAttempts() => _clearBruteForceData();

  Future<void> _clearBruteForceData() async {
    await _storage.delete(AppConstants.storageFailedAttempts);
    await _storage.delete(AppConstants.storageLockoutTime);
  }

  // ── Full sign-out ─────────────────────────────────────────────────────────

  Future<void> clearSession() async {
    await clearToken();
    await _clearBruteForceData();
  }
}
