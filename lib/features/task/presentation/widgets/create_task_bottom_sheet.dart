import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/enums.dart';
import '../../../category/presentation/providers/category_providers.dart';
import '../../domain/entities/task_entity.dart';
import '../providers/task_providers.dart';

const _uuid = Uuid();

/// Shows the Create Task bottom sheet.
///
/// Call from anywhere:
/// ```dart
/// showCreateTaskSheet(context);
/// ```
void showCreateTaskSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const CreateTaskBottomSheet(),
  );
}

/// Full-height bottom sheet for creating a new task.
///
/// Uses [ConsumerStatefulWidget] for local form state, submitting
/// via [taskListNotifierProvider] on "Create Task".
class CreateTaskBottomSheet extends ConsumerStatefulWidget {
  const CreateTaskBottomSheet({super.key});

  @override
  ConsumerState<CreateTaskBottomSheet> createState() =>
      _CreateTaskBottomSheetState();
}

class _CreateTaskBottomSheetState extends ConsumerState<CreateTaskBottomSheet> {
  // ─── Form state ───────────────────────────────────────
  final _titleController = TextEditingController();
  final _titleFocus = FocusNode();

  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  TaskPriority? _priority;
  String? _categoryId;

  // Subtasks
  final List<TextEditingController> _subtaskControllers = [];
  final List<FocusNode> _subtaskFocusNodes = [];

  // Repeat
  bool _repeatEnabled = false;
  RepeatType _repeatType = RepeatType.daily;
  final _intervalController = TextEditingController(text: '1');
  final Set<int> _selectedDays = {}; // 0=Mon … 6=Sun

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _titleFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocus.dispose();
    _intervalController.dispose();
    for (final c in _subtaskControllers) {
      c.dispose();
    }
    for (final f in _subtaskFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  TimeOfDaySlot _inferTimeOfDay() {
    if (_dueTime != null) {
      final h = _dueTime!.hour;
      if (h < 12) return TimeOfDaySlot.morning;
      if (h < 17) return TimeOfDaySlot.afternoon;
      return TimeOfDaySlot.evening;
    }
    final h = DateTime.now().hour;
    if (h < 12) return TimeOfDaySlot.morning;
    if (h < 17) return TimeOfDaySlot.afternoon;
    return TimeOfDaySlot.evening;
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final now = DateTime.now();
    final taskId = _uuid.v4();

    // Build subtask list
    final subtasks = <SubtaskEntity>[];
    for (var i = 0; i < _subtaskControllers.length; i++) {
      final text = _subtaskControllers[i].text.trim();
      if (text.isNotEmpty) {
        subtasks.add(
          SubtaskEntity(id: _uuid.v4(), taskId: taskId, title: text, order: i),
        );
      }
    }

    // Build repeat config
    RepeatConfig? repeat;
    if (_repeatEnabled && _repeatType != RepeatType.none) {
      repeat = RepeatConfig(
        type: _repeatType,
        customDays: _repeatType == RepeatType.weekly
            ? _selectedDays.toList()
            : null,
      );
    }

    final task = TaskEntity(
      id: taskId,
      title: title,
      categoryId: _categoryId,
      timeOfDay: _inferTimeOfDay(),
      dueDate: _dueDate,
      dueTime: _dueTime,
      priority: _priority,
      status: TaskStatus.pending,
      subtasks: subtasks,
      repeat: repeat,
      createdAt: now,
      updatedAt: now,
    );

    ref.read(taskListNotifierProvider.notifier).createTask(task);
    Navigator.of(context).pop();
  }

  // ─── Build ────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Scrollable content
          Expanded(
            child: CustomScrollView(
              slivers: [
                // ── 1. Header ──
                SliverToBoxAdapter(child: _buildHeader()),
                // ── 2. Title input ──
                SliverToBoxAdapter(child: _buildTitleInput()),
                // ── 3. Quick settings ──
                SliverToBoxAdapter(child: _buildQuickSettings()),
                // ── 4. Subtasks ──
                SliverToBoxAdapter(child: _buildSubtasksSection()),
                // ── 5. Repeat ──
                SliverToBoxAdapter(child: _buildRepeatSection()),
                // bottom spacer
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
              ],
            ),
          ),
          // ── 6. Bottom bar (sticky above keyboard) ──
          _buildBottomBar(bottomInset),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════
  // 1. HEADER
  // ═════════════════════════════════════════════════════════

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 12),
        // Drag handle
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text('New Task', style: AppTextStyles.headingLarge),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═════════════════════════════════════════════════════════
  // 2. TITLE INPUT
  // ═════════════════════════════════════════════════════════

  Widget _buildTitleInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: TextFormField(
        controller: _titleController,
        focusNode: _titleFocus,
        style: AppTextStyles.headingMedium,
        decoration: InputDecoration(
          hintText: 'What needs to be done?',
          hintStyle: AppTextStyles.headingMedium.copyWith(
            color: AppColors.textMuted,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          contentPadding: EdgeInsets.zero,
        ),
        textCapitalization: TextCapitalization.sentences,
        maxLines: null,
      ),
    );
  }

  // ═════════════════════════════════════════════════════════
  // 3. QUICK SETTINGS ROW
  // ═════════════════════════════════════════════════════════

  Widget _buildQuickSettings() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          // Date chip
          _QuickChip(
            icon: Icons.calendar_today_rounded,
            label: _dueDate != null ? _formatDate(_dueDate!) : 'Today',
            isActive: _dueDate != null,
            onTap: () => _pickDate(),
          ),
          // Time chip
          _QuickChip(
            icon: Icons.access_time_rounded,
            label: _dueTime != null ? _dueTime!.format(context) : 'Set time',
            isActive: _dueTime != null,
            onTap: () => _pickTime(),
          ),
          // Priority chip
          _QuickChip(
            icon: Icons.flag_rounded,
            label: _priority != null
                ? _priority!.name[0].toUpperCase() +
                      _priority!.name.substring(1)
                : 'Priority',
            isActive: _priority != null,
            activeColor: _priorityColor(_priority),
            onTap: () => _cyclePriority(),
          ),
          // Category chip
          _CategoryChip(categoryId: _categoryId, onTap: () => _pickCategory()),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(d.year, d.month, d.day);
    final diff = date.difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    return '${d.day}/${d.month}';
  }

  Color? _priorityColor(TaskPriority? p) {
    if (p == null) return null;
    switch (p) {
      case TaskPriority.high:
        return AppColors.priorityHigh;
      case TaskPriority.medium:
        return AppColors.priorityMedium;
      case TaskPriority.low:
        return AppColors.priorityLow;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.surface,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.surface,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueTime = picked);
  }

  void _cyclePriority() {
    setState(() {
      if (_priority == null) {
        _priority = TaskPriority.low;
      } else if (_priority == TaskPriority.low) {
        _priority = TaskPriority.medium;
      } else if (_priority == TaskPriority.medium) {
        _priority = TaskPriority.high;
      } else {
        _priority = null;
      }
    });
  }

  void _pickCategory() {
    final categories = ref.read(categoryListNotifierProvider).valueOrNull ?? [];
    if (categories.isEmpty) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text('Select Category', style: AppTextStyles.headingMedium),
              const SizedBox(height: 12),
              ...categories.map((cat) {
                final catColor = Color(int.parse(cat.colorHex, radix: 16));
                return ListTile(
                  leading: Icon(Icons.circle, color: catColor, size: 14),
                  title: Text(cat.name, style: AppTextStyles.bodyLarge),
                  trailing: _categoryId == cat.id
                      ? const Icon(
                          Icons.check,
                          color: AppColors.primary,
                          size: 20,
                        )
                      : null,
                  onTap: () {
                    setState(() => _categoryId = cat.id);
                    Navigator.of(ctx).pop();
                  },
                );
              }),
              // Clear option
              ListTile(
                leading: const Icon(
                  Icons.close,
                  color: AppColors.textMuted,
                  size: 14,
                ),
                title: Text(
                  'No category',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                onTap: () {
                  setState(() => _categoryId = null);
                  Navigator.of(ctx).pop();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // ═════════════════════════════════════════════════════════
  // 4. SUBTASKS SECTION
  // ═════════════════════════════════════════════════════════

  Widget _buildSubtasksSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              const Icon(
                Icons.checklist_rounded,
                color: AppColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'SUBTASKS',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Subtask items
          ...List.generate(_subtaskControllers.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.textMuted,
                        width: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _subtaskControllers[i],
                      focusNode: _subtaskFocusNodes[i],
                      style: AppTextStyles.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Subtask ${i + 1}',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textMuted,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      onSubmitted: (_) => _addSubtask(),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _removeSubtask(i),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textMuted,
                      size: 16,
                    ),
                  ),
                ],
              ),
            );
          }),
          // Add subtask button
          GestureDetector(
            onTap: _addSubtask,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.add_rounded,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Add a subtask...',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Divider(color: AppColors.border, height: 1),
        ],
      ),
    );
  }

  void _addSubtask() {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    setState(() {
      _subtaskControllers.add(controller);
      _subtaskFocusNodes.add(focusNode);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  void _removeSubtask(int index) {
    setState(() {
      _subtaskControllers[index].dispose();
      _subtaskFocusNodes[index].dispose();
      _subtaskControllers.removeAt(index);
      _subtaskFocusNodes.removeAt(index);
    });
  }

  // ═════════════════════════════════════════════════════════
  // 5. REPEAT SECTION
  // ═════════════════════════════════════════════════════════

  Widget _buildRepeatSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with switch
          Row(
            children: [
              const Icon(
                Icons.repeat_rounded,
                color: AppColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'REPEAT',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 28,
                child: Switch(
                  value: _repeatEnabled,
                  onChanged: (v) => setState(() => _repeatEnabled = v),
                  activeThumbColor: AppColors.primary,
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
                  inactiveThumbColor: AppColors.textMuted,
                  inactiveTrackColor: AppColors.surface2,
                ),
              ),
            ],
          ),
          // Expanded repeat config
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _repeatEnabled
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: _buildRepeatConfig(),
          ),
        ],
      ),
    );
  }

  Widget _buildRepeatConfig() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Segmented control: Daily / Weekly / Monthly ──
          _RepeatTabs(
            selected: _repeatType,
            onChanged: (t) => setState(() => _repeatType = t),
          ),
          const SizedBox(height: 16),
          // ── Interval row ──
          Row(
            children: [
              Text('Every', style: AppTextStyles.bodyMedium),
              const SizedBox(width: 8),
              SizedBox(
                width: 48,
                height: 36,
                child: TextField(
                  controller: _intervalController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(_repeatUnitLabel(), style: AppTextStyles.bodyMedium),
            ],
          ),
          // ── Day selector (weekly only) ──
          if (_repeatType == RepeatType.weekly) ...[
            const SizedBox(height: 16),
            _DaySelector(
              selectedDays: _selectedDays,
              onToggle: (day) {
                setState(() {
                  if (_selectedDays.contains(day)) {
                    _selectedDays.remove(day);
                  } else {
                    _selectedDays.add(day);
                  }
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  String _repeatUnitLabel() {
    switch (_repeatType) {
      case RepeatType.daily:
        return 'days';
      case RepeatType.weekly:
        return 'weeks';
      case RepeatType.monthly:
        return 'months';
      default:
        return 'days';
    }
  }

  // ═════════════════════════════════════════════════════════
  // 6. BOTTOM ACTION BAR
  // ═════════════════════════════════════════════════════════

  Widget _buildBottomBar(double bottomInset) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.bgElevated,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Attachment button
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.attach_file_rounded,
                color: AppColors.textSecondary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            // Create button
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Create Task',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SHARED SUB-WIDGETS
// ═══════════════════════════════════════════════════════════════

/// Quick action chip used in the settings row.
class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.activeColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? (activeColor ?? AppColors.primary)
        : AppColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? (activeColor ?? AppColors.primary).withValues(alpha: 0.12)
              : AppColors.surface2,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: color.withValues(alpha: 0.3), width: 1)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Category chip with dotted border when empty.
class _CategoryChip extends ConsumerWidget {
  const _CategoryChip({required this.categoryId, required this.onTap});

  final String? categoryId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories =
        ref.watch(categoryListNotifierProvider).valueOrNull ?? [];
    final category = categoryId != null
        ? categories.where((c) => c.id == categoryId).firstOrNull
        : null;

    final hasCategory = category != null;
    final catColor = hasCategory
        ? Color(int.parse(category.colorHex, radix: 16))
        : AppColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: hasCategory
              ? catColor.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasCategory
                ? catColor.withValues(alpha: 0.3)
                : AppColors.border,
            width: 1,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_outlined,
              size: 16,
              color: hasCategory ? catColor : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              hasCategory ? category.name : 'Category',
              style: AppTextStyles.bodySmall.copyWith(
                color: hasCategory ? catColor : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Segmented tabs for Daily / Weekly / Monthly.
class _RepeatTabs extends StatelessWidget {
  const _RepeatTabs({required this.selected, required this.onChanged});

  final RepeatType selected;
  final ValueChanged<RepeatType> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (RepeatType.daily, 'Daily'),
      (RepeatType.weekly, 'Weekly'),
      (RepeatType.monthly, 'Monthly'),
    ];

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: tabs.map((tab) {
          final isActive = selected == tab.$1;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(tab.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    tab.$2,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isActive
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Row of 7 day-of-week toggle circles.
class _DaySelector extends StatelessWidget {
  const _DaySelector({required this.selectedDays, required this.onToggle});

  final Set<int> selectedDays;
  final ValueChanged<int> onToggle;

  static const _labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final isActive = selectedDays.contains(i);
        return GestureDetector(
          onTap: () => onToggle(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.primary : AppColors.surface,
            ),
            child: Center(
              child: Text(
                _labels[i],
                style: AppTextStyles.bodySmall.copyWith(
                  color: isActive
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
