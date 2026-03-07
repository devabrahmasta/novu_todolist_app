import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/habit_goal_entity.dart';
import '../repositories/habit_repository.dart';

/// Updates an existing habit goal (e.g. progress, status).
@lazySingleton
class UpdateHabitGoalUsecase {
  final HabitRepository _repository;
  UpdateHabitGoalUsecase(this._repository);

  Future<Either<Failure, Unit>> call(HabitGoalEntity goal) {
    return _repository.updateGoal(goal);
  }
}
