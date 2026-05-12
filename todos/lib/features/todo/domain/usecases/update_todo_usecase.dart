import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class UpdateTodoUseCase extends UseCase<TodoEntity, TodoEntity> {
  UpdateTodoUseCase(this._repository);

  final TodoRepository _repository;

  @override
  Future<Either<Failure, TodoEntity>> call(TodoEntity params) =>
      _repository.updateTodo(params);
}
