import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/habit_goal_entity.dart';
import '../repositories/habit_repository.dart';

/// Retrieves the currently active goal for a habit, if any.
@lazySingleton
class GetActiveGoalUsecase {
  final HabitRepository _repository;
  GetActiveGoalUsecase(this._repository);

  Future<Either<Failure, HabitGoalEntity?>> call(String habitId) {
    return _repository.getActiveGoal(habitId);
  }
}
