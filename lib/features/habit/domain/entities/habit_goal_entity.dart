import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/enums.dart';

part 'habit_goal_entity.freezed.dart';

/// A timed challenge / goal attached to a habit.
@freezed
class HabitGoalEntity with _$HabitGoalEntity {
  const factory HabitGoalEntity({
    required String id,
    required String habitId,
    required int targetDays,
    required DateTime startDate,
    required DateTime endDate,
    @Default(0) int currentProgress,
    @Default(HabitGoalStatus.active) HabitGoalStatus status,
    required DateTime createdAt,
  }) = _HabitGoalEntity;
}
