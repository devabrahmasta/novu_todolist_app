import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_completion_entity.freezed.dart';

/// Records a single completion of a habit on a specific date.
@freezed
class HabitCompletionEntity with _$HabitCompletionEntity {
  const factory HabitCompletionEntity({
    required String id,
    required String habitId,
    required String date, // "yyyy-MM-dd"
    required int value, // 1 for yes/no, N for measurable
    required DateTime completedAt,
  }) = _HabitCompletionEntity;
}
