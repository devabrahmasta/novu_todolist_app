import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/novu_colors_extension.dart';
import '../../../../core/utils/enums.dart';
import '../../../category/presentation/providers/category_providers.dart';
import '../../domain/entities/task_entity.dart';
import '../providers/task_providers.dart';

const _uuid = Uuid();

/// Shows the redesigned Create Task bottom sheet matching the Novu mockup.
void showCreateTaskSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const CreateTaskBottomSheet(),
  );
}

class CreateTaskBottomSheet extends ConsumerStatefulWidget {
  const CreateTaskBottomSheet({super.key});

  @override
  ConsumerState<CreateTaskBottomSheet> createState() =>
      _CreateTaskBottomSheetState();
}

class _CreateTaskBottomSheetState extends ConsumerState<CreateTaskBottomSheet> {
  final _titleController = TextEditingController();
  final _titleFocus = FocusNode();

  // Date selection: 0=Today, 1=Tomorrow, 2=Pick
  int _dateOption = 0;
  DateTime? _pickedDate;
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
  final Set<int> _selectedDays = {};

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

  DateTime _resolvedDate() {
    final now = DateTime.now();
    switch (_dateOption) {
      case 1:
        return now.add(const Duration(days: 1));
      case 2:
        return _pickedDate ?? now;
      default:
        return now;
    }
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

    final subtasks = <SubtaskEntity>[];
    for (var i = 0; i < _subtaskControllers.length; i++) {
      final text = _subtaskControllers[i].text.trim();
      if (text.isNotEmpty) {
        subtasks.add(
          SubtaskEntity(id: _uuid.v4(), taskId: taskId, title: text, order: i),
        );
      }
    }

    RepeatConfig? repeat;
    if (_repeatEnabled && _repeatType != RepeatType.none) {
      repeat = RepeatConfig(
        type: _repeatType,
        customDays:
            _repeatType == RepeatType.weekly ? _selectedDays.toList() : null,
      );
    }

    final task = TaskEntity(
      id: taskId,
      title: title,
      categoryId: _categoryId,
      timeOfDay: _inferTimeOfDay(),
      dueDate: _resolvedDate(),
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
    final colors = context.novuColors;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(context)),
                SliverToBoxAdapter(child: _buildDateToggle(context)),
                SliverToBoxAdapter(child: _buildNameSection(context)),
                SliverToBoxAdapter(child: _buildSubtasksSection(context)),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
          _buildBottomBar(context, bottomInset),
        ],
      ),
    );
  }

  // ═══ Header ════════════════════════════════════════════
  Widget _buildHeader(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: colors.border,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'New Task',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ═══ Date Toggle (Today / Tomorrow / Pick) ═════════════
  Widget _buildDateToggle(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    final options = ['Today', 'Tomorrow', 'Pick'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: colors.surface2,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(options.length, (i) {
              final isSelected = _dateOption == i;
              return GestureDetector(
                onTap: () async {
                  if (i == 2) {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _pickedDate ?? DateTime.now(),
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 365)),
                      lastDate:
                          DateTime.now().add(const Duration(days: 365 * 3)),
                    );
                    if (picked != null) {
                      setState(() {
                        _pickedDate = picked;
                        _dateOption = 2;
                      });
                    }
                  } else {
                    setState(() => _dateOption = i);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.surface : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    options[i],
                    style: textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? colors.textPrimary
                          : colors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // ═══ NAME Section ══════════════════════════════════════
  Widget _buildNameSection(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NAME',
            style: textTheme.labelSmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: _titleController,
            focusNode: _titleFocus,
            style: textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: "What's yours habit?",
              hintStyle: textTheme.bodyLarge?.copyWith(
                color: colors.textMuted,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }

  // ═══ SUBTASKS Section ══════════════════════════════════
  Widget _buildSubtasksSection(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SUBTASKS',
            style: textTheme.labelSmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          // Existing subtasks
          ...List.generate(_subtaskControllers.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  // Drag handle
                  Icon(
                    Icons.drag_indicator_rounded,
                    color: colors.textMuted,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _subtaskControllers[i],
                      focusNode: _subtaskFocusNodes[i],
                      style: textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Subtask ${i + 1}',
                        hintStyle: textTheme.bodyMedium?.copyWith(
                          color: colors.textMuted,
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
                    child: Icon(
                      Icons.close_rounded,
                      color: colors.textMuted,
                      size: 18,
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
                  Icon(
                    Icons.add_rounded,
                    color: colors.textMuted,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Add a subtask...',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
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

  // ═══ Bottom Bar ════════════════════════════════════════
  Widget _buildBottomBar(BuildContext context, double bottomInset) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottomInset),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quick action chips
            Row(
              children: [
                _BottomChip(
                  icon: Icons.access_time_rounded,
                  label: 'Reminder',
                  onTap: () => _pickTime(),
                ),
                const SizedBox(width: 8),
                _BottomChip(
                  icon: Icons.flag_outlined,
                  label: _priority != null
                      ? _priority!.name[0].toUpperCase() +
                          _priority!.name.substring(1)
                      : 'Priority',
                  onTap: _cyclePriority,
                ),
                const SizedBox(width: 8),
                _BottomChip(
                  icon: Icons.bookmark_border_rounded,
                  label: 'Tags',
                  onTap: _pickCategory,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Create Task button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.textPrimary,
                  foregroundColor: colors.bg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Create Task',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.bg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.now(),
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
    final categories =
        ref.read(categoryListNotifierProvider).valueOrNull ?? [];
    if (categories.isEmpty) return;

    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text('Select Category', style: textTheme.headlineSmall),
              const SizedBox(height: 12),
              ...categories.map((cat) {
                final catColor = Color(int.parse(cat.colorHex, radix: 16));
                return ListTile(
                  leading: Icon(Icons.circle, color: catColor, size: 14),
                  title: Text(cat.name, style: textTheme.bodyLarge),
                  trailing: _categoryId == cat.id
                      ? Icon(
                          Icons.check,
                          color: colors.textPrimary,
                          size: 20,
                        )
                      : null,
                  onTap: () {
                    setState(() => _categoryId = cat.id);
                    Navigator.of(ctx).pop();
                  },
                );
              }),
              ListTile(
                leading: Icon(
                  Icons.close,
                  color: colors.textMuted,
                  size: 14,
                ),
                title: Text(
                  'No category',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.textSecondary,
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
}

// ═══════════════════════════════════════════════════════════════
// Bottom action chip
// ═══════════════════════════════════════════════════════════════

class _BottomChip extends StatelessWidget {
  const _BottomChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.border, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: colors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
