import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/habit_entity.dart';
import '../entities/habit_step_entity.dart';
import '../repositories/habit_repository.dart';

/// Creates a new habit with optional steps.
@lazySingleton
class CreateHabitUsecase {
  final HabitRepository _repository;
  CreateHabitUsecase(this._repository);

  Future<Either<Failure, Unit>> call(
    HabitEntity habit,
    List<HabitStepEntity> steps,
  ) {
    return _repository.createHabit(habit, steps);
  }
}
