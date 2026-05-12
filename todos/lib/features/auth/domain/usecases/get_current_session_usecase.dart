import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/session_entity.dart';
import '../repositories/auth_repository.dart';

class GetCurrentSessionUseCase extends UseCase<SessionEntity?, NoParams> {
  GetCurrentSessionUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, SessionEntity?>> call(NoParams params) =>
      _repository.getCurrentSession();
}
