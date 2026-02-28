import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/enums.dart';
import '../../domain/entities/task_analytics.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';
import '../models/task_model.dart';

/// Concrete implementation of [TaskRepository] backed by sqflite.
@LazySingleton(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource _localDataSource;

  TaskRepositoryImpl(this._localDataSource);

  /// Helper to convert a [TaskModel] + its subtasks into a [TaskEntity].
  Future<TaskEntity> _toEntityWithSubtasks(TaskModel model) async {
    final subtasks = await _localDataSource.getSubtasksForTask(model.id);
    return model.toEntity(subtaskModels: subtasks);
  }

  /// Helper to persist a [TaskEntity] together with its subtasks.
  Future<void> _putEntityWithSubtasks(TaskEntity entity) async {
    await _localDataSource.putTask(
      entity.toModel(),
      subtasks: entity.subtasksToModels(),
    );
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getAllTasks() async {
    try {
      final models = await _localDataSource.getAllTasks();
      final entities = <TaskEntity>[];
      for (final m in models) {
        entities.add(await _toEntityWithSubtasks(m));
      }
      return right(entities);
    } catch (e) {
      return left(CacheFailure('Failed to get tasks: $e'));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasksByDate(
    DateTime date,
  ) async {
    try {
      final models = await _localDataSource.getTasksByDate(date);
      final entities = <TaskEntity>[];
      for (final m in models) {
        entities.add(await _toEntityWithSubtasks(m));
      }
      return right(entities);
    } catch (e) {
      return left(CacheFailure('Failed to get tasks by date: $e'));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasksByTimeSlot(
    TimeOfDaySlot slot,
  ) async {
    try {
      final models = await _localDataSource.getTasksByTimeSlot(slot);
      final entities = <TaskEntity>[];
      for (final m in models) {
        entities.add(await _toEntityWithSubtasks(m));
      }
      return right(entities);
    } catch (e) {
      return left(CacheFailure('Failed to get tasks by time slot: $e'));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> getTaskById(String id) async {
    try {
      final model = await _localDataSource.getTaskById(id);
      if (model == null) {
        return left(const CacheFailure('Task not found'));
      }
      return right(await _toEntityWithSubtasks(model));
    } catch (e) {
      return left(CacheFailure('Failed to get task: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> createTask(TaskEntity task) async {
    try {
      await _putEntityWithSubtasks(task);
      return right(unit);
    } catch (e) {
      return left(CacheFailure('Failed to create task: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTask(TaskEntity task) async {
    try {
      await _putEntityWithSubtasks(task);
      return right(unit);
    } catch (e) {
      return left(CacheFailure('Failed to update task: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTask(String id) async {
    try {
      await _localDataSource.deleteTask(id);
      return right(unit);
    } catch (e) {
      return left(CacheFailure('Failed to delete task: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> completeTask(String id) async {
    try {
      final model = await _localDataSource.getTaskById(id);
      if (model == null) {
        return left(const CacheFailure('Task not found'));
      }

      final now = DateTime.now();
      final entity = await _toEntityWithSubtasks(model);

      // Calculate streak: check if completed yesterday for continuity
      int newStreak = entity.streak;
      if (entity.completedAt != null) {
        final yesterday = DateTime(now.year, now.month, now.day - 1);
        final lastCompleted = DateTime(
          entity.completedAt!.year,
          entity.completedAt!.month,
          entity.completedAt!.day,
        );
        if (lastCompleted == yesterday) {
          newStreak += 1;
        } else if (lastCompleted != DateTime(now.year, now.month, now.day)) {
          newStreak = 1; // streak broken, start fresh
        }
      } else {
        newStreak = 1; // first completion
      }

      final updated = entity.copyWith(
        status: TaskStatus.completed,
        completedAt: now,
        updatedAt: now,
        totalCompletions: entity.totalCompletions + 1,
        streak: newStreak,
      );
      await _putEntityWithSubtasks(updated);
      return right(unit);
    } catch (e) {
      return left(CacheFailure('Failed to complete task: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> archiveTask(String id) async {
    try {
      final model = await _localDataSource.getTaskById(id);
      if (model == null) {
        return left(const CacheFailure('Task not found'));
      }
      final entity = await _toEntityWithSubtasks(model);
      final updated = entity.copyWith(
        status: TaskStatus.archived,
        updatedAt: DateTime.now(),
      );
      await _putEntityWithSubtasks(updated);
      return right(unit);
    } catch (e) {
      return left(CacheFailure('Failed to archive task: $e'));
    }
  }

  @override
  Future<Either<Failure, TaskAnalytics>> getTaskAnalytics(String id) async {
    try {
      final model = await _localDataSource.getTaskById(id);
      if (model == null) {
        return left(const CacheFailure('Task not found'));
      }
      final entity = await _toEntityWithSubtasks(model);
      final now = DateTime.now();

      // Build weekly data (last 7 days)
      final weeklyData = <bool>[];
      for (int i = 6; i >= 0; i--) {
        final date = DateTime(now.year, now.month, now.day - i);
        final completed = await _localDataSource.getTasksCompletedOnDate(
          id,
          date,
        );
        weeklyData.add(completed.isNotEmpty);
      }

      // Build monthly data (last 30 days)
      final monthlyData = <bool>[];
      for (int i = 29; i >= 0; i--) {
        final date = DateTime(now.year, now.month, now.day - i);
        final completed = await _localDataSource.getTasksCompletedOnDate(
          id,
          date,
        );
        monthlyData.add(completed.isNotEmpty);
      }

      // Calculate best streak from monthly data
      int bestStreak = 0;
      int currentRun = 0;
      for (final day in monthlyData) {
        if (day) {
          currentRun++;
          if (currentRun > bestStreak) bestStreak = currentRun;
        } else {
          currentRun = 0;
        }
      }

      return right(
        TaskAnalytics(
          streak: entity.streak,
          totalCompletions: entity.totalCompletions,
          createdAt: entity.createdAt,
          weeklyData: weeklyData,
          monthlyData: monthlyData,
          bestStreak: bestStreak,
        ),
      );
    } catch (e) {
      return left(CacheFailure('Failed to get task analytics: $e'));
    }
  }
}
