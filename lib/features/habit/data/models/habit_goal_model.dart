import '../../../../core/utils/enums.dart';
import '../../domain/entities/habit_goal_entity.dart';

/// SQLite-backed habit goal model.
class HabitGoalModel {
  String id;
  String habitId;
  int targetDays;
  int startDate; // millisSinceEpoch
  int endDate;
  int currentProgress;
  int statusIndex; // HabitGoalStatus.index
  int createdAt;

  HabitGoalModel({
    required this.id,
    required this.habitId,
    required this.targetDays,
    required this.startDate,
    required this.endDate,
    this.currentProgress = 0,
    this.statusIndex = 0, // HabitGoalStatus.active
    required this.createdAt,
  });

  factory HabitGoalModel.fromMap(Map<String, dynamic> map) {
    return HabitGoalModel(
      id: map['id'] as String,
      habitId: map['habit_id'] as String,
      targetDays: map['target_days'] as int,
      startDate: map['start_date'] as int,
      endDate: map['end_date'] as int,
      currentProgress: map['current_progress'] as int? ?? 0,
      statusIndex: map['status'] as int? ?? 0,
      createdAt: map['created_at'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habit_id': habitId,
      'target_days': targetDays,
      'start_date': startDate,
      'end_date': endDate,
      'current_progress': currentProgress,
      'status': statusIndex,
      'created_at': createdAt,
    };
  }
}

// ─── Mapper Extensions ──────────────────────────────────

extension HabitGoalModelMapper on HabitGoalModel {
  HabitGoalEntity toEntity() {
    return HabitGoalEntity(
      id: id,
      habitId: habitId,
      targetDays: targetDays,
      startDate: DateTime.fromMillisecondsSinceEpoch(startDate),
      endDate: DateTime.fromMillisecondsSinceEpoch(endDate),
      currentProgress: currentProgress,
      status: HabitGoalStatus.values[statusIndex],
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
    );
  }
}

extension HabitGoalEntityMapper on HabitGoalEntity {
  HabitGoalModel toModel() {
    return HabitGoalModel(
      id: id,
      habitId: habitId,
      targetDays: targetDays,
      startDate: startDate.millisecondsSinceEpoch,
      endDate: endDate.millisecondsSinceEpoch,
      currentProgress: currentProgress,
      statusIndex: status.index,
      createdAt: createdAt.millisecondsSinceEpoch,
    );
  }
}
