import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_todos_usecase.dart';
import '../../domain/usecases/get_weekly_stats_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required GetTodosUseCase getTodos,
    required GetWeeklyStatsUseCase getWeeklyStats,
  }) : _getTodos = getTodos,
       _getWeeklyStats = getWeeklyStats,
       super(const HomeInitial());

  final GetTodosUseCase _getTodos;
  final GetWeeklyStatsUseCase _getWeeklyStats;
  StreamSubscription<dynamic>? _todosSubscription;
  int? _currentUserId;

  /// Start watching todos for [userId]. Automatically refreshes chart stats
  /// whenever the todo stream emits a new list.
  void loadHome(int userId) {
    _currentUserId = userId;
    emit(const HomeLoading());

    _todosSubscription?.cancel();
    _todosSubscription = _getTodos(GetTodosParams(userId: userId)).listen((
      result,
    ) {
      result.fold((failure) => emit(HomeError(message: failure.message)), (
        todos,
      ) async {
        // Reload weekly stats every time the list changes
        final statsResult = await _getWeeklyStats(
          GetWeeklyStatsParams(userId: userId),
        );
        statsResult.fold(
          (failure) => emit(HomeError(message: failure.message)),
          (stats) => emit(HomeLoaded(todos: todos, weeklyStats: stats)),
        );
      });
    });
  }

  Future<void> refreshStats() async {
    if (_currentUserId == null) return;
    final current = state;
    if (current is! HomeLoaded) return;

    final result = await _getWeeklyStats(
      GetWeeklyStatsParams(userId: _currentUserId!),
    );
    result.fold(
      (_) {}, // silent — stats refresh failure is non-critical
      (stats) => emit(HomeLoaded(todos: current.todos, weeklyStats: stats)),
    );
  }

  @override
  Future<void> close() {
    _todosSubscription?.cancel();
    return super.close();
  }
}
