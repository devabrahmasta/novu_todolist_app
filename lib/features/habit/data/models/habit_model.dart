import 'dart:convert';

import '../../../../core/utils/enums.dart';
import '../../domain/entities/habit_entity.dart';

/// SQLite-backed habit model.
class HabitModel {
  String id;
  String title;
  int typeIndex; // HabitType.index
  String frequencyDaysJson; // JSON list of ints
  String? reminderTime;
  String? unit;
  int? targetValue;
  int? targetTypeIndex; // MeasurableTarget.index
  String tagsJson; // JSON list of strings
  int priorityIndex; // Priority.index
  int createdAt; // millisSinceEpoch
  int updatedAt;

  HabitModel({
    required this.id,
    required this.title,
    required this.typeIndex,
    required this.frequencyDaysJson,
    this.reminderTime,
    this.unit,
    this.targetValue,
    this.targetTypeIndex,
    this.tagsJson = '[]',
    this.priorityIndex = 1, // Priority.medium
    required this.createdAt,
    required this.updatedAt,
  });

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      id: map['id'] as String,
      title: map['title'] as String,
      typeIndex: map['type'] as int,
      frequencyDaysJson: map['frequency_days'] as String,
      reminderTime: map['reminder_time'] as String?,
      unit: map['unit'] as String?,
      targetValue: map['target_value'] as int?,
      targetTypeIndex: map['target_type'] as int?,
      tagsJson: map['tags'] as String? ?? '[]',
      priorityIndex: map['priority'] as int? ?? 1,
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': typeIndex,
      'frequency_days': frequencyDaysJson,
      'reminder_time': reminderTime,
      'unit': unit,
      'target_value': targetValue,
      'target_type': targetTypeIndex,
      'tags': tagsJson,
      'priority': priorityIndex,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

// ─── Mapper Extensions ──────────────────────────────────

extension HabitModelMapper on HabitModel {
  HabitEntity toEntity() {
    return HabitEntity(
      id: id,
      title: title,
      type: HabitType.values[typeIndex],
      frequencyDays: (jsonDecode(frequencyDaysJson) as List)
          .map((e) => e as int)
          .toList(),
      reminderTime: reminderTime,
      unit: unit,
      targetValue: targetValue,
      targetType:
          targetTypeIndex != null
              ? MeasurableTarget.values[targetTypeIndex!]
              : null,
      tags: (jsonDecode(tagsJson) as List).map((e) => e as String).toList(),
      priority: Priority.values[priorityIndex],
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
    );
  }
}

extension HabitEntityMapper on HabitEntity {
  HabitModel toModel() {
    return HabitModel(
      id: id,
      title: title,
      typeIndex: type.index,
      frequencyDaysJson: jsonEncode(frequencyDays),
      reminderTime: reminderTime,
      unit: unit,
      targetValue: targetValue,
      targetTypeIndex: targetType?.index,
      tagsJson: jsonEncode(tags),
      priorityIndex: priority.index,
      createdAt: createdAt.millisecondsSinceEpoch,
      updatedAt: updatedAt.millisecondsSinceEpoch,
    );
  }
}
