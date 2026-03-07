import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/habit_entity.dart';
import '../entities/habit_step_entity.dart';
import '../entities/habit_completion_entity.dart';
import '../entities/habit_goal_entity.dart';

/// Abstract habit repository — domain layer contract.
abstract class HabitRepository {
  Future<Either<Failure, List<HabitEntity>>> getAllHabits();
  Future<Either<Failure, HabitEntity>> getHabitById(String id);
  Future<Either<Failure, Unit>> createHabit(
    HabitEntity habit,
    List<HabitStepEntity> steps,
  );
  Future<Either<Failure, Unit>> updateHabit(HabitEntity habit);
  Future<Either<Failure, Unit>> deleteHabit(String id);
  Future<Either<Failure, Unit>> logCompletion(HabitCompletionEntity completion);
  Future<Either<Failure, List<HabitCompletionEntity>>> getCompletions(
    String habitId,
  );
  Future<Either<Failure, HabitGoalEntity?>> getActiveGoal(String habitId);
  Future<Either<Failure, Unit>> createGoal(HabitGoalEntity goal);
  Future<Either<Failure, Unit>> updateGoal(HabitGoalEntity goal);
}
