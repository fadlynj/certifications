import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:todos/core/errors/failures.dart';
import 'package:todos/features/todo/domain/entities/todo_entity.dart';
import 'package:todos/features/todo/domain/usecases/delete_todo_usecase.dart';
import 'package:todos/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:todos/features/todo/domain/usecases/toggle_todo_status_usecase.dart';
import 'package:todos/features/todo/presentation/cubit/todo_list_cubit.dart';
import 'package:todos/features/todo/presentation/cubit/todo_list_state.dart';

class MockGetTodos extends Mock implements GetTodosUseCase {}

class MockToggleTodo extends Mock implements ToggleTodoStatusUseCase {}

class MockDeleteTodo extends Mock implements DeleteTodoUseCase {}

void main() {
  late MockGetTodos mockGetTodos;
  late MockToggleTodo mockToggleTodo;
  late MockDeleteTodo mockDeleteTodo;

  final todo1 = TodoEntity(
    id: 1,
    userId: 1,
    title: 'First',
    isDone: false,
    isImportant: true,
    createdAt: DateTime(2024),
    updatedAt: DateTime(2024),
  );
  final todo2 = TodoEntity(
    id: 2,
    userId: 1,
    title: 'Second',
    isDone: true,
    isImportant: false,
    createdAt: DateTime(2024),
    updatedAt: DateTime(2024),
  );

  setUp(() {
    mockGetTodos = MockGetTodos();
    mockToggleTodo = MockToggleTodo();
    mockDeleteTodo = MockDeleteTodo();
    registerFallbackValue(const GetTodosParams(userId: 1));
    registerFallbackValue(const ToggleTodoParams(todoId: 1));
    registerFallbackValue(const DeleteTodoParams(todoId: 1));
  });

  TodoListCubit buildCubit() => TodoListCubit(
    getTodos: mockGetTodos,
    toggleStatus: mockToggleTodo,
    deleteTodo: mockDeleteTodo,
  );

  blocTest<TodoListCubit, TodoListState>(
    'emits TodoListLoaded when todos load successfully',
    setUp: () {
      when(
        () => mockGetTodos.call(any()),
      ).thenAnswer((_) => Stream.value(Right([todo1, todo2])));
    },
    build: buildCubit,
    act: (c) => c.loadTodos(1),
    expect: () => [
      const TodoListLoading(),
      isA<TodoListLoaded>().having(
        (s) => s.allTodos.length,
        'allTodos length',
        2,
      ),
    ],
  );

  blocTest<TodoListCubit, TodoListState>(
    'emits TodoListError on failure',
    setUp: () {
      when(() => mockGetTodos.call(any())).thenAnswer(
        (_) => Stream.value(
          const Left<Failure, List<TodoEntity>>(DatabaseFailure('err')),
        ),
      );
    },
    build: buildCubit,
    act: (c) => c.loadTodos(1),
    expect: () => [const TodoListLoading(), isA<TodoListError>()],
  );

  blocTest<TodoListCubit, TodoListState>(
    'filters todos by done status',
    setUp: () {
      when(
        () => mockGetTodos.call(any()),
      ).thenAnswer((_) => Stream.value(Right([todo1, todo2])));
    },
    build: buildCubit,
    act: (c) async {
      c.loadTodos(1);
      await Future<void>.delayed(Duration.zero);
      c.setFilter(TodoFilter.done);
    },
    expect: () => [
      const TodoListLoading(),
      isA<TodoListLoaded>(),
      isA<TodoListLoaded>().having(
        (s) => s.displayedTodos.every((t) => t.isDone),
        'only done todos',
        true,
      ),
    ],
  );
}
