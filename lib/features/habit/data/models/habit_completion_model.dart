import '../../domain/entities/habit_completion_entity.dart';

/// SQLite-backed habit completion model.
class HabitCompletionModel {
  String id;
  String habitId;
  String date; // "yyyy-MM-dd"
  int value;
  int completedAt; // millisSinceEpoch

  HabitCompletionModel({
    required this.id,
    required this.habitId,
    required this.date,
    required this.value,
    required this.completedAt,
  });

  factory HabitCompletionModel.fromMap(Map<String, dynamic> map) {
    return HabitCompletionModel(
      id: map['id'] as String,
      habitId: map['habit_id'] as String,
      date: map['date'] as String,
      value: map['value'] as int,
      completedAt: map['completed_at'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habit_id': habitId,
      'date': date,
      'value': value,
      'completed_at': completedAt,
    };
  }
}

// ─── Mapper Extensions ──────────────────────────────────

extension HabitCompletionModelMapper on HabitCompletionModel {
  HabitCompletionEntity toEntity() {
    return HabitCompletionEntity(
      id: id,
      habitId: habitId,
      date: date,
      value: value,
      completedAt: DateTime.fromMillisecondsSinceEpoch(completedAt),
    );
  }
}

extension HabitCompletionEntityMapper on HabitCompletionEntity {
  HabitCompletionModel toModel() {
    return HabitCompletionModel(
      id: id,
      habitId: habitId,
      date: date,
      value: value,
      completedAt: completedAt.millisecondsSinceEpoch,
    );
  }
}
