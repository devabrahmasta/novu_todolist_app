import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

/// Returns all tasks.
@lazySingleton
class GetAllTasksUsecase {
  final TaskRepository _repository;
  GetAllTasksUsecase(this._repository);

  Future<Either<Failure, List<TaskEntity>>> call() {
    return _repository.getAllTasks();
  }
}
