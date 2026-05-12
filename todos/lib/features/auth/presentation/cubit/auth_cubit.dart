import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_current_session_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_state.dart';
import 'form_inputs.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required GetCurrentSessionUseCase getCurrentSession,
    required LoginUseCase login,
    required LogoutUseCase logout,
  }) : _getSession = getCurrentSession,
       _login = login,
       _logout = logout,
       super(const AuthInitial());

  final GetCurrentSessionUseCase _getSession;
  final LoginUseCase _login;
  final LogoutUseCase _logout;

  // ── Session bootstrap ─────────────────────────────────────────────────────

  /// Called once on app start to restore an existing session.
  Future<void> checkCurrentSession() async {
    emit(const AuthLoading());
    final result = await _getSession(const NoParams());
    result.fold((failure) => emit(const AuthUnauthenticated()), (session) {
      if (session == null || session.isExpired) {
        emit(const AuthUnauthenticated());
      } else {
        emit(AuthAuthenticated(session: session));
      }
    });
  }

  // ── Login form events ─────────────────────────────────────────────────────

  void openLoginForm() => emit(const AuthLoginForm());

  void usernameChanged(String value) {
    final current = _formState;
    emit(
      current.copyWith(username: UsernameInput.dirty(value), clearError: true),
    );
  }

  void passwordChanged(String value) {
    final current = _formState;
    emit(
      current.copyWith(password: PasswordInput.dirty(value), clearError: true),
    );
  }

  void togglePasswordVisibility() {
    final current = _formState;
    emit(current.copyWith(isPasswordVisible: !current.isPasswordVisible));
  }

  /// Submits the login form. Uses [droppable] transformer implicitly via the
  /// cubit's sequential emit — only one login at a time (button disabled while
  /// status == inProgress).
  Future<void> submitLogin() async {
    final current = _formState;
    if (!current.isValid) {
      emit(
        current.copyWith(
          username: UsernameInput.dirty(current.username.value),
          password: PasswordInput.dirty(current.password.value),
        ),
      );
      return;
    }

    emit(current.copyWith(status: FormzSubmissionStatus.inProgress));

    final result = await _login(
      LoginParams(
        username: current.username.value,
        password: current.password.value,
      ),
    );

    result.fold((failure) {
      final message = switch (failure) {
        AccountLockedFailure() => AppStrings.accountLocked,
        InvalidCredentialsFailure() => AppStrings.invalidCredentials,
        _ => AppStrings.unknownError,
      };
      emit(
        current.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: message,
        ),
      );
    }, (session) => emit(AuthAuthenticated(session: session)));
  }

  // ── Logout ────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    final session = switch (state) {
      AuthAuthenticated(:final session) => session,
      _ => null,
    };
    if (session != null) {
      await _logout(LogoutParams(token: session.token));
    }
    emit(const AuthUnauthenticated());
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  AuthLoginForm get _formState =>
      state is AuthLoginForm ? state as AuthLoginForm : const AuthLoginForm();
}
