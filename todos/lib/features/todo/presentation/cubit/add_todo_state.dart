import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../../features/auth/presentation/cubit/form_inputs.dart';

sealed class AddTodoState extends Equatable {
  const AddTodoState();
  @override
  List<Object?> get props => [];
}

final class AddTodoForm extends AddTodoState {
  const AddTodoForm({
    this.title = const TitleInput.pure(),
    this.description = const DescriptionInput.pure(),
    this.deadline,
    this.isImportant = false,
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final TitleInput title;
  final DescriptionInput description;
  final DateTime? deadline;
  final bool isImportant;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  bool get isValid => Formz.validate([title, description]);

  AddTodoForm copyWith({
    TitleInput? title,
    DescriptionInput? description,
    DateTime? deadline,
    bool? isImportant,
    FormzSubmissionStatus? status,
    String? errorMessage,
    bool clearDeadline = false,
    bool clearError = false,
  }) => AddTodoForm(
    title: title ?? this.title,
    description: description ?? this.description,
    deadline: clearDeadline ? null : deadline ?? this.deadline,
    isImportant: isImportant ?? this.isImportant,
    status: status ?? this.status,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [
    title,
    description,
    deadline,
    isImportant,
    status,
    errorMessage,
  ];
}

final class AddTodoSuccess extends AddTodoState {
  const AddTodoSuccess();
}

final class AddTodoError extends AddTodoState {
  const AddTodoError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
