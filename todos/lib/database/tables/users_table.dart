// Table definition for the `users` table.
// Drift generates a `User` data class from this table.
import 'package:drift/drift.dart';

/// Stores registered users.
/// Passwords are NEVER stored in plain text — only [passwordHash] + [salt].
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().withLength(min: 3, max: 50).unique()();

  /// SHA-256 hash of (password + salt), iterated 10 000 times.
  TextColumn get passwordHash => text()();

  /// Cryptographically-random 32-byte salt (base64-encoded).
  TextColumn get salt => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
