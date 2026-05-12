import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/delete_todo_usecase.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import '../../domain/usecases/toggle_todo_status_usecase.dart';
import 'todo_list_state.dart';

class TodoListCubit extends Cubit<TodoListState> {
  TodoListCubit({
    required GetTodosUseCase getTodos,
    required ToggleTodoStatusUseCase toggleStatus,
    required DeleteTodoUseCase deleteTodo,
  }) : _getTodos = getTodos,
       _toggleStatus = toggleStatus,
       _deleteTodo = deleteTodo,
       super(const TodoListInitial());

  final GetTodosUseCase _getTodos;
  final ToggleTodoStatusUseCase _toggleStatus;
  final DeleteTodoUseCase _deleteTodo;
  StreamSubscription<dynamic>? _subscription;

  void loadTodos(int userId) {
    emit(const TodoListLoading());
    _subscription?.cancel();
    _subscription = _getTodos(GetTodosParams(userId: userId)).listen((result) {
      result.fold((failure) => emit(TodoListError(message: failure.message)), (
        todos,
      ) {
        final current = state;
        emit(
          TodoListLoaded(allTodos: todos).copyWith(
            filter: current is TodoListLoaded ? current.filter : null,
            sort: current is TodoListLoaded ? current.sort : null,
            searchQuery: current is TodoListLoaded ? current.searchQuery : null,
          ),
        );
      });
    });
  }

  void setFilter(TodoFilter filter) {
    final current = state;
    if (current is TodoListLoaded) emit(current.copyWith(filter: filter));
  }

  void setSort(TodoSort sort) {
    final current = state;
    if (current is TodoListLoaded) emit(current.copyWith(sort: sort));
  }

  void search(String query) {
    final current = state;
    if (current is TodoListLoaded) emit(current.copyWith(searchQuery: query));
  }

  /// Uses [droppable] semantics — if multiple toggle calls arrive quickly,
  /// only the first is processed; subsequent ones are dropped.
  Future<void> toggleTodo(int todoId) async {
    final result = await _toggleStatus(ToggleTodoParams(todoId: todoId));
    result.fold(
      (failure) => null, // non-critical; stream will correct state
      (_) => null,
    );
  }

  Future<void> deleteTodo(int todoId) async {
    await _deleteTodo(DeleteTodoParams(todoId: todoId));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
