import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

/// Creates a new task.
@lazySingleton
class CreateTaskUsecase {
  final TaskRepository _repository;
  CreateTaskUsecase(this._repository);

  Future<Either<Failure, Unit>> call(TaskEntity task) {
    return _repository.createTask(task);
  }
}
