import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../../features/auth/presentation/cubit/form_inputs.dart';
import '../../domain/usecases/create_todo_usecase.dart';
import 'add_todo_state.dart';

class AddTodoCubit extends Cubit<AddTodoState> {
  AddTodoCubit({
    required CreateTodoUseCase createTodo,
    required int userId,
    bool isImportantDefault = false,
  }) : _createTodo = createTodo,
       _userId = userId,
       super(AddTodoForm(isImportant: isImportantDefault));

  final CreateTodoUseCase _createTodo;
  final int _userId;

  void titleChanged(String value) {
    final current = _form;
    emit(current.copyWith(title: TitleInput.dirty(value), clearError: true));
  }

  void descriptionChanged(String value) {
    final current = _form;
    emit(
      current.copyWith(
        description: DescriptionInput.dirty(value),
        clearError: true,
      ),
    );
  }

  void deadlineChanged(DateTime? date) {
    final current = _form;
    emit(current.copyWith(deadline: date, clearDeadline: date == null));
  }

  void toggleImportant() {
    final current = _form;
    emit(current.copyWith(isImportant: !current.isImportant));
  }

  Future<void> submit() async {
    final current = _form;

    // Validate all fields
    emit(
      current.copyWith(
        title: TitleInput.dirty(current.title.value),
        description: DescriptionInput.dirty(current.description.value),
      ),
    );

    if (!current.isValid) return;

    emit(current.copyWith(status: FormzSubmissionStatus.inProgress));

    final result = await _createTodo(
      CreateTodoParams(
        userId: _userId,
        title: current.title.value,
        description: current.description.value.trim().isEmpty
            ? null
            : current.description.value,
        deadline: current.deadline,
        isImportant: current.isImportant,
      ),
    );

    result.fold(
      (failure) => emit(
        current.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(const AddTodoSuccess()),
    );
  }

  AddTodoForm get _form =>
      state is AddTodoForm ? state as AddTodoForm : const AddTodoForm();
}
