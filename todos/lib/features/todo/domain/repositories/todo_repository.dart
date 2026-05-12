import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/todo_entity.dart';

abstract class TodoRepository {
  /// Live stream of all non-deleted todos for [userId].
  Stream<Either<Failure, List<TodoEntity>>> watchTodos(int userId);

  Future<Either<Failure, List<TodoEntity>>> getTodos(int userId);

  /// Returns todos completed on or after [weekStart].
  Future<Either<Failure, List<TodoEntity>>> getCompletedSince(
    int userId,
    DateTime weekStart,
  );

  Future<Either<Failure, TodoEntity>> createTodo({
    required int userId,
    required String title,
    String? description,
    DateTime? deadline,
    bool isImportant = false,
  });

  Future<Either<Failure, TodoEntity>> updateTodo(TodoEntity todo);

  Future<Either<Failure, TodoEntity>> toggleStatus(int todoId);

  /// Soft-deletes a single todo.
  Future<Either<Failure, Unit>> deleteTodo(int todoId);

  /// Hard-deletes ALL todos for [userId] (used in clear-data).
  Future<Either<Failure, Unit>> clearAllTodos(int userId);
}
