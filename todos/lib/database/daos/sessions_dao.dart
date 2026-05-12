// DAO for the `sessions` table.
// ⚠️ Run `dart run build_runner build --delete-conflicting-outputs` to regenerate.
import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/sessions_table.dart';

part 'sessions_dao.g.dart';

@DriftAccessor(tables: [Sessions])
class SessionsDao extends DatabaseAccessor<AppDatabase>
    with _$SessionsDaoMixin {
  SessionsDao(super.db);

  Future<Session?> findActiveByToken(String token) =>
      (select(sessions)..where(
            (s) =>
                s.token.equals(token) &
                s.expiresAt.isBiggerThanValue(DateTime.now()),
          ))
          .getSingleOrNull();

  Future<int> insertSession(SessionsCompanion companion) =>
      into(sessions).insert(companion);

  Future<int> deleteByToken(String token) =>
      (delete(sessions)..where((s) => s.token.equals(token))).go();

  Future<int> deleteAllForUser(int userId) =>
      (delete(sessions)..where((s) => s.userId.equals(userId))).go();

  Future<int> deleteExpired() => (delete(
    sessions,
  )..where((s) => s.expiresAt.isSmallerThanValue(DateTime.now()))).go();
}
