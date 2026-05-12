import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_flushbar.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../auth/presentation/cubit/form_inputs.dart';
import '../cubit/add_todo_cubit.dart';
import '../cubit/add_todo_state.dart';

class AddTodoPage extends StatelessWidget {
  const AddTodoPage({super.key, this.isImportantDefault = false});

  final bool isImportantDefault;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddTodoCubit, AddTodoState>(
      listener: (context, state) {
        if (state is AddTodoSuccess) {
          context.pop(true);
        }
        if (state is AddTodoError) {
          AppFlushbar.error(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isImportantDefault
                ? AppStrings.addImportantTodo
                : AppStrings.addTodo,
          ),
        ),
        body: const _AddTodoBody(),
      ),
    );
  }
}

class _AddTodoBody extends StatelessWidget {
  const _AddTodoBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTodoCubit, AddTodoState>(
      builder: (context, state) {
        final form = state is AddTodoForm ? state : const AddTodoForm();
        final isSubmitting = form.status == FormzSubmissionStatus.inProgress;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              AppTextField(
                label: 'Judul',
                hint: AppStrings.titleHint,
                maxLength: 100,
                textInputAction: TextInputAction.next,
                enabled: !isSubmitting,
                errorText: _titleError(form.title),
                onChanged: context.read<AddTodoCubit>().titleChanged,
              ),
              const SizedBox(height: AppSpacing.md),

              // Description
              AppTextField(
                label: 'Deskripsi',
                hint: AppStrings.descriptionHint,
                maxLength: 500,
                maxLines: 4,
                enabled: !isSubmitting,
                errorText: _descError(form.description),
                onChanged: context.read<AddTodoCubit>().descriptionChanged,
              ),
              const SizedBox(height: AppSpacing.md),

              // Deadline picker
              _DeadlinePicker(deadline: form.deadline, enabled: !isSubmitting),
              const SizedBox(height: AppSpacing.md),

              // Important toggle — flat, no Card wrapping
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderLight),
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                ),
                child: SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 4,
                  ),
                  title: const Text(
                    AppStrings.markImportant,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  secondary: Icon(
                    Icons.star_rounded,
                    color: form.isImportant
                        ? AppColors.warning
                        : AppColors.borderLight,
                    size: 22,
                  ),
                  value: form.isImportant,
                  onChanged: isSubmitting
                      ? null
                      : (_) => context.read<AddTodoCubit>().toggleImportant(),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Submit
              AppButton(
                label: AppStrings.save,
                isLoading: isSubmitting,
                onPressed: isSubmitting
                    ? null
                    : context.read<AddTodoCubit>().submit,
              ),
            ],
          ),
        );
      },
    );
  }

  String? _titleError(TitleInput input) {
    if (input.isPure) return null;
    return switch (input.displayError) {
      TitleValidationError.empty => AppStrings.titleRequired,
      TitleValidationError.tooLong => AppStrings.titleTooLong,
      null => null,
    };
  }

  String? _descError(DescriptionInput input) {
    if (input.isPure) return null;
    return switch (input.displayError) {
      DescriptionValidationError.tooLong => AppStrings.descTooLong,
      null => null,
    };
  }
}

class _DeadlinePicker extends StatelessWidget {
  const _DeadlinePicker({this.deadline, required this.enabled});

  final DateTime? deadline;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 4,
        ),
        leading: Icon(
          Icons.calendar_today_outlined,
          size: 20,
          color: deadline != null ? AppColors.primary : AppColors.subtleLight,
        ),
        title: Text(
          deadline != null
              ? DateFormatter.formatDate(deadline!)
              : 'Belum ada tenggat waktu',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: deadline != null ? null : AppColors.subtleLight,
          ),
        ),
        trailing: deadline != null
            ? IconButton(
                icon: const Icon(
                  Icons.clear_rounded,
                  size: 18,
                  color: AppColors.subtleLight,
                ),
                onPressed: enabled
                    ? () => context.read<AddTodoCubit>().deadlineChanged(null)
                    : null,
              )
            : const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.subtleLight,
              ),
        onTap: enabled ? () => _pickDate(context) : null,
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: deadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null && context.mounted) {
      context.read<AddTodoCubit>().deadlineChanged(picked);
    }
  }
}
