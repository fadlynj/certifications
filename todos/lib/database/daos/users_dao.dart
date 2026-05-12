// DAO for the `users` table.
// ⚠️ Run `dart run build_runner build --delete-conflicting-outputs` to regenerate.
import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/users_table.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  /// Returns the user with [username], or null if not found.
  Future<User?> findByUsername(String username) => (select(
    users,
  )..where((u) => u.username.equals(username))).getSingleOrNull();

  /// Returns true if at least one user row exists (used for seed check).
  Future<bool> hasAnyUser() async {
    final count = await users.count().getSingle();
    return count > 0;
  }

  Future<int> insertUser(UsersCompanion companion) =>
      into(users).insert(companion);

  Future<bool> updateUser(User entity) => update(users).replace(entity);
}
