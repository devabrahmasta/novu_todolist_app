import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/habit_entity.dart';
import '../repositories/habit_repository.dart';

/// Retrieves a single habit by its ID.
@lazySingleton
class GetHabitByIdUsecase {
  final HabitRepository _repository;
  GetHabitByIdUsecase(this._repository);

  Future<Either<Failure, HabitEntity>> call(String id) {
    return _repository.getHabitById(id);
  }
}
