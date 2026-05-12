import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../domain/entities/session_entity.dart';
import 'form_inputs.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

/// Initial state before session check completes.
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Async operation in progress (session check, login, logout).
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Valid session exists — user is signed in.
final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.session});
  final SessionEntity session;
  @override
  List<Object?> get props => [session];
}

/// No valid session — user must log in.
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Login form is being edited (holds live form state).
final class AuthLoginForm extends AuthState {
  const AuthLoginForm({
    this.username = const UsernameInput.pure(),
    this.password = const PasswordInput.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.isPasswordVisible = false,
  });

  final UsernameInput username;
  final PasswordInput password;
  final FormzSubmissionStatus status;
  final String? errorMessage;
  final bool isPasswordVisible;

  bool get isValid => Formz.validate([username, password]);

  AuthLoginForm copyWith({
    UsernameInput? username,
    PasswordInput? password,
    FormzSubmissionStatus? status,
    String? errorMessage,
    bool clearError = false,
    bool? isPasswordVisible,
  }) => AuthLoginForm(
    username: username ?? this.username,
    password: password ?? this.password,
    status: status ?? this.status,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
  );

  @override
  List<Object?> get props => [
    username,
    password,
    status,
    errorMessage,
    isPasswordVisible,
  ];
}

/// Error state — carries a user-facing message.
final class AuthError extends AuthState {
  const AuthError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
