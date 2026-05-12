// Auth local data source — all DB + secure-storage operations for auth.
// Throws [AppException] subtypes; repositories catch and map to [Failure].
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/security/hash_service.dart';
import '../../../../core/security/session_manager.dart';
import '../../../../core/utils/input_sanitizer.dart';
import '../../../../database/app_database.dart';
import '../mappers/session_mapper.dart';
import '../mappers/user_mapper.dart';
import '../models/session_model.dart';
import '../models/user_model.dart';

class AuthLocalDataSource {
  AuthLocalDataSource({
    required AppDatabase database,
    required HashService hashService,
    required SessionManager sessionManager,
  }) : _db = database,
       _hash = hashService,
       _session = sessionManager;

  final AppDatabase _db;
  final HashService _hash;
  final SessionManager _session;
  final Uuid _uuid = const Uuid();

  // ── Login ─────────────────────────────────────────────────────────────────

  Future<SessionModel> login({
    required String username,
    required String password,
  }) async {
    // Brute-force check
    if (await _session.isLockedOut()) throw const AccountLockedException();

    final sanitizedUsername = InputSanitizer.sanitize(username);
    final user = await _db.usersDao.findByUsername(sanitizedUsername);

    if (user == null) {
      await _session.recordFailedAttempt();
      throw const InvalidCredentialsException();
    }

    final isValid = _hash.verifyPassword(
      password,
      user.passwordHash,
      user.salt,
    );
    if (!isValid) {
      await _session.recordFailedAttempt();
      throw const InvalidCredentialsException();
    }

    // Clear failed attempts on success
    await _session.clearFailedAttempts();

    final token = _uuid.v4();
    final expiresAt = DateTime.now().add(
      const Duration(days: AppConstants.sessionExpiryDays),
    );

    await _db.sessionsDao.insertSession(
      SessionMapper.toInsertCompanion(
        userId: user.id,
        token: token,
        expiresAt: expiresAt,
      ),
    );

    await _session.saveToken(token);

    return SessionModel(
      id: 0, // not used after insert
      userId: user.id,
      username: user.username,
      token: token,
      expiresAt: expiresAt,
      createdAt: DateTime.now(),
    );
  }

  // ── Logout ────────────────────────────────────────────────────────────────

  Future<void> logout({required String token}) async {
    await _db.sessionsDao.deleteByToken(token);
    await _session.clearSession();
  }

  // ── Current session ───────────────────────────────────────────────────────

  Future<SessionModel?> getCurrentSession() async {
    final token = await _session.getToken();
    if (token == null) return null;

    final sessionRow = await _db.sessionsDao.findActiveByToken(token);
    if (sessionRow == null) {
      await _session.clearToken();
      return null;
    }

    final userRow = await _db.usersDao.findByUsername(
      await _getUsernameForUserId(sessionRow.userId),
    );
    if (userRow == null) {
      await _session.clearToken();
      return null;
    }

    return SessionMapper.fromRow(sessionRow, userRow.username);
  }

  Future<String> _getUsernameForUserId(int userId) async {
    // Drift doesn't generate a findById by default — we do a select here.
    final result = await (_db.select(
      _db.users,
    )..where((u) => u.id.equals(userId))).getSingleOrNull();
    return result?.username ?? '';
  }

  // ── Register ──────────────────────────────────────────────────────────────

  Future<UserModel> registerInitialUser({
    required String username,
    required String password,
  }) async {
    final sanitized = InputSanitizer.sanitize(username);
    final existing = await _db.usersDao.findByUsername(sanitized);
    if (existing != null) throw const UserAlreadyExistsException();

    final salt = _hash.generateSalt();
    final hash = _hash.hashPassword(password, salt);

    final id = await _db.usersDao.insertUser(
      UserMapper.toInsertCompanion(
        username: sanitized,
        passwordHash: hash,
        salt: salt,
      ),
    );

    final row = await (_db.select(
      _db.users,
    )..where((u) => u.id.equals(id))).getSingle();
    return UserMapper.fromRow(row);
  }

  // ── Reset password ────────────────────────────────────────────────────────

  Future<void> resetPassword({
    required String username,
    required String currentPassword,
    required String newPassword,
  }) async {
    final sanitized = InputSanitizer.sanitize(username);
    final user = await _db.usersDao.findByUsername(sanitized);
    if (user == null) throw const UserNotFoundException();

    final isValid = _hash.verifyPassword(
      currentPassword,
      user.passwordHash,
      user.salt,
    );
    if (!isValid) throw const InvalidCredentialsException();

    final newSalt = _hash.generateSalt();
    final newHash = _hash.hashPassword(newPassword, newSalt);

    final updated = user.copyWith(
      passwordHash: newHash,
      salt: newSalt,
      updatedAt: DateTime.now(),
    );

    await _db.usersDao.updateUser(updated);
  }
}
