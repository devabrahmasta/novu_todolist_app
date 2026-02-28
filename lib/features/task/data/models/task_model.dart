import 'package:flutter/material.dart';

import '../../../../core/utils/enums.dart';
import '../../domain/entities/task_entity.dart';

/// SQLite-backed task model.
///
/// Stores enums as int indexes, DateTime as millisSinceEpoch,
/// booleans as 0/1, and repeatCustomDays as comma-separated string.
class TaskModel {
  String id;
  String title;
  String? description;
  String? categoryId;
  TimeOfDaySlot timeOfDay;
  DateTime? dueDate;
  int? dueTimeHour;
  int? dueTimeMinute;
  int? priorityIndex;
  TaskStatus status;
  bool reminderEnabled;
  int reminderOffsetMinutes;
  DateTime? reminderCustomTime;
  RepeatType repeatType;
  List<int>? repeatCustomDays;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? completedAt;
  int streak;
  int totalCompletions;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.categoryId,
    this.timeOfDay = TimeOfDaySlot.morning,
    this.dueDate,
    this.dueTimeHour,
    this.dueTimeMinute,
    this.priorityIndex,
    this.status = TaskStatus.pending,
    this.reminderEnabled = false,
    this.reminderOffsetMinutes = 15,
    this.reminderCustomTime,
    this.repeatType = RepeatType.none,
    this.repeatCustomDays,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.streak = 0,
    this.totalCompletions = 0,
  });

  // ─── SQLite serialisation ──────────────────────────────

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      categoryId: map['categoryId'] as String?,
      timeOfDay: TimeOfDaySlot.values[map['timeOfDay'] as int],
      dueDate: map['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int)
          : null,
      dueTimeHour: map['dueTimeHour'] as int?,
      dueTimeMinute: map['dueTimeMinute'] as int?,
      priorityIndex: map['priorityIndex'] as int?,
      status: TaskStatus.values[map['status'] as int],
      reminderEnabled: (map['reminderEnabled'] as int) == 1,
      reminderOffsetMinutes: map['reminderOffsetMinutes'] as int,
      reminderCustomTime: map['reminderCustomTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['reminderCustomTime'] as int,
            )
          : null,
      repeatType: RepeatType.values[map['repeatType'] as int],
      repeatCustomDays: map['repeatCustomDays'] != null
          ? (map['repeatCustomDays'] as String)
                .split(',')
                .map(int.parse)
                .toList()
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      completedAt: map['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['completedAt'] as int)
          : null,
      streak: map['streak'] as int,
      totalCompletions: map['totalCompletions'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'timeOfDay': timeOfDay.index,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'dueTimeHour': dueTimeHour,
      'dueTimeMinute': dueTimeMinute,
      'priorityIndex': priorityIndex,
      'status': status.index,
      'reminderEnabled': reminderEnabled ? 1 : 0,
      'reminderOffsetMinutes': reminderOffsetMinutes,
      'reminderCustomTime': reminderCustomTime?.millisecondsSinceEpoch,
      'repeatType': repeatType.index,
      'repeatCustomDays': repeatCustomDays?.join(','),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'streak': streak,
      'totalCompletions': totalCompletions,
    };
  }
}

/// SQLite-backed subtask model.
class SubtaskModel {
  String id;
  String taskId;
  String title;
  bool isCompleted;
  int order;

  SubtaskModel({
    required this.id,
    required this.taskId,
    required this.title,
    this.isCompleted = false,
    this.order = 0,
  });

  factory SubtaskModel.fromMap(Map<String, dynamic> map) {
    return SubtaskModel(
      id: map['id'] as String,
      taskId: map['taskId'] as String,
      title: map['title'] as String,
      isCompleted: (map['isCompleted'] as int) == 1,
      order: map['sortOrder'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'title': title,
      'isCompleted': isCompleted ? 1 : 0,
      'sortOrder': order,
    };
  }
}

// ─── Mapper Extensions ──────────────────────────────────

extension TaskModelMapper on TaskModel {
  TaskEntity toEntity({List<SubtaskModel> subtaskModels = const []}) {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      categoryId: categoryId,
      timeOfDay: timeOfDay,
      dueDate: dueDate,
      dueTime: dueTimeHour != null && dueTimeMinute != null
          ? TimeOfDay(hour: dueTimeHour!, minute: dueTimeMinute!)
          : null,
      priority: priorityIndex != null
          ? TaskPriority.values[priorityIndex!]
          : null,
      status: status,
      subtasks: subtaskModels.map((s) => s.toEntity()).toList(),
      reminder: ReminderConfig(
        isEnabled: reminderEnabled,
        offsetMinutes: reminderOffsetMinutes,
        customTime: reminderCustomTime,
      ),
      repeat: RepeatConfig(type: repeatType, customDays: repeatCustomDays),
      createdAt: createdAt,
      updatedAt: updatedAt,
      completedAt: completedAt,
      streak: streak,
      totalCompletions: totalCompletions,
    );
  }
}

extension TaskEntityMapper on TaskEntity {
  TaskModel toModel() {
    return TaskModel(
      id: id,
      title: title,
      description: description,
      categoryId: categoryId,
      timeOfDay: timeOfDay,
      dueDate: dueDate,
      dueTimeHour: dueTime?.hour,
      dueTimeMinute: dueTime?.minute,
      priorityIndex: priority?.index,
      status: status,
      reminderEnabled: reminder?.isEnabled ?? false,
      reminderOffsetMinutes: reminder?.offsetMinutes ?? 15,
      reminderCustomTime: reminder?.customTime,
      repeatType: repeat?.type ?? RepeatType.none,
      repeatCustomDays: repeat?.customDays,
      createdAt: createdAt,
      updatedAt: updatedAt,
      completedAt: completedAt,
      streak: streak,
      totalCompletions: totalCompletions,
    );
  }

  List<SubtaskModel> subtasksToModels() {
    return subtasks.map((s) => s.toModel()).toList();
  }
}

extension SubtaskModelMapper on SubtaskModel {
  SubtaskEntity toEntity() {
    return SubtaskEntity(
      id: id,
      taskId: taskId,
      title: title,
      isCompleted: isCompleted,
      order: order,
    );
  }
}

extension SubtaskEntityMapper on SubtaskEntity {
  SubtaskModel toModel() {
    return SubtaskModel(
      id: id,
      taskId: taskId,
      title: title,
      isCompleted: isCompleted,
      order: order,
    );
  }
}
