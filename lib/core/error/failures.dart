/// Failure types for the domain layer.
/// Used with fpdart Either<Failure, T> — no raw try-catch in domain.

abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Failure originating from local cache / Isar operations.
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache operation failed'])
    : super(message);
}

/// Catch-all for unexpected errors.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([String message = 'An unexpected error occurred'])
    : super(message);
}
