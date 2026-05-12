import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class SettingsRepository {
  /// Returns the app version string (e.g. "1.0.0+1").
  Future<Either<Failure, String>> getAppVersion();

  /// Deletes all todos for [userId] and clears the session.
  Future<Either<Failure, Unit>> clearAllData(int userId);
}
