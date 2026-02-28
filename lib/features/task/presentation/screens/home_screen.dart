import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/enums.dart';
import '../../../category/domain/entities/category_entity.dart';
import '../../../category/presentation/providers/category_providers.dart';
import '../../domain/entities/task_entity.dart';
import '../providers/task_providers.dart';
import '../widgets/create_task_bottom_sheet.dart';
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
      backgroundColor: AppColors.bg,
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

            // ── 4. Section Header ────────────────
            const SliverToBoxAdapter(child: _ListHeader()),

            // ── 5. Task List ─────────────────────
            _TaskListSliver(taskAsync: taskAsync, categoryAsync: categoryAsync),

            // ── 6. Bottom padding (FAB overlap) ──
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: _HomeFAB(
        onPressed: () {
          showCreateTaskSheet(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const _BottomNavBar(),
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
                Text('${_greeting()} ☀️', style: AppTextStyles.headingLarge),
                const SizedBox(height: 4),
                Text(_formattedDate(), style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          // Notification bell
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.surface2,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textSecondary,
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
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border, width: 1),
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
                    style: AppTextStyles.headingMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$completed of $total tasks done',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        elevation: 0,
                      ),
                      child: Text(
                        'View Report',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
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
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                  Center(
                    child: Text(
                      '$percent%',
                      style: AppTextStyles.bodyLarge.copyWith(
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(activeFilterProvider);
    final categories = categoryAsync.valueOrNull ?? [];

    // Build chip list: "All" + "Today" + dynamic categories
    final chips = <_ChipData>[
      _ChipData(id: null, label: 'All'),
      _ChipData(id: '__today__', label: 'Today'),
      ...categories.map((c) => _ChipData(id: c.id, label: c.name)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: chips.length,
          separatorBuilder: (context, i) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: 1,
                  ),
                ),
                child: Text(
                  chip.label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
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
// 4. LIST HEADER
// ═══════════════════════════════════════════════════════════════

class _ListHeader extends StatelessWidget {
  const _ListHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Text('UPCOMING TASKS', style: AppTextStyles.labelSmall),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 5. TASK LIST (Sliver)
// ═══════════════════════════════════════════════════════════════

class _TaskListSliver extends ConsumerWidget {
  const _TaskListSliver({required this.taskAsync, required this.categoryAsync});

  final AsyncValue<List<TaskEntity>> taskAsync;
  final AsyncValue<List<CategoryEntity>> categoryAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(activeFilterProvider);
    final categories = categoryAsync.valueOrNull ?? [];

    // Build a lookup map for category by ID
    final categoryMap = {for (final c in categories) c.id: c};

    return taskAsync.when(
      data: (tasks) {
        // Apply filter
        var filtered = tasks
            .where((t) => t.status != TaskStatus.archived)
            .toList();

        if (activeFilter == '__today__') {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          filtered = filtered.where((t) {
            if (t.dueDate == null) {
              // Show today's tasks (created today or no specific date)
              return true;
            }
            final due = DateTime(
              t.dueDate!.year,
              t.dueDate!.month,
              t.dueDate!.day,
            );
            return due.isAtSameMomentAs(today) || due.isBefore(today);
          }).toList();
        } else if (activeFilter != null) {
          filtered = filtered
              .where((t) => t.categoryId == activeFilter)
              .toList();
        }

        // Sort: pending first, then completed
        filtered.sort((a, b) {
          if (a.status == TaskStatus.completed &&
              b.status != TaskStatus.completed) {
            return 1;
          }
          if (a.status != TaskStatus.completed &&
              b.status == TaskStatus.completed) {
            return -1;
          }
          return 0;
        });

        if (filtered.isEmpty) {
          return SliverToBoxAdapter(
            child: _EmptyState(hasFilter: activeFilter != null),
          );
        }

        return SliverList.builder(
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final task = filtered[index];
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
                ref.read(taskListNotifierProvider.notifier).deleteTask(task.id);
              },
              onTap: () {
                context.pushNamed(
                  RouteNames.taskView,
                  pathParameters: {'id': task.id},
                );
              },
            );
          },
        );
      },
      loading: () => SliverToBoxAdapter(child: _SkeletonLoader()),
      error: (err, _) => SliverToBoxAdapter(
        child: _ErrorWidget(
          message: err.toString(),
          onRetry: () => ref.invalidate(taskListNotifierProvider),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// EMPTY / LOADING / ERROR STATES
// ═══════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  const _EmptyState({this.hasFilter = false});

  final bool hasFilter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              size: 48,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              hasFilter ? 'No tasks in this filter' : 'No tasks yet',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hasFilter
                  ? 'Try a different filter or create a new task'
                  : 'Tap + to create your first task',
              style: AppTextStyles.bodySmall,
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
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 1),
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
                        color: AppColors.surface2,
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
                              color: AppColors.surface2,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 10,
                            width: 120,
                            decoration: BoxDecoration(
                              color: AppColors.surface2,
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
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text('Retry', style: AppTextStyles.bodySmall),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// FAB
// ═══════════════════════════════════════════════════════════════

class _HomeFAB extends StatelessWidget {
  const _HomeFAB({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        elevation: 0,
        backgroundColor: Colors.transparent,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// BOTTOM NAV BAR
// ═══════════════════════════════════════════════════════════════

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.check_circle_outline_rounded,
                label: 'Tasks',
                isActive: true,
                onTap: () {},
              ),
              _NavItem(
                icon: Icons.calendar_today_rounded,
                label: 'Calendar',
                onTap: () => context.pushNamed(RouteNames.calendar),
              ),
              // Center space for FAB
              const SizedBox(width: 58),
              _NavItem(
                icon: Icons.folder_outlined,
                label: 'Projects',
                onTap: () {},
              ),
              _NavItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                onTap: () => context.pushNamed(RouteNames.settings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.textMuted;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 10,
                color: color,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
