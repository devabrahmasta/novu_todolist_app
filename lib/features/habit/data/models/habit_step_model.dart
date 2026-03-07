import '../../domain/entities/habit_step_entity.dart';

/// SQLite-backed habit step model.
class HabitStepModel {
  String id;
  String habitId;
  String title;
  int orderIndex;

  HabitStepModel({
    required this.id,
    required this.habitId,
    required this.title,
    required this.orderIndex,
  });

  factory HabitStepModel.fromMap(Map<String, dynamic> map) {
    return HabitStepModel(
      id: map['id'] as String,
      habitId: map['habit_id'] as String,
      title: map['title'] as String,
      orderIndex: map['order_index'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habit_id': habitId,
      'title': title,
      'order_index': orderIndex,
    };
  }
}

// ─── Mapper Extensions ──────────────────────────────────

extension HabitStepModelMapper on HabitStepModel {
  HabitStepEntity toEntity() {
    return HabitStepEntity(
      id: id,
      habitId: habitId,
      title: title,
      order: orderIndex,
    );
  }
}

extension HabitStepEntityMapper on HabitStepEntity {
  HabitStepModel toModel() {
    return HabitStepModel(
      id: id,
      habitId: habitId,
      title: title,
      orderIndex: order,
    );
  }
}
