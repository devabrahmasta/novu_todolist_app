import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/novu_colors_extension.dart';
import '../../../../core/utils/enums.dart';
import '../../../category/domain/entities/category_entity.dart';
import '../../../task/domain/entities/task_entity.dart';

/// Schedule-specific task card for the Calendar view.
///
/// - Left: category squircle icon
/// - Center: title + time
/// - Right: rounded checkbox
class ScheduleTaskCard extends StatelessWidget {
  const ScheduleTaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    this.category,
  });

  final TaskEntity task;
  final VoidCallback onToggle;
  final CategoryEntity? category;

  bool get _isCompleted => task.status == TaskStatus.completed;

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    final catColor = category != null
        ? Color(int.parse(category!.colorHex, radix: 16))
        : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // ── Left: category squircle ──
          _CategorySquircle(color: catColor, iconName: category?.iconName),
          const SizedBox(width: 14),

          // ── Center: title + time ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: _isCompleted
                      ? textTheme.bodyLarge?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: colors.textSecondary,
                          decorationColor: colors.textSecondary,
                        )
                      : textTheme.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (task.dueTime != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 13,
                        color: colors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task.dueTime!.format(context),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: colors.textSecondary,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),

          // ── Right: rounded checkbox ──
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: _isCompleted ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: _isCompleted ? AppColors.primary : colors.textMuted,
                  width: 2,
                ),
              ),
              child: _isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Category squircle icon ──────────────────────────────────

class _CategorySquircle extends StatelessWidget {
  const _CategorySquircle({required this.color, this.iconName});

  final Color color;
  final String? iconName;

  IconData _resolveIcon() {
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
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(_resolveIcon(), color: color, size: 22),
    );
  }
}
