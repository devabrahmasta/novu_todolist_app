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

/// Home Screen Dashboard — the main entry point of Novu.
///
/// Uses a CustomScrollView with slivers for 60fps scrolling performance.
/// Componentized into private widgets: _HomeHeader, _ProgressSummaryCard,
/// _FilterChips, _ListHeader, and individual TaskCards.
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

            // ── 2. Progress Card ─────────────────
            SliverToBoxAdapter(
              child: _ProgressSummaryCard(taskAsync: taskAsync),
            ),

            // ── 3. Filter Chips ──────────────────
            SliverToBoxAdapter(
              child: _FilterChips(categoryAsync: categoryAsync),
            ),

            // ── 4. Task List (grouped by morning/afternoon/evening) ──
            ..._buildGroupedTaskSlivers(context, ref, taskAsync, categoryAsync),

            // ── 5. Bottom padding (FAB overlap) ──
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 1. HEADER
// ═══════════════════════════════════════════════════════════════

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _formattedDate() {
    final now = DateTime.now();
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${_greeting()} ☀️', style: textTheme.headlineLarge),
                const SizedBox(height: 4),
                Text(_formattedDate(), style: textTheme.bodySmall),
              ],
            ),
          ),
          // Notification bell
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.surface2,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              color: colors.textSecondary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 2. PROGRESS SUMMARY CARD
// ═══════════════════════════════════════════════════════════════

class _ProgressSummaryCard extends StatelessWidget {
  const _ProgressSummaryCard({required this.taskAsync});

  final AsyncValue<List<TaskEntity>> taskAsync;

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    final tasks = taskAsync.valueOrNull ?? [];
    final total = tasks.where((t) => t.status != TaskStatus.archived).length;
    final completed = tasks
        .where((t) => t.status == TaskStatus.completed)
        .length;
    final progress = total > 0 ? completed / total : 0.0;
    final percent = (progress * 100).toInt();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.border, width: 1),
        ),
        child: Row(
          children: [
            // ── Left column: text + button ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _motivationalText(progress),
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$completed of $total tasks done',
                    style: textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: colors.textPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        elevation: 0,
                      ),
                      child: Text(
                        'View Report',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // ── Right column: circular progress ──
            SizedBox(
              width: 72,
              height: 72,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: colors.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                  Center(
                    child: Text(
                      '$percent%',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _motivationalText(double progress) {
    if (progress >= 1.0) return 'All done! 🎉';
    if (progress >= 0.7) return "You're on fire! 🔥";
    if (progress >= 0.3) return 'Keep going! 💪';
    return 'Let\'s start! 🚀';
  }
}

// ═══════════════════════════════════════════════════════════════
// 3. FILTER CHIPS
// ═══════════════════════════════════════════════════════════════

class _FilterChips extends ConsumerWidget {
  const _FilterChips({required this.categoryAsync});

  final AsyncValue<List<CategoryEntity>> categoryAsync;

  String _formatShortDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.novuColors;
    final activeFilter = ref.watch(activeFilterProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final isToday = isSameDay(selectedDate, DateTime.now());
    final categories = categoryAsync.valueOrNull ?? [];

    // Build chip list: Date chip + "All" + dynamic categories
    final categoryChips = <_ChipData>[
      _ChipData(id: null, label: 'All'),
      ...categories.map((c) => _ChipData(id: c.id, label: c.name)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: categoryChips.length + 1, // +1 for date chip
          separatorBuilder: (context, i) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            // Index 0 = date chip
            if (index == 0) {
              return GestureDetector(
                onTap: () {
                  // Tapping resets to today
                  ref
                      .read(selectedDateProvider.notifier)
                      .setDate(DateTime.now());
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 14,
                        color: colors.textPrimary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isToday ? 'Today' : _formatShortDate(selectedDate),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Category chips (offset by 1)
            final chip = categoryChips[index - 1];
            final isSelected = activeFilter == chip.id;

            return GestureDetector(
              onTap: () {
                ref
                    .read(activeFilterProvider.notifier)
                    .setCategoryId(isSelected ? null : chip.id);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : colors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : colors.border,
                    width: 1,
                  ),
                ),
                child: Text(
                  chip.label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected
                        ? colors.textPrimary
                        : colors.textSecondary,
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
// 4. SECTION HEADER
// ═══════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Text(title, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 5. GROUPED TASK SLIVERS (Morning / Afternoon / Evening)
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
      // 1. Exclude archived
      var filtered = tasks
          .where((t) => t.status != TaskStatus.archived)
          .toList();

      // 2. Filter by selected date
      filtered = filtered.where((t) {
        if (t.dueDate == null) {
          return isSameDay(selectedDate, DateTime.now());
        }
        return isSameDay(t.dueDate!, selectedDate);
      }).toList();

      // 3. Apply category filter on top
      if (activeFilter != null) {
        filtered = filtered.where((t) => t.categoryId == activeFilter).toList();
      }

      // Sort within each group
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

      // Group by timeOfDay slot
      final grouped = <TimeOfDaySlot, List<TaskEntity>>{};
      for (final task in filtered) {
        grouped.putIfAbsent(task.timeOfDay, () => []).add(task);
      }

      final slivers = <Widget>[];
      for (final section in _slotSections) {
        final slotTasks = grouped[section.slot];
        if (slotTasks == null || slotTasks.isEmpty) continue;

        // Section header
        slivers.add(
          SliverToBoxAdapter(child: _SectionHeader(title: section.title)),
        );

        // Task cards for this slot
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
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Circle skeleton
                    Container(
                      width: 24,
                      height: 24,
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
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
