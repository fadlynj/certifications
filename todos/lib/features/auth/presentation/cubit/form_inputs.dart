// Formz typed inputs for login / password forms.
import 'package:formz/formz.dart';

import '../../../../core/constants/app_constants.dart';

// ── Username ──────────────────────────────────────────────────────────────

enum UsernameValidationError { empty, tooShort, tooLong, invalidChars }

class UsernameInput extends FormzInput<String, UsernameValidationError> {
  const UsernameInput.pure() : super.pure('');
  const UsernameInput.dirty([super.value = '']) : super.dirty();

  @override
  UsernameValidationError? validator(String value) {
    if (value.isEmpty) return UsernameValidationError.empty;
    if (value.length < AppConstants.usernameMinLength) {
      return UsernameValidationError.tooShort;
    }
    if (value.length > AppConstants.usernameMaxLength) {
      return UsernameValidationError.tooLong;
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return UsernameValidationError.invalidChars;
    }
    return null;
  }
}

// ── Password ──────────────────────────────────────────────────────────────

enum PasswordValidationError { empty, tooShort }

class PasswordInput extends FormzInput<String, PasswordValidationError> {
  const PasswordInput.pure() : super.pure('');
  const PasswordInput.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) return PasswordValidationError.empty;
    if (value.length < AppConstants.passwordMinLength) {
      return PasswordValidationError.tooShort;
    }
    return null;
  }
}

// ── Todo title ────────────────────────────────────────────────────────────

enum TitleValidationError { empty, tooLong }

class TitleInput extends FormzInput<String, TitleValidationError> {
  const TitleInput.pure() : super.pure('');
  const TitleInput.dirty([super.value = '']) : super.dirty();

  @override
  TitleValidationError? validator(String value) {
    if (value.trim().isEmpty) return TitleValidationError.empty;
    if (value.length > AppConstants.todoTitleMaxLength) {
      return TitleValidationError.tooLong;
    }
    return null;
  }
}

// ── Todo description (optional) ───────────────────────────────────────────

enum DescriptionValidationError { tooLong }

class DescriptionInput extends FormzInput<String, DescriptionValidationError> {
  const DescriptionInput.pure() : super.pure('');
  const DescriptionInput.dirty([super.value = '']) : super.dirty();

  @override
  DescriptionValidationError? validator(String value) {
    if (value.length > AppConstants.todoDescriptionMaxLength) {
      return DescriptionValidationError.tooLong;
    }
    return null;
  }
}
