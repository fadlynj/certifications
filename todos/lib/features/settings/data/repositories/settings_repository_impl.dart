import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/logger_service.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._dataSource);

  final SettingsLocalDataSource _dataSource;

  @override
  Future<Either<Failure, String>> getAppVersion() async {
    try {
      final version = await _dataSource.getAppVersion();
      return Right(version);
    } catch (e, st) {
      AppLogger.e('getAppVersion failed', stackTrace: st);
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> clearAllData(int userId) async {
    try {
      await _dataSource.clearAllData(userId);
      return const Right(unit);
    } on AppException catch (e, st) {
      AppLogger.e('clearAllData failed', error: e.message, stackTrace: st);
      return Left(DatabaseFailure(e.message));
    } catch (e, st) {
      AppLogger.e('Unexpected clearAllData error', stackTrace: st);
      return const Left(UnexpectedFailure());
    }
  }
}
