import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/task_analytics.dart';
import '../repositories/task_repository.dart';

/// Returns analytics data for a task (streak, completions, weekly/monthly).
@lazySingleton
class GetTaskAnalyticsUsecase {
  final TaskRepository _repository;
  GetTaskAnalyticsUsecase(this._repository);

  Future<Either<Failure, TaskAnalytics>> call(String id) {
    return _repository.getTaskAnalytics(id);
  }
}
