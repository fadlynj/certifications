// Domain-layer Failure hierarchy.
// Every use-case returns Either<Failure, T>.
import 'package:equatable/equatable.dart';

/// Base class for all domain failures.
abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// ── Auth failures ─────────────────────────────────────────────────────────

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure() : super('Invalid username or password.');
}

class AccountLockedFailure extends Failure {
  const AccountLockedFailure() : super('Account temporarily locked.');
}

class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure() : super('Session has expired.');
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure() : super('User not found.');
}

class UserAlreadyExistsFailure extends Failure {
  const UserAlreadyExistsFailure() : super('Username is already taken.');
}

class PasswordMismatchFailure extends Failure {
  const PasswordMismatchFailure() : super('Passwords do not match.');
}

// ── Todo failures ─────────────────────────────────────────────────────────

class TodoNotFoundFailure extends Failure {
  const TodoNotFoundFailure() : super('Todo not found.');
}

// ── Database / storage failures ───────────────────────────────────────────

class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'A database error occurred.']);
}

class SecureStorageFailure extends Failure {
  const SecureStorageFailure([super.message = 'Secure storage error.']);
}

// ── Generic failures ────────────────────────────────────────────────────────────────────────────

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
