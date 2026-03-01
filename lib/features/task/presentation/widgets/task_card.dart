import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/novu_colors_extension.dart';
import '../../../../core/utils/enums.dart';
import '../../domain/entities/task_entity.dart';
import '../../../category/domain/entities/category_entity.dart';

/// Reusable, state-driven task card widget.
///
/// Renders different visual states based on the task's status and due date:
/// - Default: outline checkbox, white title, subtitle with category & time
/// - Completed: filled checkbox, strikethrough title, muted text
/// - Overdue: error-colored border, checkbox, and time text
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleStatus,
    required this.onArchive,
    required this.onDelete,
    required this.onTap,
    this.category,
  });

  final TaskEntity task;
  final VoidCallback onToggleStatus;
  final VoidCallback onArchive;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final CategoryEntity? category;

  // ─── State helpers ────────────────────────────────────────
  bool get _isCompleted => task.status == TaskStatus.completed;

  bool get _isOverdue {
    if (_isCompleted || task.dueDate == null) return false;
    final today = DateTime.now();
    final due = task.dueDate!;
    return DateTime(
      due.year,
      due.month,
      due.day,
    ).isBefore(DateTime(today.year, today.month, today.day));
  }

  // ─── Build ────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    final borderColor = _isOverdue ? AppColors.error : colors.border;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Slidable(
        key: ValueKey(task.id),
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.5,
          children: [
            CustomSlidableAction(
              padding: EdgeInsets.zero,
              onPressed: (_) => onArchive(),
              backgroundColor: colors.surface2,
              foregroundColor: colors.textSecondary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: const Icon(Icons.archive_outlined, size: 22)),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      'Archive',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            CustomSlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: AppColors.error.withValues(alpha: 0.1),
              foregroundColor: AppColors.error,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: const Icon(Icons.delete_outline, size: 22)),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      'Delete',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        child: _CardBody(
          task: task,
          category: category,
          isCompleted: _isCompleted,
          isOverdue: _isOverdue,
          borderColor: borderColor,
          onToggleStatus: onToggleStatus,
          onTap: onTap,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Private sub-components
// ═══════════════════════════════════════════════════════════

class _CardBody extends StatelessWidget {
  const _CardBody({
    required this.task,
    required this.category,
    required this.isCompleted,
    required this.isOverdue,
    required this.borderColor,
    required this.onToggleStatus,
    required this.onTap,
  });

  final TaskEntity task;
  final CategoryEntity? category;
  final bool isCompleted;
  final bool isOverdue;
  final Color borderColor;
  final VoidCallback onToggleStatus;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Checkbox + Title Row ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Checkbox(
                  isCompleted: isCompleted,
                  isOverdue: isOverdue,
                  onTap: onToggleStatus,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        task.title,
                        style: isCompleted
                            ? textTheme.bodyLarge?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: colors.textSecondary,
                                decorationColor: colors.textSecondary,
                              )
                            : textTheme.bodyLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Subtitle: Category • Time
                      _SubtitleRow(
                        task: task,
                        category: category,
                        isOverdue: isOverdue,
                      ),
                    ],
                  ),
                ),
                // Priority indicator
                if (task.priority != null) ...[
                  const SizedBox(width: 8),
                  _PriorityDot(priority: task.priority!),
                ],
              ],
            ),
            // ── Subtask progress bar ──
            if (task.subtasks.isNotEmpty) ...[
              const SizedBox(height: 12),
              _SubtaskProgressBar(subtasks: task.subtasks),
            ],
          ],
        ),
      ),
    );
  }
}

/// Circular checkbox — outline (pending), solid (completed), error (overdue).
class _Checkbox extends StatelessWidget {
  const _Checkbox({
    required this.isCompleted,
    required this.isOverdue,
    required this.onTap,
  });

  final bool isCompleted;
  final bool isOverdue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 24,
        height: 24,
        margin: const EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted ? AppColors.primary : Colors.transparent,
          border: Border.all(
            color: isCompleted
                ? AppColors.primary
                : isOverdue
                ? AppColors.error
                : colors.textMuted,
            width: 2,
          ),
        ),
        child: isCompleted
            ? const Icon(Icons.check, size: 14, color: Colors.white)
            : null,
      ),
    );
  }
}

/// Category icon + name • Time
class _SubtitleRow extends StatelessWidget {
  const _SubtitleRow({
    required this.task,
    required this.category,
    required this.isOverdue,
  });

  final TaskEntity task;
  final CategoryEntity? category;
  final bool isOverdue;

  String _formatTimeText() {
    if (task.dueDate == null) {
      return task.timeOfDay.name[0].toUpperCase() +
          task.timeOfDay.name.substring(1);
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(
      task.dueDate!.year,
      task.dueDate!.month,
      task.dueDate!.day,
    );
    final diff = due.difference(today).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    if (diff < -1) {
      return '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}';
    }
    return '${task.dueDate!.day}/${task.dueDate!.month}';
  }

  IconData _categoryIcon(String? iconName) {
    switch (iconName) {
      case 'work':
        return Icons.work_outlined;
      case 'person':
        return Icons.person_outlined;
      case 'fitness':
        return Icons.fitness_center_outlined;
      case 'school':
        return Icons.school_outlined;
      case 'home':
        return Icons.home_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    final timeText = _formatTimeText();
    final categoryColor = category != null
        ? Color(int.parse(category!.colorHex, radix: 16))
        : colors.textMuted;

    return Row(
      children: [
        if (category != null) ...[
          Icon(
            _categoryIcon(category!.iconName),
            size: 14,
            color: categoryColor,
          ),
          const SizedBox(width: 4),
          Text(
            category!.name,
            style: AppTextStyles.bodySmall.copyWith(color: categoryColor),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              '•',
              style: AppTextStyles.bodySmall.copyWith(color: colors.textMuted),
            ),
          ),
        ],
        Text(
          timeText,
          style: AppTextStyles.monoSmall.copyWith(
            color: isOverdue ? AppColors.error : colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Small colored dot indicating task priority.
class _PriorityDot extends StatelessWidget {
  const _PriorityDot({required this.priority});

  final TaskPriority priority;

  Color get _color {
    switch (priority) {
      case TaskPriority.high:
        return AppColors.priorityHigh;
      case TaskPriority.medium:
        return AppColors.priorityMedium;
      case TaskPriority.low:
        return AppColors.priorityLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(shape: BoxShape.circle, color: _color),
    );
  }
}

/// Thin progress bar showing subtask completion.
class _SubtaskProgressBar extends StatelessWidget {
  const _SubtaskProgressBar({required this.subtasks});

  final List<SubtaskEntity> subtasks;

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    final completed = subtasks.where((s) => s.isCompleted).length;
    final total = subtasks.length;
    final progress = total > 0 ? completed / total : 0.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '$completed/$total',
              style: AppTextStyles.monoSmall.copyWith(
                color: colors.textMuted,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 3,
            backgroundColor: colors.border,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }
}
