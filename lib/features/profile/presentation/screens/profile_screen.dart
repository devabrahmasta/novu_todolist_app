import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novu_todolist_app/features/profile/presentation/widgets/settings_tiles.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/novu_colors_extension.dart';
import '../../../../core/utils/enums.dart';
import '../../../category/domain/entities/category_entity.dart';
import '../../../category/presentation/providers/category_providers.dart';
import '../../../task/presentation/providers/task_providers.dart';
import '../providers/settings_providers.dart';

/// Profile screen — user info, stats, settings, categories, sign out.
///
/// Entirely scrollable via [SingleChildScrollView] to prevent overflow
/// on smaller devices.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('My Profile', style: textTheme.headlineMedium),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.edit_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // ── 2. Avatar & User Info ──
            const _AvatarSection(),
            const SizedBox(height: 28),
            // ── 3. Stats Grid ──
            _StatsGrid(),
            const SizedBox(height: 28),
            // ── 4. General Settings ──
            _GeneralSettings(),
            const SizedBox(height: 28),
            // ── 5. Manage Categories ──
            _ManageCategories(),
            const SizedBox(height: 32),
            // ── 6. Sign Out ──
            const _SignOutButton(),
            const SizedBox(height: 100), // bottom nav overlap
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 2. AVATAR & USER INFO
// ═══════════════════════════════════════════════════════════════

class _AvatarSection extends StatelessWidget {
  const _AvatarSection();

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        children: [
          // ── Monochrome bordered avatar ──
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.textPrimary, width: 2),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: colors.surface2,
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 45,
                    color: colors.textSecondary,
                  ),
                ),
              ),
              // Camera badge
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: colors.textPrimary,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.bg, width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 14,
                    color: colors.bg,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // ── Name + verified ──
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Alex Johnson',
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.verified_rounded, color: colors.textPrimary, size: 20),
            ],
          ),
          // Note: Level badge removed as per out-of-scope rules
        ],
      ),
    );
  }
}


// Removed _GradientAvatar and _GradientRingPainter as per monochrome rules

// ═══════════════════════════════════════════════════════════════
// 3. STATS GRID
// ═══════════════════════════════════════════════════════════════

class _StatsGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(taskListNotifierProvider);
    final tasks = taskAsync.valueOrNull ?? [];

    final totalTasks = tasks
        .where((t) => t.status != TaskStatus.archived)
        .length;

    // This week count
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDay = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day,
    );
    final thisWeek = tasks.where((t) {
      if (t.status == TaskStatus.archived) return false;
      if (t.completedAt == null) return false;
      return t.completedAt!.isAfter(weekStartDay);
    }).length;

    // Best streak from all tasks
    final bestStreak = tasks.fold<int>(
      0,
      (max, t) => t.streak > max ? t.streak : max,
    );

    final colors = context.novuColors;
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.check_circle_outline_rounded,
              color: colors.textPrimary,
              value: '$totalTasks',
              label: 'Total Tasks',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.calendar_today_rounded,
              color: colors.textPrimary,
              value: '$thisWeek',
              label: 'This Week',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.local_fire_department_outlined,
              color: colors.textPrimary,
              value: '$bestStreak',
              label: 'Day Streak',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.surface2,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 4. GENERAL SETTINGS
// ═══════════════════════════════════════════════════════════════

class _GeneralSettings extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    final settings = ref.watch(settingsNotifierProvider);
    final themeName = settings.themeMode == ThemeMode.dark
        ? 'Dark'
        : settings.themeMode == ThemeMode.light
        ? 'Light'
        : 'System';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('General', style: textTheme.headlineMedium),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              SettingsTile(
                icon: Icons.notifications_none_rounded,
                iconColor: colors.textPrimary,
                title: 'Notifications',
                onTap: () {},
              ),
              Divider(color: colors.border, height: 1, indent: 56),
              SettingsTile(
                icon: Icons.palette_outlined,
                iconColor: colors.textPrimary,
                title: 'Theme',
                trailing: '$themeName >',
                onTap: () => _showThemePicker(context, ref),
              ),
              Divider(color: colors.border, height: 1, indent: 56),
              SettingsTile(
                icon: Icons.language_rounded,
                iconColor: colors.textPrimary,
                title: 'Language',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final current = ref.read(settingsNotifierProvider).themeMode;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text('Select Theme', style: textTheme.headlineMedium),
              const SizedBox(height: 8),
              ...[
                (ThemeMode.system, 'System'),
                (ThemeMode.dark, 'Dark'),
                (ThemeMode.light, 'Light'),
              ].map((t) {
                return ListTile(
                  leading: Icon(
                    t.$1 == ThemeMode.dark
                        ? Icons.dark_mode_rounded
                        : t.$1 == ThemeMode.light
                        ? Icons.light_mode_rounded
                        : Icons.brightness_auto_rounded,
                    color: colors.textSecondary,
                  ),
                  title: Text(t.$2, style: textTheme.bodyLarge),
                  trailing: current == t.$1
                      ? const Icon(
                          Icons.check,
                          color: AppColors.primary,
                          size: 20,
                        )
                      : null,
                  onTap: () {
                    ref
                        .read(settingsNotifierProvider.notifier)
                        .setThemeMode(t.$1);
                    Navigator.of(ctx).pop();
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}



// ═══════════════════════════════════════════════════════════════
// 5. MANAGE CATEGORIES
// ═══════════════════════════════════════════════════════════════

class _ManageCategories extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final categoryAsync = ref.watch(categoryListNotifierProvider);
    final categories = categoryAsync.valueOrNull ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Text('Manage Categories', style: textTheme.headlineMedium),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Edit',
                style: (textTheme.bodySmall ?? AppTextStyles.bodySmall)
                    .copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Horizontal category row
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length + 1,
            separatorBuilder: (context, i) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              if (index == categories.length) {
                return _AddCategoryItem();
              }
              return _CategoryItem(category: categories[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.category});
  final CategoryEntity category;

  IconData _resolveIcon() {
    switch (category.iconName) {
      case 'work':
        return Icons.work_rounded;
      case 'person':
        return Icons.person_rounded;
      case 'fitness':
        return Icons.fitness_center_rounded;
      case 'school':
        return Icons.school_rounded;
      case 'home':
        return Icons.home_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(category.colorHex, radix: 16));

    return SizedBox(
      width: 72,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(_resolveIcon(), color: Colors.white, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style:
                (Theme.of(context).textTheme.bodySmall ??
                        AppTextStyles.bodySmall)
                    .copyWith(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AddCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    return SizedBox(
      width: 72,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: colors.textMuted,
                width: 1.5,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            child: Icon(Icons.add_rounded, color: colors.textMuted, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            'Add',
            style:
                (Theme.of(context).textTheme.bodySmall ??
                        AppTextStyles.bodySmall)
                    .copyWith(fontSize: 12, color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 6. SIGN OUT
// ═══════════════════════════════════════════════════════════════

class _SignOutButton extends StatelessWidget {
  const _SignOutButton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Sign Out',
          style:
              (Theme.of(context).textTheme.bodyLarge ?? AppTextStyles.bodyLarge)
                  .copyWith(color: AppColors.error),
        ),
      ),
    );
  }
}
