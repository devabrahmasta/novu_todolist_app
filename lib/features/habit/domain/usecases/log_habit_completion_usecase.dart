import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/habit_completion_entity.dart';
import '../repositories/habit_repository.dart';

/// Logs a single completion for a habit.
@lazySingleton
class LogHabitCompletionUsecase {
  final HabitRepository _repository;
  LogHabitCompletionUsecase(this._repository);

  Future<Either<Failure, Unit>> call(HabitCompletionEntity completion) {
    return _repository.logCompletion(completion);
  }
}
