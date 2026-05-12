import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/settings_repository.dart';

class GetAppInfoUseCase extends UseCase<String, NoParams> {
  GetAppInfoUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, String>> call(NoParams params) =>
      _repository.getAppVersion();
}
