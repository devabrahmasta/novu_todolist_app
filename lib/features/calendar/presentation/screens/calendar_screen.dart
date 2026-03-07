import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/novu_colors_extension.dart';
import '../../../../core/utils/enums.dart';
import '../../../category/presentation/providers/category_providers.dart';
import '../../../task/presentation/providers/task_providers.dart';
import '../widgets/schedule_task_card.dart';

/// Calendar Screen matching Phase 8 mockup.
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
    
    // Switch to week view when pushing sheet up, month when pulling down
    if (size > 0.65 && _calendarFormat == CalendarFormat.month) {
      setState(() => _calendarFormat = CalendarFormat.week);
    } else if (size < 0.55 && _calendarFormat == CalendarFormat.week) {
      setState(() => _calendarFormat = CalendarFormat.month);
    }
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetChanged);
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    final selectedDay = ref.watch(selectedDateProvider);
    final taskAsync = ref.watch(taskListNotifierProvider);
    final categoryAsync = ref.watch(categoryListNotifierProvider);

    final allTasks = taskAsync.valueOrNull ?? [];

    // Filter tasks for selected date
    final tasksForDate = allTasks.where((t) {
      if (t.status == TaskStatus.archived) return false;
      if (t.dueDate == null) return isSameDay(selectedDay, DateTime.now());
      return isSameDay(t.dueDate!, selectedDay);
    }).toList();

    // Sort
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
          // ── BACKGROUND: Calendar Section ──
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // "Schedule" header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Schedule',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Calendar widget
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: _CalendarWidget(
                    focusedDay: _focusedDay,
                    selectedDay: selectedDay,
                    calendarFormat: _calendarFormat,
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
            initialChildSize: 0.48, // Initial overlap below calendar
            minChildSize: 0.40,
            maxChildSize: 0.85, // Pulls up more than half screen
            snap: true,
            snapSizes: const [0.48, 0.85],
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Drag handle
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Container(
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colors.textPrimary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Task list
                    Expanded(
                      child: tasksForDate.isEmpty
                          ? _EmptySchedule()
                          : ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.fromLTRB(24, 8, 24, 100), // padding bottom for fab clearance
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
// COLLAPSIBLE CALENDAR
// ═══════════════════════════════════════════════════════════════

class _CalendarWidget extends StatelessWidget {
  const _CalendarWidget({
    required this.focusedDay,
    required this.selectedDay,
    required this.calendarFormat,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.onPageChanged,
  });

  final DateTime focusedDay;
  final DateTime selectedDay;
  final CalendarFormat calendarFormat;
  final void Function(DateTime selected, DateTime focused) onDaySelected;
  final ValueChanged<CalendarFormat> onFormatChanged;
  final ValueChanged<DateTime> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(day, selectedDay),
        calendarFormat: calendarFormat,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
          CalendarFormat.week: 'Week',
        },
        onDaySelected: onDaySelected,
        onFormatChanged: onFormatChanged,
        onPageChanged: onPageChanged,

        // ── Header style ──
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: AppTextStyles.headingMedium.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left_rounded,
            color: colors.textSecondary,
            size: 24,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right_rounded,
            color: colors.textSecondary,
            size: 24,
          ),
          headerPadding: const EdgeInsets.symmetric(vertical: 8),
        ),

        // ── Days of week style ──
        daysOfWeekStyle: DaysOfWeekStyle(
          dowTextFormatter: (date, locale) {
            // "S", "M", "T"
            return const ['S', 'M', 'T', 'W', 'T', 'F', 'S'][date.weekday % 7];
          },
          weekdayStyle: AppTextStyles.bodyMedium.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          weekendStyle: AppTextStyles.bodyMedium.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),

        // ── Calendar style ──
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          
          defaultTextStyle: AppTextStyles.bodyMedium.copyWith(
            color: colors.textPrimary,
          ),
          weekendTextStyle: AppTextStyles.bodyMedium.copyWith(
            color: colors.textPrimary, // Non-muted in mockup
          ),
          
          // Today (black dot under text)
          todayDecoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          todayTextStyle: AppTextStyles.bodyMedium.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),

          // Selected (Solid black circle, white text, drop shadow)
          selectedDecoration: BoxDecoration(
            color: colors.textPrimary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colors.textPrimary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          selectedTextStyle: AppTextStyles.bodyMedium.copyWith(
            color: colors.bg,
            fontWeight: FontWeight.w700,
          ),
        ),

        // Use calendar layout builders to draw dots under "today/selected" if needed.
        // The mockup shows tiny dots under some active dates.
        calendarBuilders: CalendarBuilders(
          // Marker builder for dots under days
          markerBuilder: (context, date, events) {
            final isToday = isSameDay(date, DateTime.now());
            // Mockup shows dots under certain dates (e.g. today).
            if (isToday) {
              return Positioned(
                bottom: 8,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isSameDay(date, selectedDay) 
                       ? colors.bg 
                       : colors.textPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }
            return null;
          },
        ),

        rowHeight: 52,
        daysOfWeekHeight: 32,
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
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(
              Icons.event_available_rounded,
              size: 48,
              color: colors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks for this day',
              style: textTheme.bodyLarge?.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Enjoy your free time!',
              style: textTheme.bodySmall?.copyWith(
                color: colors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
