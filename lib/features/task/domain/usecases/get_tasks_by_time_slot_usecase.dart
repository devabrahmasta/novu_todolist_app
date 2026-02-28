import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/enums.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

/// Returns tasks filtered by time-of-day slot.
@lazySingleton
class GetTasksByTimeSlotUsecase {
  final TaskRepository _repository;
  GetTasksByTimeSlotUsecase(this._repository);

  Future<Either<Failure, List<TaskEntity>>> call(TimeOfDaySlot slot) {
    return _repository.getTasksByTimeSlot(slot);
  }
}
