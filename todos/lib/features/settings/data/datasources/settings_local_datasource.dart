// Settings data source — app info + data clearing.
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/security/session_manager.dart';
import '../../../../database/app_database.dart';

class SettingsLocalDataSource {
  SettingsLocalDataSource({
    required AppDatabase database,
    required SessionManager sessionManager,
  }) : _db = database,
       _session = sessionManager;

  final AppDatabase _db;
  final SessionManager _session;

  Future<String> getAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return '${info.version}+${info.buildNumber}';
    } catch (_) {
      return '1.0.0+1';
    }
  }

  /// Deletes all todos for [userId], all sessions and clears secure storage.
  Future<void> clearAllData(int userId) async {
    try {
      await _db.todosDao.deleteAllForUser(userId);
      await _db.sessionsDao.deleteAllForUser(userId);
      await _session.clearSession();
    } catch (e) {
      throw DatabaseException('Failed to clear data: $e');
    }
  }
}
