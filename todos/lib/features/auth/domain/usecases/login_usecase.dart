import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/session_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase extends UseCase<SessionEntity, LoginParams> {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, SessionEntity>> call(LoginParams params) =>
      _repository.login(username: params.username, password: params.password);
}

class LoginParams extends Equatable {
  const LoginParams({required this.username, required this.password});

  final String username;
  final String password;

  @override
  List<Object?> get props => [username];
  // Password intentionally omitted from props to avoid accidental exposure
}
