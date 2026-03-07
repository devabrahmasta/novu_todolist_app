import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/habit_completion_entity.dart';
import '../repositories/habit_repository.dart';

/// Retrieves all completions for a given habit.
@lazySingleton
class GetHabitCompletionsUsecase {
  final HabitRepository _repository;
  GetHabitCompletionsUsecase(this._repository);

  Future<Either<Failure, List<HabitCompletionEntity>>> call(String habitId) {
    return _repository.getCompletions(habitId);
  }
}
