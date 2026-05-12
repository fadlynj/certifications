import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

/// Aggregates completed-todo counts per weekday for the current ISO week.
class GetWeeklyStatsUseCase
    extends UseCase<List<DayStats>, GetWeeklyStatsParams> {
  GetWeeklyStatsUseCase(this._repository);

  final TodoRepository _repository;

  @override
  Future<Either<Failure, List<DayStats>>> call(
    GetWeeklyStatsParams params,
  ) async {
    final weekStart = DateTime.now().startOfWeek;
    final result = await _repository.getCompletedSince(
      params.userId,
      weekStart,
    );

    return result.map((todos) => _aggregate(todos, weekStart));
  }

  /// Groups todos by weekday into 7 [DayStats] entries (Mon → Sun).
  List<DayStats> _aggregate(List<TodoEntity> todos, DateTime weekStart) {
    final counts = List.filled(7, 0);
    for (final todo in todos) {
      if (todo.completedAt == null) continue;
      final dayIndex = todo.completedAt!.weekday - 1; // 0=Mon, 6=Sun
      if (dayIndex >= 0 && dayIndex < 7) counts[dayIndex]++;
    }
    return List.generate(
      7,
      (i) => DayStats(
        day: weekStart.add(Duration(days: i)),
        count: counts[i],
      ),
    );
  }
}

class GetWeeklyStatsParams extends Equatable {
  const GetWeeklyStatsParams({required this.userId});
  final int userId;
  @override
  List<Object?> get props => [userId];
}

class DayStats extends Equatable {
  const DayStats({required this.day, required this.count});
  final DateTime day;
  final int count;
  @override
  List<Object?> get props => [day, count];
}
