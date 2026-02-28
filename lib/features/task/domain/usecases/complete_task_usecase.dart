import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/task_repository.dart';

/// Marks a task as completed with streak + totalCompletions logic.
@lazySingleton
class CompleteTaskUsecase {
  final TaskRepository _repository;
  CompleteTaskUsecase(this._repository);

  Future<Either<Failure, Unit>> call(String id) {
    return _repository.completeTask(id);
  }
}
