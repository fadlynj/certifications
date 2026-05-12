import 'package:equatable/equatable.dart';

import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/get_weekly_stats_usecase.dart';

sealed class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({required this.todos, required this.weeklyStats});

  final List<TodoEntity> todos;
  final List<DayStats> weeklyStats;

  int get totalCount => todos.length;
  int get doneCount => todos.where((t) => t.isDone).length;
  int get pendingCount => todos.where((t) => !t.isDone).length;

  @override
  List<Object?> get props => [todos, weeklyStats];
}

final class HomeError extends HomeState {
  const HomeError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
