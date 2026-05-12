import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:todos/core/errors/failures.dart';
import 'package:todos/features/todo/domain/entities/todo_entity.dart';
import 'package:todos/features/todo/domain/repositories/todo_repository.dart';
import 'package:todos/features/todo/domain/usecases/create_todo_usecase.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late CreateTodoUseCase useCase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = CreateTodoUseCase(mockRepository);
  });

  final todo = TodoEntity(
    id: 1,
    userId: 1,
    title: 'Buy groceries',
    isDone: false,
    isImportant: false,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  test('creates a todo and returns the entity', () async {
    when(
      () => mockRepository.createTodo(
        userId: any(named: 'userId'),
        title: any(named: 'title'),
        description: any(named: 'description'),
        deadline: any(named: 'deadline'),
        isImportant: any(named: 'isImportant'),
      ),
    ).thenAnswer((_) async => Right<Failure, TodoEntity>(todo));

    final result = await useCase(
      const CreateTodoParams(userId: 1, title: 'Buy groceries'),
    );

    expect(result, Right<Failure, TodoEntity>(todo));
  });

  test('returns failure when repository fails', () async {
    when(
      () => mockRepository.createTodo(
        userId: any(named: 'userId'),
        title: any(named: 'title'),
        description: any(named: 'description'),
        deadline: any(named: 'deadline'),
        isImportant: any(named: 'isImportant'),
      ),
    ).thenAnswer(
      (_) async => const Left<Failure, TodoEntity>(DatabaseFailure('db error')),
    );

    final result = await useCase(
      const CreateTodoParams(userId: 1, title: 'Test'),
    );

    expect(
      result,
      const Left<Failure, TodoEntity>(DatabaseFailure('db error')),
    );
  });
}
