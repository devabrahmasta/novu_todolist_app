import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

/// Updates an existing task.
@lazySingleton
class UpdateTaskUsecase {
  final TaskRepository _repository;
  UpdateTaskUsecase(this._repository);

  Future<Either<Failure, Unit>> call(TaskEntity task) {
    return _repository.updateTask(task);
  }
}
