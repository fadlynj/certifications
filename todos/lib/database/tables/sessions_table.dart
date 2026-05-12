// Table definition for the `sessions` table.
// Stores active session tokens for persisted authentication.
import 'package:drift/drift.dart';

import 'users_table.dart';

/// Persists active login sessions.
/// The token is also mirrored in [flutter_secure_storage] for fast in-memory
/// access without a DB round-trip on every page guard check.
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key → Users.id; cascades on user deletion.
  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();

  /// UUID v4 token — kept in secure storage during the session.
  TextColumn get token => text().unique()();

  DateTimeColumn get expiresAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
