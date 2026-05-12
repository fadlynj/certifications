// Base UseCase contract used across all features.
// Type  = success return type
// Params = input parameters (use NoParams when none required)
import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

/// Synchronous use-case contract.
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Stream-based use-case for reactive data (e.g., live todo list).
abstract class StreamUseCase<T, Params> {
  Stream<Either<Failure, T>> call(Params params);
}

/// Sentinel parameter for use-cases that require no input.
class NoParams {
  const NoParams();
}
