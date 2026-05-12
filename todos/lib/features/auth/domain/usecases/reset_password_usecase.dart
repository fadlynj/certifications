import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase extends UseCase<Unit, ResetPasswordParams> {
  ResetPasswordUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(ResetPasswordParams params) =>
      _repository.resetPassword(
        username: params.username,
        currentPassword: params.currentPassword,
        newPassword: params.newPassword,
      );
}

class ResetPasswordParams extends Equatable {
  const ResetPasswordParams({
    required this.username,
    required this.currentPassword,
    required this.newPassword,
  });

  final String username;
  final String currentPassword;
  final String newPassword;

  @override
  List<Object?> get props => [username];
}
