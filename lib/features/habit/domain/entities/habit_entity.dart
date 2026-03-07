import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/enums.dart';

part 'habit_entity.freezed.dart';

/// Core habit entity — pure domain, no persistence details.
@freezed
class HabitEntity with _$HabitEntity {
  const factory HabitEntity({
    required String id,
    required String title,
    required HabitType type,
    required List<int> frequencyDays, // 0=Sun..6=Sat
    String? reminderTime, // "HH:mm" format
    String? unit, // Measurable only
    int? targetValue, // Measurable only
    MeasurableTarget? targetType,
    @Default([]) List<String> tags,
    @Default(Priority.medium) Priority priority,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _HabitEntity;
}
