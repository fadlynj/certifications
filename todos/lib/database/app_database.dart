// Main Drift database entry point.
// ⚠️ Run `dart run build_runner build --delete-conflicting-outputs` to regenerate.
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/sessions_dao.dart';
import 'daos/todos_dao.dart';
import 'daos/users_dao.dart';
import 'tables/sessions_table.dart';
import 'tables/todos_table.dart';
import 'tables/users_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Users, Todos, Sessions],
  daos: [UsersDao, TodosDao, SessionsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Add future migration steps here, e.g.:
      // if (from < 2) { await m.addColumn(todos, todos.someNewColumn); }
    },
    beforeOpen: (OpeningDetails details) async {
      // Enable FK enforcement on SQLite
      await customStatement('PRAGMA foreign_keys = ON');
      // Remove expired sessions on startup
      await sessionsDao.deleteExpired();
    },
  );

  static QueryExecutor _openConnection() => driftDatabase(name: 'todos_app_db');
}
