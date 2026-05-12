// Data model — mirrors the drift-generated `Todo` row.
import 'package:equatable/equatable.dart';

class TodoModel extends Equatable {
  const TodoModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.isDone,
    required this.isImportant,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.deadline,
    this.completedAt,
  });

  final int id;
  final int userId;
  final String title;
  final String? description;
  final DateTime? deadline;
  final bool isDone;
  final bool isImportant;
  final bool isDeleted;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [id, userId, title, isDone, createdAt];
}
