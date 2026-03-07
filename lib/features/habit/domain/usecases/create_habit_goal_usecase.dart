import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/habit_goal_entity.dart';
import '../repositories/habit_repository.dart';

/// Creates a new goal / challenge for a habit.
@lazySingleton
class CreateHabitGoalUsecase {
  final HabitRepository _repository;
  CreateHabitGoalUsecase(this._repository);

  Future<Either<Failure, Unit>> call(HabitGoalEntity goal) {
    return _repository.createGoal(goal);
  }
}
