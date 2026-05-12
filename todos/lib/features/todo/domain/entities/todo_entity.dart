import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  const TodoEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.isDone,
    required this.isImportant,
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
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isOverdue =>
      !isDone && deadline != null && deadline!.isBefore(DateTime.now());

  TodoEntity copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    DateTime? deadline,
    bool? isDone,
    bool? isImportant,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearDeadline = false,
    bool clearCompletedAt = false,
    bool clearDescription = false,
  }) => TodoEntity(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    description: clearDescription ? null : description ?? this.description,
    deadline: clearDeadline ? null : deadline ?? this.deadline,
    isDone: isDone ?? this.isDone,
    isImportant: isImportant ?? this.isImportant,
    completedAt: clearCompletedAt ? null : completedAt ?? this.completedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    description,
    deadline,
    isDone,
    isImportant,
    completedAt,
    createdAt,
    updatedAt,
  ];
}
