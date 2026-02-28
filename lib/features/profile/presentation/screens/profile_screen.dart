import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/enums.dart';
import '../../../category/domain/entities/category_entity.dart';
import '../../../category/presentation/providers/category_providers.dart';
import '../../../task/presentation/providers/task_providers.dart';
import '../providers/settings_providers.dart';

/// Profile screen — user info, stats, settings, categories, sign out.
///
/// Entirely scrollable via [SingleChildScrollView] to prevent overflow
/// on smaller devices.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('My Profile', style: AppTextStyles.headingMedium),
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
    return Center(
      child: Column(
        children: [
          // ── Gradient-bordered avatar ──
          Stack(
            children: [
              _GradientAvatar(radius: 50),
              // Camera badge
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.bg, width: 2.5),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 14,
                    color: Colors.white,
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
              Text('Alex Johnson', style: AppTextStyles.headingLarge),
              const SizedBox(width: 6),
              const Icon(Icons.verified, color: Color(0xFF4DAAFC), size: 20),
            ],
          ),
          const SizedBox(height: 8),
          // ── Level badge ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'LEVEL 5 • Task Master',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Avatar with a gradient ring border (Violet → Pink/Orange).
class _GradientAvatar extends StatelessWidget {
  const _GradientAvatar({required this.radius});
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GradientRingPainter(strokeWidth: 3),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.surface2,
          child: Icon(
            Icons.person_rounded,
            size: radius * 0.9,
            color: AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

class _GradientRingPainter extends CustomPainter {
  _GradientRingPainter({required this.strokeWidth});
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = const SweepGradient(
        colors: [
          Color(0xFFB87EED), // violet
          Color(0xFFFF6B9D), // pink
          Color(0xFFFF9A3C), // orange
          Color(0xFFB87EED), // loop back
        ],
        stops: [0, 0.35, 0.7, 1.0],
        transform: GradientRotation(-math.pi / 2),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawOval(rect.deflate(strokeWidth / 2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

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

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.check_circle_outline_rounded,
              color: const Color(0xFF4DAAFC),
              value: '$totalTasks',
              label: 'Total Tasks',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              icon: Icons.calendar_today_rounded,
              color: const Color(0xFF34D399),
              value: '$thisWeek',
              label: 'This Week',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              icon: Icons.local_fire_department_rounded,
              color: const Color(0xFFFF9A3C),
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(value, style: AppTextStyles.headingLarge.copyWith(fontSize: 24)),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
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
    final settings = ref.watch(settingsNotifierProvider);
    final themeName = settings.themeMode == ThemeMode.dark
        ? 'Dark'
        : settings.themeMode == ThemeMode.light
        ? 'Light'
        : 'System';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('General', style: AppTextStyles.headingMedium),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _SettingsTile(
                icon: Icons.notifications_none_rounded,
                iconColor: const Color(0xFFFFD166),
                title: 'Notifications',
                onTap: () {},
              ),
              Divider(color: AppColors.border, height: 1, indent: 56),
              _SettingsTile(
                icon: Icons.palette_outlined,
                iconColor: AppColors.primary,
                title: 'Theme',
                trailing: '$themeName >',
                onTap: () => _showThemePicker(context, ref),
              ),
              Divider(color: AppColors.border, height: 1, indent: 56),
              _SettingsTile(
                icon: Icons.language_rounded,
                iconColor: const Color(0xFF4DAAFC),
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
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
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
              Text('Select Theme', style: AppTextStyles.headingMedium),
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
                    color: AppColors.textSecondary,
                  ),
                  title: Text(t.$2, style: AppTextStyles.bodyLarge),
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

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: AppTextStyles.bodyLarge),
      trailing: trailing != null
          ? Text(
              trailing!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          : const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 22,
            ),
      onTap: onTap,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 5. MANAGE CATEGORIES
// ═══════════════════════════════════════════════════════════════

class _ManageCategories extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsync = ref.watch(categoryListNotifierProvider);
    final categories = categoryAsync.valueOrNull ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Text('Manage Categories', style: AppTextStyles.headingMedium),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Edit',
                style: AppTextStyles.bodySmall.copyWith(
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
            style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
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
                color: AppColors.textMuted,
                width: 1.5,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            child: const Icon(
              Icons.add_rounded,
              color: AppColors.textMuted,
              size: 26,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add',
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
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
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error),
        ),
      ),
    );
  }
}
