import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Creates the very first user when the database is empty (seed / first run).
class RegisterInitialUserUseCase extends UseCase<UserEntity, RegisterParams> {
  RegisterInitialUserUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) =>
      _repository.registerInitialUser(
        username: params.username,
        password: params.password,
      );
}

class RegisterParams extends Equatable {
  const RegisterParams({required this.username, required this.password});

  final String username;
  final String password;

  @override
  List<Object?> get props => [username];
}
