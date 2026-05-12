import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:todos/core/errors/failures.dart';
import 'package:todos/core/usecases/usecase.dart';
import 'package:todos/features/auth/domain/entities/session_entity.dart';
import 'package:todos/features/auth/domain/usecases/get_current_session_usecase.dart';
import 'package:todos/features/auth/domain/usecases/login_usecase.dart';
import 'package:todos/features/auth/domain/usecases/logout_usecase.dart';
import 'package:todos/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:todos/features/auth/presentation/cubit/auth_state.dart';

class MockGetCurrentSession extends Mock implements GetCurrentSessionUseCase {}

class MockLogin extends Mock implements LoginUseCase {}

class MockLogout extends Mock implements LogoutUseCase {}

void main() {
  late MockGetCurrentSession mockGetCurrentSession;
  late MockLogin mockLogin;
  late MockLogout mockLogout;

  setUp(() {
    mockGetCurrentSession = MockGetCurrentSession();
    mockLogin = MockLogin();
    mockLogout = MockLogout();
    registerFallbackValue(const NoParams());
    registerFallbackValue(const LoginParams(username: '', password: ''));
  });

  AuthCubit buildCubit() => AuthCubit(
    getCurrentSession: mockGetCurrentSession,
    login: mockLogin,
    logout: mockLogout,
  );

  final session = SessionEntity(
    token: 'token',
    userId: 1,
    username: 'admin',
    expiresAt: DateTime.now().add(const Duration(days: 7)),
  );

  group('checkCurrentSession', () {
    blocTest<AuthCubit, AuthState>(
      'emits AuthAuthenticated when session exists',
      build: buildCubit,
      setUp: () {
        when(
          () => mockGetCurrentSession(any()),
        ).thenAnswer((_) async => Right(session));
      },
      act: (cubit) => cubit.checkCurrentSession(),
      expect: () => [const AuthLoading(), AuthAuthenticated(session: session)],
    );

    blocTest<AuthCubit, AuthState>(
      'emits AuthUnauthenticated when no session',
      build: buildCubit,
      setUp: () {
        when(
          () => mockGetCurrentSession(any()),
        ).thenAnswer((_) async => const Left(SessionExpiredFailure()));
      },
      act: (cubit) => cubit.checkCurrentSession(),
      expect: () => [const AuthLoading(), const AuthUnauthenticated()],
    );
  });

  group('openLoginForm + usernameChanged + passwordChanged', () {
    blocTest<AuthCubit, AuthState>(
      'emits AuthLoginForm when opening form',
      build: buildCubit,
      act: (cubit) => cubit.openLoginForm(),
      expect: () => [isA<AuthLoginForm>()],
    );

    blocTest<AuthCubit, AuthState>(
      'updates username in AuthLoginForm',
      build: buildCubit,
      seed: () => const AuthLoginForm(),
      act: (cubit) => cubit.usernameChanged('admin'),
      expect: () => [
        isA<AuthLoginForm>().having(
          (s) => s.username.value,
          'username.value',
          'admin',
        ),
      ],
    );
  });
}
