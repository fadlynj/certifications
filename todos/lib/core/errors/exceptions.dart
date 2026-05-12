// Application-layer exceptions thrown by data sources.
// These are caught by repositories and mapped to Failure objects.

/// Base application exception.
class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => 'AppException: $message';
}

class DatabaseException extends AppException {
  const DatabaseException([super.message = 'Database error']);
}

class SecureStorageException extends AppException {
  const SecureStorageException([super.message = 'Secure storage error']);
}

class AuthException extends AppException {
  const AuthException([super.message = 'Authentication error']);
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException() : super('Invalid credentials');
}

class AccountLockedException extends AuthException {
  const AccountLockedException() : super('Account locked');
}

class SessionExpiredException extends AuthException {
  const SessionExpiredException() : super('Session expired');
}

class UserNotFoundException extends AppException {
  const UserNotFoundException() : super('User not found');
}

class UserAlreadyExistsException extends AppException {
  const UserAlreadyExistsException() : super('User already exists');
}
