import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/habit_repository.dart';

/// Deletes a habit by its ID.
@lazySingleton
class DeleteHabitUsecase {
  final HabitRepository _repository;
  DeleteHabitUsecase(this._repository);

  Future<Either<Failure, Unit>> call(String id) {
    return _repository.deleteHabit(id);
  }
}
