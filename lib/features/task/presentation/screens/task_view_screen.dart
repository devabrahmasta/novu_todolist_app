import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/novu_colors_extension.dart';
import '../../../category/domain/entities/category_entity.dart';
import '../../../category/presentation/providers/category_providers.dart';
import '../providers/task_providers.dart';

/// Task Insights screen showing detailed analytics and progress.
class TaskViewScreen extends ConsumerWidget {
  final String taskId;

  const TaskViewScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;

    final taskAsync = ref.watch(taskDetailFutureProvider(taskId));

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        title: Text(
          'Task Insights',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: colors.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: colors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: taskAsync.when(
        data: (task) {
          if (task == null) {
            return const Center(child: Text('Task not found'));
          }

          final categoryAsync = task.categoryId != null
              ? ref.watch(categoryDetailFutureProvider(task.categoryId))
              : const AsyncValue<CategoryEntity?>.data(null);
          final category = categoryAsync.valueOrNull;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Tags / Chips
                Row(
                  children: [
                    if (category != null)
                      _BadgeChip(
                        icon: Icons.work_outline_rounded,
                        label: category.name,
                      ),
                    if (category != null) const SizedBox(width: 8),
                    const _BadgeChip(
                      icon: Icons.wb_sunny_outlined,
                      label: 'Afternoon',
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 2. Main Stats (Streak, Time, Done)
                _buildMainStatsRow(context, task.streak),
                const SizedBox(height: 24),

                // 3. Activity Heatmap
                _buildHeatmapCard(context),
                const SizedBox(height: 24),

                // 4. Bar Chart & Trend Chart Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _buildBarChartCard(context)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTrendChartCard(context)),
                  ],
                ),
                const SizedBox(height: 24),

                // 5. Subtasks
                if (task.subtasks.isNotEmpty) ...[
                  _buildSubtasksSection(context, task.subtasks),
                  const SizedBox(height: 24),
                ],

                // 6. Tip of the day
                _buildTipCard(context),
                const SizedBox(height: 48),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildMainStatsRow(BuildContext context, int streak) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            icon: Icons.local_fire_department_rounded,
            value: '$streak',
            label: 'STREAK',
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: _StatBox(
            icon: Icons.timer_outlined,
            value: '5h 30m',
            label: 'TIME',
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: _StatBox(
            icon: Icons.pie_chart_outline_rounded,
            value: '85%',
            label: 'DONE',
          ),
        ),
      ],
    );
  }

  Widget _buildHeatmapCard(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Activity Heatmap',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Last 3 Months',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.surface2,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+12% vs last mo',
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Placeholder Heatmap Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              10,
              (colIndex) => Column(
                children: List.generate(
                  5,
                  (rowIndex) {
                    final isFilled = (colIndex + rowIndex) % 3 == 0;
                    return Container(
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: isFilled ? colors.textPrimary : colors.surface2,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('JAN', style: textTheme.labelSmall),
              Text('FEB', style: textTheme.labelSmall),
              Text('MAR', style: textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarChartCard(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Week',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          // Simple Bar Chart Mockup
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _Bar(height: 40, label: 'M', color: colors.surface2),
              _Bar(height: 70, label: 'T', color: colors.surface2),
              _Bar(height: 30, label: 'W', color: colors.surface2),
              _Bar(height: 100, label: 'T', color: colors.textPrimary),
              _Bar(height: 10, label: 'F', color: colors.surface2),
              _Bar(height: 10, label: 'S', color: colors.surface2),
              _Bar(height: 10, label: 'S', color: colors.surface2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChartCard(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trend',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          // Custom Paint placeholder for a curved line chart
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 60),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomPaint(
                painter: _TrendChartPainter(lineColor: colors.textPrimary),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'High',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          Text(
            'Consistent growth',
            style: textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtasksSection(BuildContext context, List subtasks) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    final total = subtasks.length;
    final done = subtasks.where((s) => s.isCompleted == true).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtasks',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '$done/$total',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : done / total,
              backgroundColor: colors.surface2,
              valueColor: AlwaysStoppedAnimation<Color>(colors.textPrimary),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 16),
          // List of Subtasks
          ...subtasks.map((st) {
            final isCompleted = st.isCompleted == true;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(
                    isCompleted
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: isCompleted ? colors.textPrimary : colors.textMuted,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      st.title,
                      style: textTheme.bodyMedium?.copyWith(
                        color: isCompleted
                            ? colors.textSecondary
                            : colors.textPrimary,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTipCard(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.textPrimary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.bg.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lightbulb_outline, color: colors.bg),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tip of the day',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.bg,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You are most productive between 2 PM and 4 PM. Try scheduling complex tasks then!',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.bg.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BadgeChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colors.textPrimary),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatBox({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: colors.textSecondary),
          const SizedBox(height: 12),
          Text(
            value,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final String label;
  final Color color;

  const _Bar({required this.height, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 14,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  final Color lineColor;

  _TrendChartPainter({required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.3, // Control point
      size.width * 0.5,
      size.height * 0.6, // End point
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.9,
      size.width,
      size.height * 0.1,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
