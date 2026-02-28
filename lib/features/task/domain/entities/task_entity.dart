import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/enums.dart';

part 'task_entity.freezed.dart';

/// Core task entity — pure domain, no persistence details.
@freezed
class TaskEntity with _$TaskEntity {
  const factory TaskEntity({
    required String id,
    required String title,
    String? description,
    String? categoryId,
    required TimeOfDaySlot timeOfDay,
    DateTime? dueDate,
    TimeOfDay? dueTime,
    TaskPriority? priority, // always optional
    required TaskStatus status,
    @Default([]) List<SubtaskEntity> subtasks,
    ReminderConfig? reminder,
    RepeatConfig? repeat,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? completedAt,
    @Default(0) int streak,
    @Default(0) int totalCompletions,
  }) = _TaskEntity;
}

/// Subtask within a task.
@freezed
class SubtaskEntity with _$SubtaskEntity {
  const factory SubtaskEntity({
    required String id,
    required String taskId,
    required String title,
    @Default(false) bool isCompleted,
    required int order,
  }) = _SubtaskEntity;
}

/// Reminder configuration for a task.
@freezed
class ReminderConfig with _$ReminderConfig {
  const factory ReminderConfig({
    @Default(false) bool isEnabled,
    @Default(15) int offsetMinutes,
    DateTime? customTime,
  }) = _ReminderConfig;
}

/// Repeat / recurrence configuration for a task.
@freezed
class RepeatConfig with _$RepeatConfig {
  const factory RepeatConfig({
    @Default(RepeatType.none) RepeatType type,
    List<int>? customDays, // 0=Mon … 6=Sun
  }) = _RepeatConfig;
}
