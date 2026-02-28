import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/enums.dart';
import '../entities/task_analytics.dart';
import '../entities/task_entity.dart';

/// Abstract task repository — domain layer contract.
abstract class TaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getAllTasks();
  Future<Either<Failure, List<TaskEntity>>> getTasksByDate(DateTime date);
  Future<Either<Failure, List<TaskEntity>>> getTasksByTimeSlot(
    TimeOfDaySlot slot,
  );
  Future<Either<Failure, TaskEntity>> getTaskById(String id);
  Future<Either<Failure, Unit>> createTask(TaskEntity task);
  Future<Either<Failure, Unit>> updateTask(TaskEntity task);
  Future<Either<Failure, Unit>> deleteTask(String id);
  Future<Either<Failure, Unit>> completeTask(String id);
  Future<Either<Failure, Unit>> archiveTask(String id);
  Future<Either<Failure, TaskAnalytics>> getTaskAnalytics(String id);
}
