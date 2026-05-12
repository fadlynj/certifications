import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

/// Returns a reactive stream of all todos for [userId].
class GetTodosUseCase extends StreamUseCase<List<TodoEntity>, GetTodosParams> {
  GetTodosUseCase(this._repository);

  final TodoRepository _repository;

  @override
  Stream<Either<Failure, List<TodoEntity>>> call(GetTodosParams params) =>
      _repository.watchTodos(params.userId);
}

class GetTodosParams extends Equatable {
  const GetTodosParams({required this.userId});
  final int userId;
  @override
  List<Object?> get props => [userId];
}
