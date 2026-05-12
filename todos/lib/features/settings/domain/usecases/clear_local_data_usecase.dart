import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/settings_repository.dart';

class ClearLocalDataUseCase extends UseCase<Unit, ClearDataParams> {
  ClearLocalDataUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(ClearDataParams params) =>
      _repository.clearAllData(params.userId);
}

class ClearDataParams extends Equatable {
  const ClearDataParams({required this.userId});
  final int userId;
  @override
  List<Object?> get props => [userId];
}
