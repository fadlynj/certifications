// Todo repository implementation.
import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/logger_service.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';
import '../mappers/todo_mapper.dart';

class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl(this._dataSource);

  final TodoLocalDataSource _dataSource;

  @override
  Stream<Either<Failure, List<TodoEntity>>> watchTodos(int userId) =>
      _dataSource
          .watchTodos(userId)
          .map(
            (models) => Right<Failure, List<TodoEntity>>(
              models.map(TodoMapper.toEntity).toList(),
            ),
          )
          .handleError((Object e, StackTrace st) {
            AppLogger.e('watchTodos error', stackTrace: st);
            return const Left<Failure, List<TodoEntity>>(DatabaseFailure());
          });

  @override
  Future<Either<Failure, List<TodoEntity>>> getTodos(int userId) async {
    try {
      final models = await _dataSource.getTodos(userId);
      return Right(models.map(TodoMapper.toEntity).toList());
    } on AppException catch (e, st) {
      AppLogger.e('getTodos failed', error: e.message, stackTrace: st);
      return Left(DatabaseFailure(e.message));
    } catch (e, st) {
      AppLogger.e('Unexpected getTodos error', stackTrace: st);
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<TodoEntity>>> getCompletedSince(
    int userId,
    DateTime weekStart,
  ) async {
    try {
      final models = await _dataSource.getCompletedSince(userId, weekStart);
      return Right(models.map(TodoMapper.toEntity).toList());
    } on AppException catch (e, st) {
      AppLogger.e('getCompletedSince failed', error: e.message, stackTrace: st);
      return Left(DatabaseFailure(e.message));
    } catch (e, st) {
      AppLogger.e('Unexpected getCompletedSince error', stackTrace: st);
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, TodoEntity>> createTodo({
    required int userId,
    required String title,
    String? description,
    DateTime? deadline,
    bool isImportant = false,
  }) async {
    try {
      final model = await _dataSource.createTodo(
        userId: userId,
        title: title,
        description: description,
        deadline: deadline,
        isImportant: isImportant,
      );
      return Right(TodoMapper.toEntity(model));
    } on AppException catch (e, st) {
      AppLogger.e('createTodo failed', error: e.message, stackTrace: st);
      return Left(DatabaseFailure(e.message));
    } catch (e, st) {
      AppLogger.e('Unexpected createTodo error', stackTrace: st);
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, TodoEntity>> updateTodo(TodoEntity todo) async {
    try {
      final model = await _dataSource.updateTodo(todo);
      return Right(TodoMapper.toEntity(model));
    } on AppException catch (e, st) {
      AppLogger.e('updateTodo failed', error: e.message, stackTrace: st);
      return Left(DatabaseFailure(e.message));
    } catch (e, st) {
      AppLogger.e('Unexpected updateTodo error', stackTrace: st);
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, TodoEntity>> toggleStatus(int todoId) async {
    try {
      final model = await _dataSource.toggleStatus(todoId);
      return Right(TodoMapper.toEntity(model));
    } on AppException catch (e, st) {
      AppLogger.e('toggleStatus failed', error: e.message, stackTrace: st);
      return Left(DatabaseFailure(e.message));
    } catch (e, st) {
      AppLogger.e('Unexpected toggleStatus error', stackTrace: st);
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTodo(int todoId) async {
    try {
      await _dataSource.deleteTodo(todoId);
      return const Right(unit);
    } on AppException catch (e, st) {
      AppLogger.e('deleteTodo failed', error: e.message, stackTrace: st);
      return Left(DatabaseFailure(e.message));
    } catch (e, st) {
      AppLogger.e('Unexpected deleteTodo error', stackTrace: st);
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> clearAllTodos(int userId) async {
    try {
      await _dataSource.clearAllTodos(userId);
      return const Right(unit);
    } on AppException catch (e, st) {
      AppLogger.e('clearAllTodos failed', error: e.message, stackTrace: st);
      return Left(DatabaseFailure(e.message));
    } catch (e, st) {
      AppLogger.e('Unexpected clearAllTodos error', stackTrace: st);
      return const Left(UnexpectedFailure());
    }
  }
}
