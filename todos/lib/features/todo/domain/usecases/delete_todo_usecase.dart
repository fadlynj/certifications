import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/todo_repository.dart';

class DeleteTodoUseCase extends UseCase<Unit, DeleteTodoParams> {
  DeleteTodoUseCase(this._repository);

  final TodoRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(DeleteTodoParams params) =>
      _repository.deleteTodo(params.todoId);
}

class DeleteTodoParams extends Equatable {
  const DeleteTodoParams({required this.todoId});
  final int todoId;
  @override
  List<Object?> get props => [todoId];
}
