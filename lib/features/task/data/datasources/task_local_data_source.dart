import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task_model.dart';
import '../../../../core/utils/enums.dart';

/// Local data source for tasks backed by sqflite.
@lazySingleton
class TaskLocalDataSource {
  final Database _db;

  TaskLocalDataSource(this._db);

  /// Get all tasks (with their subtasks).
  Future<List<TaskModel>> getAllTasks() async {
    final rows = await _db.query(
      'tasks',
      orderBy:
          'status ASC, timeOfDay ASC, dueTimeHour ASC, dueTimeMinute ASC, createdAt ASC',
    );
    final tasks = <TaskModel>[];
    for (final row in rows) {
      final task = TaskModel.fromMap(row);
      tasks.add(task);
    }
    return tasks;
  }

  /// Get subtasks for a given task ID.
  Future<List<SubtaskModel>> getSubtasksForTask(String taskId) async {
    final rows = await _db.query(
      'subtasks',
      where: 'taskId = ?',
      whereArgs: [taskId],
      orderBy: 'sortOrder ASC',
    );
    return rows.map(SubtaskModel.fromMap).toList();
  }

  /// Get tasks by a specific date (matches dueDate day).
  Future<List<TaskModel>> getTasksByDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    final rows = await _db.query(
      'tasks',
      where: 'dueDate >= ? AND dueDate < ? AND status != ?',
      whereArgs: [
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
        TaskStatus.archived.index,
      ],
      orderBy: 'status ASC, timeOfDay ASC, dueTimeHour ASC, dueTimeMinute ASC',
    );
    return rows.map(TaskModel.fromMap).toList();
  }

  /// Get tasks by time-of-day slot.
  Future<List<TaskModel>> getTasksByTimeSlot(TimeOfDaySlot slot) async {
    final rows = await _db.query(
      'tasks',
      where: 'timeOfDay = ?',
      whereArgs: [slot.index],
    );
    return rows.map(TaskModel.fromMap).toList();
  }

  /// Get a single task by its UUID.
  Future<TaskModel?> getTaskById(String id) async {
    final rows = await _db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return TaskModel.fromMap(rows.first);
  }

  /// Insert or update a task (and its subtasks).
  Future<void> putTask(TaskModel task, {List<SubtaskModel>? subtasks}) async {
    await _db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (subtasks != null) {
      // Delete old subtasks and re-insert
      await _db.delete('subtasks', where: 'taskId = ?', whereArgs: [task.id]);
      for (final sub in subtasks) {
        await _db.insert(
          'subtasks',
          sub.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }

  /// Delete a task by its UUID (cascade deletes subtasks via FK).
  Future<void> deleteTask(String id) async {
    // Manually delete subtasks first (in case FK isn't enforced)
    await _db.delete('subtasks', where: 'taskId = ?', whereArgs: [id]);
    await _db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  /// Count total tasks (for seed data check).
  Future<int> countTasks() async {
    final result = await _db.rawQuery('SELECT COUNT(*) as cnt FROM tasks');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get tasks completed on a specific date.
  Future<List<TaskModel>> getTasksCompletedOnDate(
    String taskId,
    DateTime date,
  ) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    final rows = await _db.query(
      'tasks',
      where: 'id = ? AND completedAt >= ? AND completedAt < ?',
      whereArgs: [
        taskId,
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
      ],
    );
    return rows.map(TaskModel.fromMap).toList();
  }
}
