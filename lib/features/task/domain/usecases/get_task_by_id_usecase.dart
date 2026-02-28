import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

/// Returns a single task by its ID.
@lazySingleton
class GetTaskByIdUsecase {
  final TaskRepository _repository;
  GetTaskByIdUsecase(this._repository);

  Future<Either<Failure, TaskEntity>> call(String id) {
    return _repository.getTaskById(id);
  }
}
