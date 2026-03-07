import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/habit_entity.dart';
import '../repositories/habit_repository.dart';

/// Updates an existing habit.
@lazySingleton
class UpdateHabitUsecase {
  final HabitRepository _repository;
  UpdateHabitUsecase(this._repository);

  Future<Either<Failure, Unit>> call(HabitEntity habit) {
    return _repository.updateHabit(habit);
  }
}
