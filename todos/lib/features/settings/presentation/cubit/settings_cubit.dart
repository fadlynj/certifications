import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/domain/usecases/reset_password_usecase.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../domain/usecases/clear_local_data_usecase.dart';
import '../../domain/usecases/get_app_info_usecase.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required GetAppInfoUseCase getAppInfo,
    required ClearLocalDataUseCase clearLocalData,
    required ResetPasswordUseCase resetPassword,
    required AuthCubit authCubit,
  }) : _getAppInfo = getAppInfo,
       _clearLocalData = clearLocalData,
       _resetPassword = resetPassword,
       _authCubit = authCubit,
       super(const SettingsInitial());

  final GetAppInfoUseCase _getAppInfo;
  final ClearLocalDataUseCase _clearLocalData;
  final ResetPasswordUseCase _resetPassword;
  final AuthCubit _authCubit;

  Future<void> loadSettings() async {
    emit(const SettingsLoading());
    final result = await _getAppInfo(const NoParams());
    result.fold(
      (failure) => emit(SettingsError(message: failure.message)),
      (version) => emit(SettingsLoaded(appVersion: version)),
    );
  }

  void openResetPasswordForm() => emit(const SettingsResetPasswordForm());

  void currentPasswordChanged(String value) {
    final form = _form;
    emit(form.copyWith(currentPassword: value, clearError: true));
  }

  void newPasswordChanged(String value) {
    final form = _form;
    emit(form.copyWith(newPassword: value, clearError: true));
  }

  void confirmPasswordChanged(String value) {
    final form = _form;
    emit(form.copyWith(confirmPassword: value, clearError: true));
  }

  Future<void> submitResetPassword(String username) async {
    final form = _form;
    if (!form.isValid) {
      final errorMsg = form.newPassword != form.confirmPassword
          ? AppStrings.passwordMismatch
          : AppStrings.passwordTooShort;
      emit(form.copyWith(errorMessage: errorMsg));
      return;
    }

    emit(form.copyWith(isSubmitting: true));

    final result = await _resetPassword(
      ResetPasswordParams(
        username: username,
        currentPassword: form.currentPassword,
        newPassword: form.newPassword,
      ),
    );

    result.fold(
      (failure) => emit(
        form.copyWith(isSubmitting: false, errorMessage: failure.message),
      ),
      (_) =>
          emit(const SettingsSuccess(message: AppStrings.passwordResetSuccess)),
    );
  }

  Future<void> logout() async {
    await _authCubit.logout();
  }

  Future<void> clearAllData(int userId) async {
    emit(const SettingsLoading());
    final result = await _clearLocalData(ClearDataParams(userId: userId));
    result.fold(
      (failure) => emit(SettingsError(message: failure.message)),
      (_) => _authCubit.logout(),
    );
  }

  void backToLoaded() => loadSettings();

  SettingsResetPasswordForm get _form => state is SettingsResetPasswordForm
      ? state as SettingsResetPasswordForm
      : const SettingsResetPasswordForm();
}
