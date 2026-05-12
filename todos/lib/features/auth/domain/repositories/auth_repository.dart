// Auth repository contract — implemented in the data layer.
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/session_entity.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Validates credentials and returns a new [SessionEntity] on success.
  Future<Either<Failure, SessionEntity>> login({
    required String username,
    required String password,
  });

  /// Invalidates the current session token in both DB and secure storage.
  Future<Either<Failure, Unit>> logout({required String token});

  /// Looks up the stored token and validates it against the DB.
  /// Returns null when no session is found.
  Future<Either<Failure, SessionEntity?>> getCurrentSession();

  /// Creates the initial user (used for seed / first-run setup).
  Future<Either<Failure, UserEntity>> registerInitialUser({
    required String username,
    required String password,
  });

  /// Resets the password for [username] after verifying [currentPassword].
  Future<Either<Failure, Unit>> resetPassword({
    required String username,
    required String currentPassword,
    required String newPassword,
  });
}
