import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart' show isSameDay;

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/novu_colors_extension.dart';
import '../../../../core/utils/enums.dart';
import '../../../category/domain/entities/category_entity.dart';
import '../../../category/presentation/providers/category_providers.dart';
import '../../domain/entities/task_entity.dart';
import '../providers/task_providers.dart';
import '../widgets/task_card.dart';

/// Home Screen — "Today Task" dashboard matching the Novu mockup.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(taskListNotifierProvider);
    final categoryAsync = ref.watch(categoryListNotifierProvider);

    return Scaffold(
      backgroundColor: context.novuColors.bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── 1. Header ────────────────────────
            const SliverToBoxAdapter(child: _HomeHeader()),

            // ── 2. Filter Chips ──────────────────
            SliverToBoxAdapter(
              child: _FilterChips(categoryAsync: categoryAsync),
            ),

            // ── 3. Task List (grouped by morning/afternoon/evening) ──
            ..._buildGroupedTaskSlivers(context, ref, taskAsync, categoryAsync),

            // ── 4. Bottom padding (FAB overlap) ──
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 1. HEADER — "Today Task" + date
// ═══════════════════════════════════════════════════════════════

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  String _formattedDate() {
    final now = DateTime.now();
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday',
    ];
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today Task',
            style: textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _formattedDate(),
            style: textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 2. FILTER CHIPS — "All" (filled) + category chips (outlined)
// ═══════════════════════════════════════════════════════════════

class _FilterChips extends ConsumerWidget {
  const _FilterChips({required this.categoryAsync});
  final AsyncValue<List<CategoryEntity>> categoryAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    final activeFilter = ref.watch(activeFilterProvider);
    final categories = categoryAsync.valueOrNull ?? [];

    final chips = <_ChipData>[
      _ChipData(id: null, label: 'All'),
      ...categories.map((c) => _ChipData(id: c.id, label: c.name)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: chips.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, index) {
            final chip = chips[index];
            final isSelected = activeFilter == chip.id;

            return GestureDetector(
              onTap: () {
                ref
                    .read(activeFilterProvider.notifier)
                    .setCategoryId(isSelected ? null : chip.id);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? colors.textPrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? colors.textPrimary : colors.border,
                    width: 1,
                  ),
                ),
                child: Text(
                  chip.label,
                  style: textTheme.bodySmall?.copyWith(
                    color: isSelected ? colors.bg : colors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ChipData {
  const _ChipData({required this.id, required this.label});
  final String? id;
  final String label;
}

// ═══════════════════════════════════════════════════════════════
// 3. SECTION HEADER — "MORNING", "AFTERNOON", "EVENING"
// ═══════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(
        title,
        style: AppTextStyles.bodySmall.copyWith(
          color: colors.textMuted,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          fontSize: 11,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 4. GROUPED TASK SLIVERS (Morning / Afternoon / Evening)
// ═══════════════════════════════════════════════════════════════

const _slotSections = [
  (slot: TimeOfDaySlot.morning, title: 'MORNING'),
  (slot: TimeOfDaySlot.afternoon, title: 'AFTERNOON'),
  (slot: TimeOfDaySlot.evening, title: 'EVENING'),
];

List<Widget> _buildGroupedTaskSlivers(
  BuildContext context,
  WidgetRef ref,
  AsyncValue<List<TaskEntity>> taskAsync,
  AsyncValue<List<CategoryEntity>> categoryAsync,
) {
  final activeFilter = ref.watch(activeFilterProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  final categories = categoryAsync.valueOrNull ?? [];
  final categoryMap = {for (final c in categories) c.id: c};

  return taskAsync.when(
    data: (tasks) {
      var filtered = tasks
          .where((t) => t.status != TaskStatus.archived)
          .toList();

      filtered = filtered.where((t) {
        if (t.dueDate == null) {
          return isSameDay(selectedDate, DateTime.now());
        }
        return isSameDay(t.dueDate!, selectedDate);
      }).toList();

      if (activeFilter != null) {
        filtered = filtered.where((t) => t.categoryId == activeFilter).toList();
      }

      filtered.sort((a, b) {
        final aCompleted = a.status == TaskStatus.completed;
        final bCompleted = b.status == TaskStatus.completed;
        if (aCompleted != bCompleted) return aCompleted ? 1 : -1;

        final slotCompare = a.timeOfDay.index.compareTo(b.timeOfDay.index);
        if (slotCompare != 0) return slotCompare;

        if (a.dueTime != null && b.dueTime != null) {
          final aMinutes = a.dueTime!.hour * 60 + a.dueTime!.minute;
          final bMinutes = b.dueTime!.hour * 60 + b.dueTime!.minute;
          return aMinutes.compareTo(bMinutes);
        }
        if (a.dueTime != null) return -1;
        if (b.dueTime != null) return 1;

        return a.createdAt.compareTo(b.createdAt);
      });

      if (filtered.isEmpty) {
        return [
          SliverToBoxAdapter(
            child: _EmptyState(hasFilter: activeFilter != null),
          ),
        ];
      }

      final grouped = <TimeOfDaySlot, List<TaskEntity>>{};
      for (final task in filtered) {
        grouped.putIfAbsent(task.timeOfDay, () => []).add(task);
      }

      final slivers = <Widget>[];
      for (final section in _slotSections) {
        final slotTasks = grouped[section.slot];
        if (slotTasks == null || slotTasks.isEmpty) continue;

        slivers.add(
          SliverToBoxAdapter(child: _SectionHeader(title: section.title)),
        );

        slivers.add(
          SliverList.builder(
            itemCount: slotTasks.length,
            itemBuilder: (context, index) {
              final task = slotTasks[index];
              final category = task.categoryId != null
                  ? categoryMap[task.categoryId!]
                  : null;

              return TaskCard(
                task: task,
                category: category,
                onToggleStatus: () {
                  ref
                      .read(taskListNotifierProvider.notifier)
                      .completeTask(task.id);
                },
                onArchive: () {
                  ref
                      .read(taskListNotifierProvider.notifier)
                      .archiveTask(task.id);
                },
                onDelete: () {
                  ref
                      .read(taskListNotifierProvider.notifier)
                      .deleteTask(task.id);
                },
                onTap: () {
                  context.pushNamed(
                    RouteNames.taskView,
                    pathParameters: {'id': task.id},
                  );
                },
              );
            },
          ),
        );
      }

      return slivers;
    },
    loading: () => [SliverToBoxAdapter(child: _SkeletonLoader())],
    error: (err, _) => [
      SliverToBoxAdapter(
        child: _ErrorWidget(
          message: err.toString(),
          onRetry: () => ref.invalidate(taskListNotifierProvider),
        ),
      ),
    ],
  );
}

// ═══════════════════════════════════════════════════════════════
// EMPTY / LOADING / ERROR STATES
// ═══════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  const _EmptyState({this.hasFilter = false});
  final bool hasFilter;

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 48,
              color: colors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              hasFilter ? 'No tasks in this filter' : 'No tasks yet',
              style: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              hasFilter
                  ? 'Try a different filter or create a new task'
                  : 'Tap + to create your first task',
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(
          4,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.border, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.surface2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 14,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: colors.surface2,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 10,
                            width: 120,
                            decoration: BoxDecoration(
                              color: colors.surface2,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops, something went wrong',
              style: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text('Retry', style: textTheme.bodySmall),
              style: TextButton.styleFrom(
                foregroundColor: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
