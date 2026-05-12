// Table definition for the `todos` table.
// Supports soft-delete via [isDeleted] and reactive streams via Drift.
import 'package:drift/drift.dart';

import 'users_table.dart';

/// Represents a single todo item belonging to a user.
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key → Users.id
  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();

  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().withLength(max: 500).nullable()();
  DateTimeColumn get deadline => dateTime().nullable()();

  BoolColumn get isDone => boolean().withDefault(const Constant(false))();

  BoolColumn get isImportant => boolean().withDefault(const Constant(false))();

  /// Soft-delete flag — items with true are excluded from all queries.
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  /// Set when [isDone] transitions to true; cleared on un-complete.
  DateTimeColumn get completedAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  List<Index> get indexes => [
    Index(
      'todos_user_id_idx',
      'CREATE INDEX todos_user_id_idx ON todos (user_id)',
    ),
    Index(
      'todos_is_done_idx',
      'CREATE INDEX todos_is_done_idx ON todos (is_done)',
    ),
  ];
}
