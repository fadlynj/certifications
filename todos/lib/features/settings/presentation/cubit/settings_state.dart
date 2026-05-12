import 'package:equatable/equatable.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();
  @override
  List<Object?> get props => [];
}

final class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

final class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

final class SettingsLoaded extends SettingsState {
  const SettingsLoaded({required this.appVersion});
  final String appVersion;
  @override
  List<Object?> get props => [appVersion];
}

final class SettingsResetPasswordForm extends SettingsState {
  const SettingsResetPasswordForm({
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.isSubmitting = false,
    this.errorMessage,
  });

  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final bool isSubmitting;
  final String? errorMessage;

  bool get isValid =>
      currentPassword.isNotEmpty &&
      newPassword.length >= 6 &&
      newPassword == confirmPassword;

  SettingsResetPasswordForm copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) => SettingsResetPasswordForm(
    currentPassword: currentPassword ?? this.currentPassword,
    newPassword: newPassword ?? this.newPassword,
    confirmPassword: confirmPassword ?? this.confirmPassword,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [
    currentPassword,
    newPassword,
    confirmPassword,
    isSubmitting,
    errorMessage,
  ];
}

final class SettingsSuccess extends SettingsState {
  const SettingsSuccess({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}

final class SettingsError extends SettingsState {
  const SettingsError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
