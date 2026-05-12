// Todo local data source — all DB operations for todos.

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/input_sanitizer.dart';
import '../../../../database/app_database.dart';
import '../../domain/entities/todo_entity.dart';
import '../mappers/todo_mapper.dart';
import '../models/todo_model.dart';

class TodoLocalDataSource {
  TodoLocalDataSource({required AppDatabase database}) : _db = database;

  final AppDatabase _db;

  // ── Reactive stream ──────────────────────────────────────────────────────

  Stream<List<TodoModel>> watchTodos(int userId) => _db.todosDao
      .watchTodos(userId)
      .map((rows) => rows.map<TodoModel>(TodoMapper.fromRow).toList());

  // ── Queries ──────────────────────────────────────────────────────────────

  Future<List<TodoModel>> getTodos(int userId) async {
    final rows = await _db.todosDao.getTodos(userId);
    return rows.map<TodoModel>(TodoMapper.fromRow).toList();
  }

  Future<List<TodoModel>> getCompletedSince(
    int userId,
    DateTime weekStart,
  ) async {
    final rows = await _db.todosDao.getCompletedSince(userId, weekStart);
    return rows.map<TodoModel>(TodoMapper.fromRow).toList();
  }

  // ── Mutations ─────────────────────────────────────────────────────────────

  Future<TodoModel> createTodo({
    required int userId,
    required String title,
    String? description,
    DateTime? deadline,
    bool isImportant = false,
  }) async {
    final sanitizedTitle = InputSanitizer.sanitizeWithLimit(title, 100);
    final sanitizedDesc = description != null
        ? InputSanitizer.sanitizeWithLimit(description, 500)
        : null;

    final id = await _db.todosDao.insertTodo(
      TodoMapper.toInsertCompanion(
        userId: userId,
        title: sanitizedTitle,
        description: sanitizedDesc,
        deadline: deadline,
        isImportant: isImportant,
      ),
    );

    final row = await (_db.select(
      _db.todos,
    )..where((t) => t.id.equals(id))).getSingle();
    return TodoMapper.fromRow(row);
  }

  Future<TodoModel> updateTodo(TodoEntity entity) async {
    await _db.todosDao.updateTodo(TodoMapper.toCompanion(entity));
    final row = await (_db.select(
      _db.todos,
    )..where((t) => t.id.equals(entity.id))).getSingleOrNull();
    if (row == null) {
      throw const DatabaseException('Todo not found after update');
    }
    return TodoMapper.fromRow(row);
  }

  Future<TodoModel> toggleStatus(int todoId) async {
    final row = await (_db.select(
      _db.todos,
    )..where((t) => t.id.equals(todoId))).getSingleOrNull();
    if (row == null) throw const DatabaseException('Todo not found');

    final nowDone = !row.isDone;
    final updatedEntity = TodoMapper.toEntity(TodoMapper.fromRow(row)).copyWith(
      isDone: nowDone,
      completedAt: nowDone ? DateTime.now() : null,
      clearCompletedAt: !nowDone,
      updatedAt: DateTime.now(),
    );

    await _db.todosDao.updateTodo(TodoMapper.toCompanion(updatedEntity));

    final updatedRow = await (_db.select(
      _db.todos,
    )..where((t) => t.id.equals(todoId))).getSingle();
    return TodoMapper.fromRow(updatedRow);
  }

  Future<void> deleteTodo(int todoId) async {
    await _db.todosDao.softDelete(todoId);
  }

  Future<void> clearAllTodos(int userId) async {
    await _db.todosDao.deleteAllForUser(userId);
  }
}
