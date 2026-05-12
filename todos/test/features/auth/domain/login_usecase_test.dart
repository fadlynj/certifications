import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:todos/core/errors/failures.dart';
import 'package:todos/features/auth/domain/entities/session_entity.dart';
import 'package:todos/features/auth/domain/repositories/auth_repository.dart';
import 'package:todos/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  const params = LoginParams(username: 'admin', password: 'Admin@123');

  final session = SessionEntity(
    token: 'tok',
    userId: 1,
    username: 'admin',
    expiresAt: DateTime(2099),
  );

  test('returns SessionEntity on valid credentials', () async {
    when(
      () => mockRepository.login(
        username: params.username,
        password: params.password,
      ),
    ).thenAnswer((_) async => Right<Failure, SessionEntity>(session));

    final result = await useCase(params);

    expect(result, Right<Failure, SessionEntity>(session));
    verify(
      () => mockRepository.login(
        username: params.username,
        password: params.password,
      ),
    ).called(1);
  });

  test('returns InvalidCredentialsFailure on wrong credentials', () async {
    when(
      () => mockRepository.login(
        username: params.username,
        password: params.password,
      ),
    ).thenAnswer(
      (_) async =>
          const Left<Failure, SessionEntity>(InvalidCredentialsFailure()),
    );

    final result = await useCase(params);

    expect(
      result,
      const Left<Failure, SessionEntity>(InvalidCredentialsFailure()),
    );
  });

  test('returns AccountLockedFailure when account is locked', () async {
    when(
      () => mockRepository.login(
        username: params.username,
        password: params.password,
      ),
    ).thenAnswer(
      (_) async => const Left<Failure, SessionEntity>(AccountLockedFailure()),
    );

    final result = await useCase(params);

    expect(result, const Left<Failure, SessionEntity>(AccountLockedFailure()));
  });
}
