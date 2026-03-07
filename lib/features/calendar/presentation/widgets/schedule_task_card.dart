import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/novu_colors_extension.dart';
import '../../../../core/utils/enums.dart';
import '../../../category/domain/entities/category_entity.dart';
import '../../../task/domain/entities/task_entity.dart';

/// Schedule-specific task card matching the Novu Phase 8 mockup.
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

  String _formatTimeRange(BuildContext context) {
    if (task.dueTime == null) return '';
    final start = task.dueTime!;
    
    // As per mockup, if we only have dueTime we assume duration or just show start time
    // For MVP, we'll format the start time.
    return start.format(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    final catColor = category != null
        ? Color(int.parse(category!.colorHex, radix: 16))
        : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surface2, // Light rounded container
        borderRadius: BorderRadius.circular(20), // Mockup shows very rounded corners
      ),
      child: Row(
        children: [
          // ── Left: category squircle ──
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: catColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _resolveIcon(category?.iconName),
              color: catColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),

          // ── Center: title + time ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _isCompleted ? colors.textSecondary : colors.textPrimary,
                    decoration: _isCompleted ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (task.dueTime != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: colors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTimeRange(context),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: colors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),

          // ── Right: Square checkbox ──
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _isCompleted ? colors.textPrimary : Colors.transparent,
                borderRadius: BorderRadius.circular(6), // Square but slightly rounded corners
                border: Border.all(
                  color: _isCompleted ? colors.textPrimary : colors.border,
                  width: 1.5,
                ),
              ),
              child: _isCompleted
                  ? Icon(Icons.check_rounded, size: 16, color: colors.bg)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  IconData _resolveIcon(String? iconName) {
    if (iconName == null) return Icons.star_border_rounded;
    // Simple icon mapping matching mockup style (line art padding)
    switch (iconName) {
      case 'work':
        return Icons.work_outline_rounded;
      case 'design':
      case 'palette':
        return Icons.palette_outlined;
      case 'people':
      case 'sync':
        return Icons.people_outline_rounded;
      case 'fitness':
      case 'gym':
        return Icons.fitness_center_rounded;
      case 'reading':
      case 'book':
        return Icons.book_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}
