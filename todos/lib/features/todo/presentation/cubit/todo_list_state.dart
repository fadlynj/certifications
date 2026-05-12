import 'package:equatable/equatable.dart';

import '../../domain/entities/todo_entity.dart';

/// Filter options for the todo list.
enum TodoFilter { all, done, pending, important }

/// Sort options for the todo list.
enum TodoSort { createdDate, deadline, importance }

sealed class TodoListState extends Equatable {
  const TodoListState();
  @override
  List<Object?> get props => [];
}

final class TodoListInitial extends TodoListState {
  const TodoListInitial();
}

final class TodoListLoading extends TodoListState {
  const TodoListLoading();
}

final class TodoListLoaded extends TodoListState {
  const TodoListLoaded({
    required this.allTodos,
    this.filter = TodoFilter.all,
    this.sort = TodoSort.createdDate,
    this.searchQuery = '',
  });

  final List<TodoEntity> allTodos;
  final TodoFilter filter;
  final TodoSort sort;
  final String searchQuery;

  /// Applies filter, search and sort to [allTodos].
  List<TodoEntity> get displayedTodos {
    var result = allTodos.where((t) {
      // Filter
      final passesFilter = switch (filter) {
        TodoFilter.all => true,
        TodoFilter.done => t.isDone,
        TodoFilter.pending => !t.isDone,
        TodoFilter.important => t.isImportant,
      };
      // Search
      final q = searchQuery.trim().toLowerCase();
      final passesSearch =
          q.isEmpty ||
          t.title.toLowerCase().contains(q) ||
          (t.description?.toLowerCase().contains(q) ?? false);
      return passesFilter && passesSearch;
    }).toList();

    // Sort
    switch (sort) {
      case TodoSort.createdDate:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case TodoSort.deadline:
        result.sort((a, b) {
          if (a.deadline == null && b.deadline == null) return 0;
          if (a.deadline == null) return 1;
          if (b.deadline == null) return -1;
          return a.deadline!.compareTo(b.deadline!);
        });
      case TodoSort.importance:
        result.sort((a, b) {
          if (a.isImportant == b.isImportant) return 0;
          return a.isImportant ? -1 : 1;
        });
    }

    return result;
  }

  TodoListLoaded copyWith({
    List<TodoEntity>? allTodos,
    TodoFilter? filter,
    TodoSort? sort,
    String? searchQuery,
  }) => TodoListLoaded(
    allTodos: allTodos ?? this.allTodos,
    filter: filter ?? this.filter,
    sort: sort ?? this.sort,
    searchQuery: searchQuery ?? this.searchQuery,
  );

  @override
  List<Object?> get props => [allTodos, filter, sort, searchQuery];
}

final class TodoListError extends TodoListState {
  const TodoListError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
