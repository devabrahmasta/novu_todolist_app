import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../models/habit_model.dart';
import '../models/habit_step_model.dart';
import '../models/habit_completion_model.dart';
import '../models/habit_goal_model.dart';

/// Local data source for habits backed by sqflite.
@lazySingleton
class HabitLocalDataSource {
  final Database _db;

  HabitLocalDataSource(this._db);

  // ─── Habits ────────────────────────────────────────────

  /// Get all habits ordered by creation date.
  Future<List<HabitModel>> getAllHabits() async {
    final rows = await _db.query('habits', orderBy: 'created_at DESC');
    return rows.map(HabitModel.fromMap).toList();
  }

  /// Get a single habit by UUID.
  Future<HabitModel?> getHabitById(String id) async {
    final rows = await _db.query(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return HabitModel.fromMap(rows.first);
  }

  /// Insert or update a habit.
  Future<void> putHabit(HabitModel habit) async {
    await _db.insert(
      'habits',
      habit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Delete a habit and all related data.
  Future<void> deleteHabit(String id) async {
    await _db.delete('habit_completions', where: 'habit_id = ?', whereArgs: [id]);
    await _db.delete('habit_goals', where: 'habit_id = ?', whereArgs: [id]);
    await _db.delete('habit_steps', where: 'habit_id = ?', whereArgs: [id]);
    await _db.delete('habits', where: 'id = ?', whereArgs: [id]);
  }

  // ─── Steps ─────────────────────────────────────────────

  /// Get all steps for a habit, ordered.
  Future<List<HabitStepModel>> getStepsForHabit(String habitId) async {
    final rows = await _db.query(
      'habit_steps',
      where: 'habit_id = ?',
      whereArgs: [habitId],
      orderBy: 'order_index ASC',
    );
    return rows.map(HabitStepModel.fromMap).toList();
  }

  /// Replace all steps for a habit (delete old, insert new).
  Future<void> putSteps(String habitId, List<HabitStepModel> steps) async {
    await _db.delete('habit_steps', where: 'habit_id = ?', whereArgs: [habitId]);
    for (final step in steps) {
      await _db.insert(
        'habit_steps',
        step.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // ─── Completions ───────────────────────────────────────

  /// Log a completion (insert or replace for same habit+date).
  Future<void> putCompletion(HabitCompletionModel completion) async {
    await _db.insert(
      'habit_completions',
      completion.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all completions for a habit.
  Future<List<HabitCompletionModel>> getCompletions(String habitId) async {
    final rows = await _db.query(
      'habit_completions',
      where: 'habit_id = ?',
      whereArgs: [habitId],
      orderBy: 'date DESC',
    );
    return rows.map(HabitCompletionModel.fromMap).toList();
  }

  // ─── Goals ─────────────────────────────────────────────

  /// Get the currently active goal for a habit.
  Future<HabitGoalModel?> getActiveGoal(String habitId) async {
    final rows = await _db.query(
      'habit_goals',
      where: 'habit_id = ? AND status = ?',
      whereArgs: [habitId, 0], // 0 = HabitGoalStatus.active
      limit: 1,
      orderBy: 'created_at DESC',
    );
    if (rows.isEmpty) return null;
    return HabitGoalModel.fromMap(rows.first);
  }

  /// Insert a new goal.
  Future<void> putGoal(HabitGoalModel goal) async {
    await _db.insert(
      'habit_goals',
      goal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Update an existing goal.
  Future<void> updateGoal(HabitGoalModel goal) async {
    await _db.update(
      'habit_goals',
      goal.toMap(),
      where: 'id = ?',
      whereArgs: [goal.id],
    );
  }
}
