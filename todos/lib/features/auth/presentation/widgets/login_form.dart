import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_flushbar.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../cubit/form_inputs.dart';

/// The main login form widget â€” stateless; all state lives in [AuthCubit].
class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (prev, curr) => curr is AuthLoginForm && prev != curr,
      listener: (context, state) {
        if (state is AuthLoginForm &&
            state.status == FormzSubmissionStatus.failure &&
            state.errorMessage != null) {
          AppFlushbar.error(context, state.errorMessage!);
        }
      },
      buildWhen: (prev, curr) => curr is AuthLoginForm,
      builder: (context, state) {
        final form = state is AuthLoginForm ? state : const AuthLoginForm();
        final isSubmitting = form.status == FormzSubmissionStatus.inProgress;

        return AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Username
              AppTextField(
                label: AppStrings.username,
                hint: 'Masukkan nama pengguna',
                autofillHints: const [AutofillHints.username],
                textInputAction: TextInputAction.next,
                enabled: !isSubmitting,
                errorText: _usernameError(form.username),
                onChanged: context.read<AuthCubit>().usernameChanged,
              ),
              const SizedBox(height: AppSpacing.md),

              // Password
              AppTextField(
                label: AppStrings.password,
                hint: 'Masukkan kata sandi',
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.done,
                obscureText: !form.isPasswordVisible,
                enabled: !isSubmitting,
                errorText: _passwordError(form.password),
                onChanged: context.read<AuthCubit>().passwordChanged,
                onSubmitted: (_) => context.read<AuthCubit>().submitLogin(),
                suffixIcon: IconButton(
                  icon: Icon(
                    form.isPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.subtleLight,
                    size: 20,
                  ),
                  onPressed: context.read<AuthCubit>().togglePasswordVisibility,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Submit button
              AppButton(
                label: AppStrings.loginButton,
                isLoading: isSubmitting,
                onPressed: isSubmitting
                    ? null
                    : context.read<AuthCubit>().submitLogin,
              ),
            ],
          ),
        );
      },
    );
  }

  String? _usernameError(UsernameInput input) {
    if (input.isPure) return null;
    return switch (input.displayError) {
      UsernameValidationError.empty => AppStrings.usernameEmpty,
      UsernameValidationError.tooShort => AppStrings.usernameTooShort,
      UsernameValidationError.tooLong => AppStrings.usernameTooLong,
      UsernameValidationError.invalidChars =>
        'Hanya huruf, angka, dan garis bawah.',
      null => null,
    };
  }

  String? _passwordError(PasswordInput input) {
    if (input.isPure) return null;
    return switch (input.displayError) {
      PasswordValidationError.empty => AppStrings.passwordEmpty,
      PasswordValidationError.tooShort => AppStrings.passwordTooShort,
      null => null,
    };
  }
}
