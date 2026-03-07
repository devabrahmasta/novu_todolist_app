import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/habit_step_entity.dart';
import '../../domain/entities/habit_completion_entity.dart';
import '../../domain/entities/habit_goal_entity.dart';
import '../../domain/repositories/habit_repository.dart';
import '../datasources/habit_local_data_source.dart';
import '../models/habit_model.dart';
import '../models/habit_step_model.dart';
import '../models/habit_completion_model.dart';
import '../models/habit_goal_model.dart';

/// Concrete implementation of [HabitRepository] backed by sqflite.
@LazySingleton(as: HabitRepository)
class HabitRepositoryImpl implements HabitRepository {
  final HabitLocalDataSource _localDataSource;

  HabitRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<HabitEntity>>> getAllHabits() async {
    try {
      final models = await _localDataSource.getAllHabits();
      final entities = models.map((m) => m.toEntity()).toList();
      return right(entities);
    } catch (e) {
      return left(CacheFailure('Failed to get habits: $e'));
    }
  }

  @override
  Future<Either<Failure, HabitEntity>> getHabitById(String id) async {
    try {
      final model = await _localDataSource.getHabitById(id);
      if (model == null) {
        return left(const CacheFailure('Habit not found'));
      }
      return right(model.toEntity());
    } catch (e) {
      return left(CacheFailure('Failed to get habit: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> createHabit(
    HabitEntity habit,
    List<HabitStepEntity> steps,
  ) async {
    try {
      await _localDataSource.putHabit(habit.toModel());
      if (steps.isNotEmpty) {
        final stepModels = steps.map((s) => s.toModel()).toList();
        await _localDataSource.putSteps(habit.id, stepModels);
      }
      return right(unit);
    } catch (e) {
      return left(CacheFailure('Failed to create habit: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateHabit(HabitEntity habit) async {
    try {
      await _localDataSource.putHabit(habit.toModel());
      return right(unit);
    } catch (e) {
      return left(CacheFailure('Failed to update habit: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteHabit(String id) async {
    try {
      await _localDataSource.deleteHabit(id);
      return right(unit);
    } catch (e) {
      return left(CacheFailure('Failed to delete habit: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> logCompletion(
    HabitCompletionEntity completion,
  ) async {
    try {
      await _localDataSource.putCompletion(completion.toModel());
      return right(unit);
    } catch (e) {
      return left(CacheFailure('Failed to log completion: $e'));
    }
  }

  @override
  Future<Either<Failure, List<HabitCompletionEntity>>> getCompletions(
    String habitId,
  ) async {
    try {
      final models = await _localDataSource.getCompletions(habitId);
      final entities = models.map((m) => m.toEntity()).toList();
      return right(entities);
    } catch (e) {
      return left(CacheFailure('Failed to get completions: $e'));
    }
  }

  @override
  Future<Either<Failure, HabitGoalEntity?>> getActiveGoal(
    String habitId,
  ) async {
    try {
      final model = await _localDataSource.getActiveGoal(habitId);
      return right(model?.toEntity());
    } catch (e) {
      return left(CacheFailure('Failed to get active goal: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> createGoal(HabitGoalEntity goal) async {
    try {
      await _localDataSource.putGoal(goal.toModel());
      return right(unit);
    } catch (e) {
      return left(CacheFailure('Failed to create goal: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateGoal(HabitGoalEntity goal) async {
    try {
      await _localDataSource.updateGoal(goal.toModel());
      return right(unit);
    } catch (e) {
      return left(CacheFailure('Failed to update goal: $e'));
    }
  }
}
