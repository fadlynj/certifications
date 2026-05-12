import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class ToggleTodoStatusUseCase extends UseCase<TodoEntity, ToggleTodoParams> {
  ToggleTodoStatusUseCase(this._repository);

  final TodoRepository _repository;

  @override
  Future<Either<Failure, TodoEntity>> call(ToggleTodoParams params) =>
      _repository.toggleStatus(params.todoId);
}

class ToggleTodoParams extends Equatable {
  const ToggleTodoParams({required this.todoId});
  final int todoId;
  @override
  List<Object?> get props => [todoId];
}
