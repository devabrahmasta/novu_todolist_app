import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_step_entity.freezed.dart';

/// A single step within a habit routine.
@freezed
class HabitStepEntity with _$HabitStepEntity {
  const factory HabitStepEntity({
    required String id,
    required String habitId,
    required String title,
    required int order,
  }) = _HabitStepEntity;
}
