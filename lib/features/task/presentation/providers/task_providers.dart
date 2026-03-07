import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/archive_task_usecase.dart';
import '../../domain/usecases/complete_task_usecase.dart';
import '../../domain/usecases/create_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/get_all_tasks_usecase.dart';
import '../../domain/usecases/get_task_analytics_usecase.dart';
import '../../domain/usecases/get_task_by_id_usecase.dart';
import '../../domain/usecases/get_tasks_by_date_usecase.dart';
import '../../domain/usecases/get_tasks_by_time_slot_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';
import '../../domain/entities/task_analytics.dart';

part 'task_providers.g.dart';

// ─── Use case providers (bridge get_it → Riverpod) ──────

@riverpod
GetAllTasksUsecase getAllTasksUsecase(GetAllTasksUsecaseRef ref) =>
    getIt<GetAllTasksUsecase>();

@riverpod
GetTasksByDateUsecase getTasksByDateUsecase(GetTasksByDateUsecaseRef ref) =>
    getIt<GetTasksByDateUsecase>();

@riverpod
GetTasksByTimeSlotUsecase getTasksByTimeSlotUsecase(
  GetTasksByTimeSlotUsecaseRef ref,
) => getIt<GetTasksByTimeSlotUsecase>();

@riverpod
GetTaskByIdUsecase getTaskByIdUsecase(GetTaskByIdUsecaseRef ref) =>
    getIt<GetTaskByIdUsecase>();

@riverpod
CreateTaskUsecase createTaskUsecase(CreateTaskUsecaseRef ref) =>
    getIt<CreateTaskUsecase>();

@riverpod
UpdateTaskUsecase updateTaskUsecase(UpdateTaskUsecaseRef ref) =>
    getIt<UpdateTaskUsecase>();

@riverpod
DeleteTaskUsecase deleteTaskUsecase(DeleteTaskUsecaseRef ref) =>
    getIt<DeleteTaskUsecase>();

@riverpod
CompleteTaskUsecase completeTaskUsecase(CompleteTaskUsecaseRef ref) =>
    getIt<CompleteTaskUsecase>();

@riverpod
ArchiveTaskUsecase archiveTaskUsecase(ArchiveTaskUsecaseRef ref) =>
    getIt<ArchiveTaskUsecase>();

@riverpod
GetTaskAnalyticsUsecase getTaskAnalyticsUsecase(
  GetTaskAnalyticsUsecaseRef ref,
) => getIt<GetTaskAnalyticsUsecase>();

// ─── State providers ─────────────────────────────────────

@riverpod
class SelectedDate extends _$SelectedDate {
  @override
  DateTime build() => DateTime.now();

  void setDate(DateTime date) => state = date;
}

@riverpod
class ActiveFilter extends _$ActiveFilter {
  @override
  String? build() => null;

  void setCategoryId(String? id) => state = id;
}

// ─── Task list notifier ─────────────────────────────────

@riverpod
class TaskListNotifier extends _$TaskListNotifier {
  @override
  Future<List<TaskEntity>> build() async {
    final result = await ref.watch(getAllTasksUsecaseProvider).call();
    return result.getOrElse((_) => []);
  }

  Future<void> createTask(TaskEntity task) async {
    state = const AsyncLoading();
    final result = await ref.read(createTaskUsecaseProvider).call(task);
    result.fold(
      (f) => state = AsyncError(f.message, StackTrace.current),
      (_) => ref.invalidateSelf(),
    );
  }

  Future<void> completeTask(String id) async {
    state = const AsyncLoading();
    final result = await ref.read(completeTaskUsecaseProvider).call(id);
    result.fold(
      (f) => state = AsyncError(f.message, StackTrace.current),
      (_) => ref.invalidateSelf(),
    );
  }

  Future<void> deleteTask(String id) async {
    state = const AsyncLoading();
    final result = await ref.read(deleteTaskUsecaseProvider).call(id);
    result.fold(
      (f) => state = AsyncError(f.message, StackTrace.current),
      (_) => ref.invalidateSelf(),
    );
  }

  Future<void> archiveTask(String id) async {
    state = const AsyncLoading();
    final result = await ref.read(archiveTaskUsecaseProvider).call(id);
    result.fold(
      (f) => state = AsyncError(f.message, StackTrace.current),
      (_) => ref.invalidateSelf(),
    );
  }
}

// ─── Task analytics provider ────────────────────────────

@riverpod
Future<TaskAnalytics> taskAnalytics(TaskAnalyticsRef ref, String taskId) async {
  final result = await ref.watch(getTaskAnalyticsUsecaseProvider).call(taskId);
  return result.getOrElse(
    (_) => TaskAnalytics(
      streak: 0,
      totalCompletions: 0,
      createdAt: DateTime.now(),
      weeklyData: List.filled(7, false),
      monthlyData: List.filled(30, false),
      bestStreak: 0,
    ),
  );
}

// ─── Task Future provider ────────────────────────────

@riverpod
Future<TaskEntity?> taskDetailFuture(TaskDetailFutureRef ref, String id) async {
  final result = await ref.watch(getTaskByIdUsecaseProvider).call(id);
  return result.getOrElse((_) => throw Exception('Failed to get task detail'));
}
