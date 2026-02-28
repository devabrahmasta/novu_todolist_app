import 'package:uuid/uuid.dart';

import '../../features/category/data/datasources/category_local_data_source.dart';
import '../../features/category/data/models/category_model.dart';
import '../../features/category/domain/entities/category_entity.dart';
import '../../features/task/data/datasources/task_local_data_source.dart';
import '../../features/task/data/models/task_model.dart';
import '../../features/task/domain/entities/task_entity.dart';
import '../di/injection.dart';
import 'enums.dart';

/// Seeds default data on first launch (when database is empty).
class SeedData {
  SeedData._();

  static const _uuid = Uuid();

  static Future<void> init() async {
    final taskDs = getIt<TaskLocalDataSource>();
    final categoryDs = getIt<CategoryLocalDataSource>();

    final taskCount = await taskDs.countTasks();
    final categoryCount = await categoryDs.countCategories();

    // Only seed if DB is empty
    if (taskCount > 0 || categoryCount > 0) return;

    // ─── Default Categories ──────────────────────────────
    final workId = _uuid.v4();
    final personalId = _uuid.v4();
    final healthId = _uuid.v4();

    final categories = [
      CategoryEntity(
        id: workId,
        name: 'Work',
        colorHex: 'FF8C7DFF',
        iconName: 'work',
        createdAt: DateTime.now(),
      ),
      CategoryEntity(
        id: personalId,
        name: 'Personal',
        colorHex: 'FF34D399',
        iconName: 'person',
        createdAt: DateTime.now(),
      ),
      CategoryEntity(
        id: healthId,
        name: 'Health',
        colorHex: 'FFFF9A3C',
        iconName: 'fitness',
        createdAt: DateTime.now(),
      ),
    ];

    for (final cat in categories) {
      await categoryDs.putCategory(cat.toModel());
    }

    // ─── Sample Tasks ────────────────────────────────────
    final now = DateTime.now();

    final tasks = [
      // 1. Design System Update — Work, morning, pending, 2 subtasks
      TaskEntity(
        id: _uuid.v4(),
        title: 'Design System Update',
        categoryId: workId,
        timeOfDay: TimeOfDaySlot.morning,
        status: TaskStatus.pending,
        subtasks: [
          SubtaskEntity(
            id: _uuid.v4(),
            taskId: '', // will be set by model
            title: 'Review color tokens',
            order: 0,
          ),
          SubtaskEntity(
            id: _uuid.v4(),
            taskId: '',
            title: 'Update typography scale',
            order: 1,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      // 2. Team Sync — Work, afternoon, pending, 0 subtasks
      TaskEntity(
        id: _uuid.v4(),
        title: 'Team Sync',
        categoryId: workId,
        timeOfDay: TimeOfDaySlot.afternoon,
        status: TaskStatus.pending,
        createdAt: now,
        updatedAt: now,
      ),
      // 3. Evening Run — Health, evening, pending, 0 subtasks
      TaskEntity(
        id: _uuid.v4(),
        title: 'Evening Run',
        categoryId: healthId,
        timeOfDay: TimeOfDaySlot.evening,
        status: TaskStatus.pending,
        createdAt: now,
        updatedAt: now,
      ),
      // 4. Read 20 pages — Personal, evening, completed, 0 subtasks
      TaskEntity(
        id: _uuid.v4(),
        title: 'Read 20 pages',
        categoryId: personalId,
        timeOfDay: TimeOfDaySlot.evening,
        status: TaskStatus.completed,
        completedAt: now,
        createdAt: now,
        updatedAt: now,
        totalCompletions: 1,
        streak: 1,
      ),
      // 5. Grocery Shopping — Personal, afternoon, pending, 3 subtasks
      TaskEntity(
        id: _uuid.v4(),
        title: 'Grocery Shopping',
        categoryId: personalId,
        timeOfDay: TimeOfDaySlot.afternoon,
        status: TaskStatus.pending,
        subtasks: [
          SubtaskEntity(
            id: _uuid.v4(),
            taskId: '',
            title: 'Fruits & vegetables',
            order: 0,
          ),
          SubtaskEntity(
            id: _uuid.v4(),
            taskId: '',
            title: 'Dairy & eggs',
            order: 1,
          ),
          SubtaskEntity(id: _uuid.v4(), taskId: '', title: 'Snacks', order: 2),
        ],
        createdAt: now,
        updatedAt: now,
      ),
    ];

    for (final task in tasks) {
      final taskModel = task.toModel();
      final subtaskModels = task.subtasksToModels();
      await taskDs.putTask(taskModel, subtasks: subtaskModels);
    }
  }
}
