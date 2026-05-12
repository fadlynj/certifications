// DAO for the `todos` table.
// ⚠️ Run `dart run build_runner build --delete-conflicting-outputs` to regenerate.
import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/todos_table.dart';

part 'todos_dao.g.dart';

@DriftAccessor(tables: [Todos])
class TodosDao extends DatabaseAccessor<AppDatabase> with _$TodosDaoMixin {
  TodosDao(super.db);

  // ── Reactive stream ──────────────────────────────────────────────────────

  /// Live stream of all non-deleted todos for [userId], newest first.
  Stream<List<Todo>> watchTodos(int userId) =>
      (select(todos)
            ..where((t) => t.userId.equals(userId) & t.isDeleted.equals(false))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  // ── Queries ──────────────────────────────────────────────────────────────

  Future<List<Todo>> getTodos(int userId) =>
      (select(todos)
            ..where((t) => t.userId.equals(userId) & t.isDeleted.equals(false))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  /// Returns completed todos whose [completedAt] >= [weekStart].
  Future<List<Todo>> getCompletedSince(int userId, DateTime weekStart) =>
      (select(todos)..where(
            (t) =>
                t.userId.equals(userId) &
                t.isDeleted.equals(false) &
                t.isDone.equals(true) &
                t.completedAt.isBiggerOrEqualValue(weekStart),
          ))
          .get();

  // ── Mutations ─────────────────────────────────────────────────────────────

  Future<int> insertTodo(TodosCompanion companion) =>
      into(todos).insert(companion);

  Future<bool> updateTodo(TodosCompanion companion) =>
      update(todos).replace(companion);

  /// Soft-delete — sets [isDeleted] = true rather than removing the row.
  Future<int> softDelete(int id) =>
      (update(todos)..where((t) => t.id.equals(id))).write(
        const TodosCompanion(isDeleted: Value(true)),
      );

  /// Hard-delete all soft-deleted rows (used in "clear data" operation).
  Future<int> purgeDeleted(int userId) => (delete(
    todos,
  )..where((t) => t.userId.equals(userId) & t.isDeleted.equals(true))).go();

  /// Hard-delete ALL todos for a user (used in "clear all data").
  Future<int> deleteAllForUser(int userId) =>
      (delete(todos)..where((t) => t.userId.equals(userId))).go();
}
