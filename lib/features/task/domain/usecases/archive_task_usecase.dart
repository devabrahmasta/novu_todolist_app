import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/task_repository.dart';

/// Archives a task.
@lazySingleton
class ArchiveTaskUsecase {
  final TaskRepository _repository;
  ArchiveTaskUsecase(this._repository);

  Future<Either<Failure, Unit>> call(String id) {
    return _repository.archiveTask(id);
  }
}
