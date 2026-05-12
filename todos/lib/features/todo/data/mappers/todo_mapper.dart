// Maps between drift Todo rows, TodoModel and TodoEntity.
import 'package:drift/drift.dart' show Value;

import '../../../../database/app_database.dart';
import '../../domain/entities/todo_entity.dart';
import '../models/todo_model.dart';

class TodoMapper {
  const TodoMapper._();

  // Drift row → data model
  static TodoModel fromRow(Todo row) => TodoModel(
    id: row.id,
    userId: row.userId,
    title: row.title,
    description: row.description,
    deadline: row.deadline,
    isDone: row.isDone,
    isImportant: row.isImportant,
    isDeleted: row.isDeleted,
    completedAt: row.completedAt,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );

  // Data model → domain entity
  static TodoEntity toEntity(TodoModel model) => TodoEntity(
    id: model.id,
    userId: model.userId,
    title: model.title,
    description: model.description,
    deadline: model.deadline,
    isDone: model.isDone,
    isImportant: model.isImportant,
    completedAt: model.completedAt,
    createdAt: model.createdAt,
    updatedAt: model.updatedAt,
  );

  // Domain entity → drift companion for updates
  static TodosCompanion toCompanion(TodoEntity entity) => TodosCompanion(
    id: Value(entity.id),
    userId: Value(entity.userId),
    title: Value(entity.title),
    description: Value(entity.description),
    deadline: Value(entity.deadline),
    isDone: Value(entity.isDone),
    isImportant: Value(entity.isImportant),
    completedAt: Value(entity.completedAt),
    updatedAt: Value(DateTime.now()),
  );

  // New todo fields → drift companion for inserts
  static TodosCompanion toInsertCompanion({
    required int userId,
    required String title,
    String? description,
    DateTime? deadline,
    bool isImportant = false,
  }) => TodosCompanion.insert(
    userId: userId,
    title: title,
    description: Value(description),
    deadline: Value(deadline),
    isImportant: Value(isImportant),
  );
}
