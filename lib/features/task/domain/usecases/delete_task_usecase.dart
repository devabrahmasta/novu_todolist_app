import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/task_repository.dart';

/// Deletes a task by ID.
@lazySingleton
class DeleteTaskUsecase {
  final TaskRepository _repository;
  DeleteTaskUsecase(this._repository);

  Future<Either<Failure, Unit>> call(String id) {
    return _repository.deleteTask(id);
  }
}
