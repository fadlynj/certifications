import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase extends UseCase<Unit, LogoutParams> {
  LogoutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(LogoutParams params) =>
      _repository.logout(token: params.token);
}

class LogoutParams extends Equatable {
  const LogoutParams({required this.token});

  final String token;

  @override
  List<Object?> get props => []; // token is sensitive — omit from props
}
