import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

/// Returns tasks for a specific date.
@lazySingleton
class GetTasksByDateUsecase {
  final TaskRepository _repository;
  GetTasksByDateUsecase(this._repository);

  Future<Either<Failure, List<TaskEntity>>> call(DateTime date) {
    return _repository.getTasksByDate(date);
  }
}
