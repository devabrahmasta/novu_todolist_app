import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/novu_colors_extension.dart';
import '../../../../core/utils/enums.dart';
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
  final _sheetController = DraggableScrollableController();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_onSheetChanged);
  }

  void _onSheetChanged() {
    if (!_sheetController.isAttached) return;
    final size = _sheetController.size;
    if (size > 0.58 && _calendarFormat == CalendarFormat.month) {
      setState(() => _calendarFormat = CalendarFormat.week);
    } else if (size < 0.48 && _calendarFormat == CalendarFormat.week) {
      setState(() => _calendarFormat = CalendarFormat.month);
    }
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetChanged);
    _sheetController.dispose();
    super.dispose();
  }

  String _formatSelectedDate(DateTime date) {
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
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    final selectedDay = ref.watch(selectedDateProvider);
    final taskAsync = ref.watch(taskListNotifierProvider);
    final categoryAsync = ref.watch(categoryListNotifierProvider);

    final allTasks = taskAsync.valueOrNull ?? [];

    // Event map for dot markers
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
      if (t.dueDate == null) return isSameDay(selectedDay, DateTime.now());
      return isSameDay(t.dueDate!, selectedDay);
    }).toList();

    // Sort: completed→bottom, then timeOfDay slot, then dueTime, then createdAt
    tasksForDate.sort((a, b) {
      final aCompleted = a.status == TaskStatus.completed;
      final bCompleted = b.status == TaskStatus.completed;
      if (aCompleted != bCompleted) return aCompleted ? 1 : -1;
      final slotCompare = a.timeOfDay.index.compareTo(b.timeOfDay.index);
      if (slotCompare != 0) return slotCompare;
      if (a.dueTime != null && b.dueTime != null) {
        final aMin = a.dueTime!.hour * 60 + a.dueTime!.minute;
        final bMin = b.dueTime!.hour * 60 + b.dueTime!.minute;
        return aMin.compareTo(bMin);
      }
      if (a.dueTime != null) return -1;
      if (b.dueTime != null) return 1;
      return a.createdAt.compareTo(b.createdAt);
    });

    final categories = categoryAsync.valueOrNull ?? [];
    final categoryMap = {for (final c in categories) c.id: c};

    return Scaffold(
      backgroundColor: colors.bg,
      body: Stack(
        children: [
          // ── BACKGROUND: AppBar + Calendar ──
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CalendarAppBar(),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: _CalendarWidget(
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
                ),
              ],
            ),
          ),

          // ── FOREGROUND: Draggable Schedule Panel ──
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.50,
            minChildSize: 0.28,
            maxChildSize: 0.92,
            snap: true,
            snapSizes: const [0.28, 0.50, 0.92],
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Drag handle
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Schedule header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Schedule',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineLarge,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formatSelectedDate(selectedDay),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: colors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => showCreateTaskSheet(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: colors.surface2,
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

                    // Task list — uses scrollController from DraggableScrollableSheet
                    Expanded(
                      child: tasksForDate.isEmpty
                          ? _EmptySchedule()
                          : ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              itemCount: tasksForDate.length,
                              itemBuilder: (context, index) {
                                final task = tasksForDate[index];
                                final category = task.categoryId != null
                                    ? categoryMap[task.categoryId!]
                                    : null;
                                return ScheduleTaskCard(
                                  task: task,
                                  category: category,
                                  onToggle: () => ref
                                      .read(taskListNotifierProvider.notifier)
                                      .completeTask(task.id),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
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
    final colors = context.novuColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: Icon(
              Icons.menu_rounded,
              color: colors.textSecondary,
              size: 24,
            ),
          ),
          const Spacer(),
          Text('Calendar', style: Theme.of(context).textTheme.headlineMedium),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none_rounded,
              color: colors.textSecondary,
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
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
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
          formatButtonVisible: false,
          formatButtonDecoration: BoxDecoration(
            border: Border.all(color: colors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          formatButtonTextStyle: AppTextStyles.bodySmall.copyWith(
            color: colors.textSecondary,
          ),
          titleTextStyle:
              textTheme.headlineMedium ?? AppTextStyles.headingMedium,
          leftChevronIcon: Icon(
            Icons.chevron_left_rounded,
            color: colors.textSecondary,
            size: 28,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right_rounded,
            color: colors.textSecondary,
            size: 28,
          ),
          headerPadding: const EdgeInsets.symmetric(vertical: 8),
        ),

        // ── Days of week style ──
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppTextStyles.bodySmall.copyWith(
            color: colors.textSecondary,
            fontSize: 12,
          ),
          weekendStyle: AppTextStyles.bodySmall.copyWith(
            color: colors.textMuted,
            fontSize: 12,
          ),
        ),

        // ── Calendar style ──
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          // Default text
          defaultTextStyle: AppTextStyles.bodyMedium.copyWith(
            color: colors.textPrimary,
          ),
          weekendTextStyle: AppTextStyles.bodyMedium.copyWith(
            color: colors.textSecondary,
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
            color: colors.textPrimary,
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

// ─── Empty schedule state ────────────────────────────────────

class _EmptySchedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_available_rounded,
              size: 44,
              color: colors.textMuted,
            ),
            const SizedBox(height: 12),
            Text(
              'No tasks for this day',
              style: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text('Enjoy your free time!', style: textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
