import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/habit_entity.dart';
import '../repositories/habit_repository.dart';

/// Retrieves all habits.
@lazySingleton
class GetAllHabitsUsecase {
  final HabitRepository _repository;
  GetAllHabitsUsecase(this._repository);

  Future<Either<Failure, List<HabitEntity>>> call() {
    return _repository.getAllHabits();
  }
}
