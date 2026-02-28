import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/enums.dart';
import '../../../category/domain/entities/category_entity.dart';
import '../../../category/presentation/providers/category_providers.dart';
import '../../../task/domain/entities/task_entity.dart';
import '../../../task/presentation/providers/task_providers.dart';
import '../../../task/presentation/widgets/create_task_bottom_sheet.dart';
import '../widgets/schedule_task_card.dart';

/// Calendar Screen — month/week collapsible calendar + schedule panel.
///
/// Uses [TableCalendar] for native month↔week toggling and
/// [selectedDateProvider] for cross-screen date sync.
class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final selectedDay = ref.watch(selectedDateProvider);
    final taskAsync = ref.watch(taskListNotifierProvider);
    final categoryAsync = ref.watch(categoryListNotifierProvider);

    // Build event map for dot markers
    final allTasks = taskAsync.valueOrNull ?? [];
    final eventMap = <DateTime, List<TaskEntity>>{};
    for (final task in allTasks) {
      if (task.dueDate != null && task.status != TaskStatus.archived) {
        final key = DateTime(
          task.dueDate!.year,
          task.dueDate!.month,
          task.dueDate!.day,
        );
        eventMap.putIfAbsent(key, () => []).add(task);
      }
    }

    // Filter tasks for selected date
    final tasksForDate = allTasks.where((t) {
      if (t.status == TaskStatus.archived) return false;
      if (t.dueDate == null) {
        // Show tasks with no due date on today only
        return isSameDay(selectedDay, DateTime.now());
      }
      return isSameDay(t.dueDate!, selectedDay);
    }).toList();

    // Sort: pending first
    tasksForDate.sort((a, b) {
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

    // Category lookup
    final categories = categoryAsync.valueOrNull ?? [];
    final categoryMap = {for (final c in categories) c.id: c};

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ──
            _CalendarAppBar(),

            // ── Calendar ──
            _CalendarWidget(
              focusedDay: _focusedDay,
              selectedDay: selectedDay,
              calendarFormat: _calendarFormat,
              eventMap: eventMap,
              onDaySelected: (selected, focused) {
                ref.read(selectedDateProvider.notifier).setDate(selected);
                setState(() => _focusedDay = focused);
              },
              onFormatChanged: (format) {
                setState(() => _calendarFormat = format);
              },
              onPageChanged: (focused) {
                setState(() => _focusedDay = focused);
              },
            ),

            // ── Schedule Panel ──
            Expanded(
              child: _SchedulePanel(
                selectedDay: selectedDay,
                tasks: tasksForDate,
                categoryMap: categoryMap,
                onToggle: (taskId) {
                  ref
                      .read(taskListNotifierProvider.notifier)
                      .completeTask(taskId);
                },
                onAddTask: () => showCreateTaskSheet(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// APP BAR
// ═══════════════════════════════════════════════════════════════

class _CalendarAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.menu_rounded,
              color: AppColors.textSecondary,
              size: 24,
            ),
          ),
          const Spacer(),
          Text('Calendar', style: AppTextStyles.headingMedium),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textSecondary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// COLLAPSIBLE CALENDAR
// ═══════════════════════════════════════════════════════════════

class _CalendarWidget extends StatelessWidget {
  const _CalendarWidget({
    required this.focusedDay,
    required this.selectedDay,
    required this.calendarFormat,
    required this.eventMap,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.onPageChanged,
  });

  final DateTime focusedDay;
  final DateTime selectedDay;
  final CalendarFormat calendarFormat;
  final Map<DateTime, List<TaskEntity>> eventMap;
  final void Function(DateTime selected, DateTime focused) onDaySelected;
  final ValueChanged<CalendarFormat> onFormatChanged;
  final ValueChanged<DateTime> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TableCalendar<TaskEntity>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(day, selectedDay),
        calendarFormat: calendarFormat,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        availableCalendarFormats: const {
          CalendarFormat.month: 'Week',
          CalendarFormat.week: 'Month',
        },
        eventLoader: (day) {
          final key = DateTime(day.year, day.month, day.day);
          return eventMap[key] ?? [];
        },
        onDaySelected: onDaySelected,
        onFormatChanged: onFormatChanged,
        onPageChanged: onPageChanged,

        // ── Header style ──
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: true,
          formatButtonDecoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          formatButtonTextStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
          titleTextStyle: AppTextStyles.headingMedium,
          leftChevronIcon: const Icon(
            Icons.chevron_left_rounded,
            color: AppColors.textSecondary,
            size: 28,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
            size: 28,
          ),
          headerPadding: const EdgeInsets.symmetric(vertical: 8),
        ),

        // ── Days of week style ──
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
          weekendStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textMuted,
            fontSize: 12,
          ),
        ),

        // ── Calendar style ──
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          // Default text
          defaultTextStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          weekendTextStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          // Today
          todayDecoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 1.5),
          ),
          todayTextStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
          // Selected
          selectedDecoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          // Markers (event dots)
          markersMaxCount: 1,
          markerDecoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          markerSize: 5,
          markerMargin: const EdgeInsets.only(top: 1),
        ),

        // ── Row height ──
        rowHeight: 46,
        daysOfWeekHeight: 28,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCHEDULE PANEL
// ═══════════════════════════════════════════════════════════════

class _SchedulePanel extends StatelessWidget {
  const _SchedulePanel({
    required this.selectedDay,
    required this.tasks,
    required this.categoryMap,
    required this.onToggle,
    required this.onAddTask,
  });

  final DateTime selectedDay;
  final List<TaskEntity> tasks;
  final Map<String, CategoryEntity> categoryMap;
  final ValueChanged<String> onToggle;
  final VoidCallback onAddTask;

  String _formatSelectedDate() {
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
    return '${weekdays[selectedDay.weekday - 1]}, '
        '${months[selectedDay.month - 1]} ${selectedDay.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          // ── Drag handle ──
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // ── Header row ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Schedule', style: AppTextStyles.headingLarge),
                      const SizedBox(height: 2),
                      Text(
                        _formatSelectedDate(),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onAddTask,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.surface2,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Task list ──
          Expanded(
            child: tasks.isEmpty
                ? _EmptySchedule()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final category = task.categoryId != null
                          ? categoryMap[task.categoryId!]
                          : null;

                      return ScheduleTaskCard(
                        task: task,
                        category: category,
                        onToggle: () => onToggle(task.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty schedule state ────────────────────────────────────

class _EmptySchedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.event_available_rounded,
              size: 44,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 12),
            Text(
              'No tasks for this day',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text('Enjoy your free time!', style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}
