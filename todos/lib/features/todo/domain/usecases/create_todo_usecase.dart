import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class CreateTodoUseCase extends UseCase<TodoEntity, CreateTodoParams> {
  CreateTodoUseCase(this._repository);

  final TodoRepository _repository;

  @override
  Future<Either<Failure, TodoEntity>> call(CreateTodoParams params) =>
      _repository.createTodo(
        userId: params.userId,
        title: params.title,
        description: params.description,
        deadline: params.deadline,
        isImportant: params.isImportant,
      );
}

class CreateTodoParams extends Equatable {
  const CreateTodoParams({
    required this.userId,
    required this.title,
    this.description,
    this.deadline,
    this.isImportant = false,
  });

  final int userId;
  final String title;
  final String? description;
  final DateTime? deadline;
  final bool isImportant;

  @override
  List<Object?> get props => [
    userId,
    title,
    description,
    deadline,
    isImportant,
  ];
}
