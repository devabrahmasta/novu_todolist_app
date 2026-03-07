import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/habit/presentation/widgets/create_habit_bottom_sheet.dart';
import '../../features/task/presentation/widgets/create_task_bottom_sheet.dart';
import '../theme/app_text_styles.dart';
import '../theme/novu_colors_extension.dart';

/// Persistent shell that wraps the main tabs with a shared BottomNavBar + center FAB.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      floatingActionButton: _buildFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _BottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    final colors = context.novuColors;
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.textPrimary,
        boxShadow: [
          BoxShadow(
            color: colors.textPrimary.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          _showCreateOptions(context);
        },
        elevation: 0,
        backgroundColor: Colors.transparent,
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: colors.bg, size: 28),
      ),
    );
  }

  void _showCreateOptions(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.check_circle_outline_rounded,
                  color: colors.textPrimary,
                ),
                title: Text('New Task', style: textTheme.bodyLarge),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  showCreateTaskSheet(context);
                },
              ),
              const SizedBox(height: 4),
              ListTile(
                leading: Icon(
                  Icons.loop_rounded,
                  color: colors.textPrimary,
                ),
                title: Text('New Habit', style: textTheme.bodyLarge),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  showCreateHabitSheet(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    // 4 tabs: Tasks, Calendar, Journal, Profile
    // The FAB occupies the center between Calendar (index 1) and Journal (index 2)
    final items = [
      (Icons.check_circle_outline_rounded, Icons.check_circle_rounded, 'Tasks'),
      (Icons.calendar_today_outlined, Icons.calendar_today_rounded, 'Calendar'),
      (Icons.auto_stories_outlined, Icons.auto_stories_rounded, 'Journal'),
      (Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.bgElevated,
        border: Border(top: BorderSide(color: colors.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < items.length; i++) ...[
                if (i == 2) const SizedBox(width: 56), // FAB space
                GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 56,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          currentIndex == i ? items[i].$2 : items[i].$1,
                          color: currentIndex == i
                              ? colors.textPrimary
                              : colors.textMuted,
                          size: 22,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          items[i].$3,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 10,
                            color: currentIndex == i
                                ? colors.textPrimary
                                : colors.textMuted,
                            fontWeight: currentIndex == i
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
