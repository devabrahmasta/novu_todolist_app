import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_analytics.freezed.dart';

/// Analytics data for a single task — used by GetTaskAnalyticsUsecase.
@freezed
class TaskAnalytics with _$TaskAnalytics {
  const factory TaskAnalytics({
    required int streak,
    required int totalCompletions,
    required DateTime createdAt,
    required List<bool> weeklyData, // last 7 days
    required List<bool> monthlyData, // last 30 days
    required int bestStreak,
  }) = _TaskAnalytics;
}
