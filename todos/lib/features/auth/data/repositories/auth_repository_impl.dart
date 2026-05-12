// Auth repository implementation — maps data-layer exceptions to domain Failures.
import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/logger_service.dart';
import '../../domain/entities/session_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../mappers/session_mapper.dart';
import '../mappers/user_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final AuthLocalDataSource _dataSource;

  @override
  Future<Either<Failure, SessionEntity>> login({
    required String username,
    required String password,
  }) async {
    try {
      final model = await _dataSource.login(
        username: username,
        password: password,
      );
      return Right(SessionMapper.toEntity(model));
    } on AccountLockedException {
      return const Left(AccountLockedFailure());
    } on InvalidCredentialsException {
      return const Left(InvalidCredentialsFailure());
    } on AppException catch (e, st) {
      AppLogger.e('Login failed', error: e.message, stackTrace: st);
      return Left(DatabaseFailure(e.message));
    } catch (e, st) {
      AppLogger.e('Unexpected login error', stackTrace: st);
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> logout({required String token}) async {
    try {
      await _dataSource.logout(token: token);
      return const Right(unit);
    } on AppException catch (e, st) {
      AppLogger.e('Logout failed', error: e.message, stackTrace: st);
      return Left(DatabaseFailure(e.message));
    } catch (e, st) {
      AppLogger.e('Unexpected logout error', stackTrace: st);
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, SessionEntity?>> getCurrentSession() async {
    try {
      final model = await _dataSource.getCurrentSession();
      if (model == null) return const Right(null);
      return Right(SessionMapper.toEntity(model));
    } on SessionExpiredException {
      return const Left(SessionExpiredFailure());
    } on AppException catch (e, st) {
      AppLogger.e('GetCurrentSession failed', error: e.message, stackTrace: st);
      return Left(DatabaseFailure(e.message));
    } catch (e, st) {
      AppLogger.e('Unexpected getCurrentSession error', stackTrace: st);
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerInitialUser({
    required String username,
    required String password,
  }) async {
    try {
      final model = await _dataSource.registerInitialUser(
        username: username,
        password: password,
      );
      return Right(UserMapper.toEntity(model));
    } on UserAlreadyExistsException {
      return const Left(UserAlreadyExistsFailure());
    } on AppException catch (e, st) {
      AppLogger.e(
        'RegisterInitialUser failed',
        error: e.message,
        stackTrace: st,
      );
      return Left(DatabaseFailure(e.message));
    } catch (e, st) {
      AppLogger.e('Unexpected register error', stackTrace: st);
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String username,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dataSource.resetPassword(
        username: username,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(unit);
    } on UserNotFoundException {
      return const Left(UserNotFoundFailure());
    } on InvalidCredentialsException {
      return const Left(InvalidCredentialsFailure());
    } on AppException catch (e, st) {
      AppLogger.e('ResetPassword failed', error: e.message, stackTrace: st);
      return Left(DatabaseFailure(e.message));
    } catch (e, st) {
      AppLogger.e('Unexpected resetPassword error', stackTrace: st);
      return const Left(UnexpectedFailure());
    }
  }
}
