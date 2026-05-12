import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:todos/core/errors/failures.dart';
import 'package:todos/features/todo/domain/repositories/todo_repository.dart';
import 'package:todos/features/todo/domain/usecases/get_weekly_stats_usecase.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late GetWeeklyStatsUseCase useCase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = GetWeeklyStatsUseCase(mockRepository);
    registerFallbackValue(const GetWeeklyStatsParams(userId: 1));
  });

  test('returns 7 DayStats entries covering the full week', () async {
    when(
      () => mockRepository.getCompletedSince(any(), any()),
    ).thenAnswer((_) async => const Right([]));

    final result = await useCase(const GetWeeklyStatsParams(userId: 1));

    result.fold(
      (f) => fail('Expected Right but got $f'),
      (stats) => expect(stats.length, 7),
    );
  });

  test('returns failure when repository fails', () async {
    when(
      () => mockRepository.getCompletedSince(any(), any()),
    ).thenAnswer((_) async => const Left(DatabaseFailure('err')));

    final result = await useCase(const GetWeeklyStatsParams(userId: 1));

    expect(result.isLeft(), true);
  });
}
