import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/novu_colors_extension.dart';
import '../../../../core/utils/enums.dart';
import '../../../habit/domain/entities/habit_entity.dart';
import '../../../habit/domain/entities/habit_step_entity.dart';
import '../../../habit/domain/usecases/create_habit_usecase.dart';

const _uuid = Uuid();

/// Shows the Create Habit bottom sheet.
void showCreateHabitSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const CreateHabitBottomSheet(),
  );
}

class CreateHabitBottomSheet extends ConsumerStatefulWidget {
  const CreateHabitBottomSheet({super.key});

  @override
  ConsumerState<CreateHabitBottomSheet> createState() =>
      _CreateHabitBottomSheetState();
}

class _CreateHabitBottomSheetState
    extends ConsumerState<CreateHabitBottomSheet> {
  // ─── Form state ───────────────────────────────────────
  final _nameController = TextEditingController();
  final _nameFocus = FocusNode();

  HabitType _habitType = HabitType.yesNo;

  // Measurable fields
  final _unitController = TextEditingController();
  final _targetController = TextEditingController();
  MeasurableTarget _measurableTarget = MeasurableTarget.atLeast;

  // Sub-habits
  final List<TextEditingController> _subHabitControllers = [];
  final List<FocusNode> _subHabitFocusNodes = [];

  // Repeat
  int _repeatMode = 0; // 0=Daily, 1=Weekly, 2=Monthly
  final _intervalController = TextEditingController(text: '1');
  final Set<int> _selectedDays = {}; // 0=S,1=M,2=T,3=W,4=T,5=F,6=S

  // Reminder
  TimeOfDay? _reminderTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nameFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocus.dispose();
    _unitController.dispose();
    _targetController.dispose();
    _intervalController.dispose();
    for (final c in _subHabitControllers) {
      c.dispose();
    }
    for (final f in _subHabitFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  List<int> _resolveFrequencyDays() {
    switch (_repeatMode) {
      case 0: // Daily
        return [0, 1, 2, 3, 4, 5, 6];
      case 1: // Weekly
        return _selectedDays.toList()..sort();
      case 2: // Monthly
        return [0]; // placeholder
      default:
        return [0, 1, 2, 3, 4, 5, 6];
    }
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final now = DateTime.now();
    final habitId = _uuid.v4();

    // Build sub-habit steps
    final steps = <HabitStepEntity>[];
    for (var i = 0; i < _subHabitControllers.length; i++) {
      final text = _subHabitControllers[i].text.trim();
      if (text.isNotEmpty) {
        steps.add(
          HabitStepEntity(
            id: _uuid.v4(),
            habitId: habitId,
            title: text,
            order: i,
          ),
        );
      }
    }

    final habit = HabitEntity(
      id: habitId,
      title: name,
      type: _habitType,
      unit: _habitType == HabitType.measurable
          ? _unitController.text.trim()
          : null,
      targetValue: _habitType == HabitType.measurable
          ? int.tryParse(_targetController.text.trim())
          : null,
      targetType: _habitType == HabitType.measurable
          ? _measurableTarget
          : null,
      frequencyDays: _resolveFrequencyDays(),
      reminderTime: _reminderTime != null
          ? "\${_reminderTime!.hour.toString().padLeft(2, '0')}:\${_reminderTime!.minute.toString().padLeft(2, '0')}"
          : null,
      createdAt: now,
      updatedAt: now,
    );

    final usecase = getIt<CreateHabitUsecase>();
    await usecase.call(habit, steps);

    if (mounted) Navigator.of(context).pop();
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
                SliverToBoxAdapter(child: _buildTypeToggle(context)),
                SliverToBoxAdapter(child: _buildNameSection(context)),
                if (_habitType == HabitType.measurable) ...[
                  SliverToBoxAdapter(child: _buildUnitSection(context)),
                  SliverToBoxAdapter(child: _buildTargetSection(context)),
                ],
                SliverToBoxAdapter(child: _buildSubHabitsSection(context)),
                SliverToBoxAdapter(child: _buildRepeatSection(context)),
                SliverToBoxAdapter(child: _buildReminderSection(context)),
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
          'New Habit',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ═══ Type Toggle (Yes/No | Measurable) ═════════════════
  Widget _buildTypeToggle(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    final options = ['Yes / No', 'Measurable'];

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
              final isSelected = (_habitType == HabitType.yesNo && i == 0) ||
                  (_habitType == HabitType.measurable && i == 1);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _habitType =
                        i == 0 ? HabitType.yesNo : HabitType.measurable;
                  });
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
            controller: _nameController,
            focusNode: _nameFocus,
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

  // ═══ UNIT Section (Measurable only) ════════════════════
  Widget _buildUnitSection(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'UNIT',
            style: textTheme.labelSmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: _unitController,
            style: textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: 'e.g miles',
              hintStyle: textTheme.bodyLarge?.copyWith(
                color: colors.textMuted,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  // ═══ TARGET Section (Measurable only) ══════════════════
  Widget _buildTargetSection(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TARGET',
            style: textTheme.labelSmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _targetController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'e.g 15',
                    hintStyle: textTheme.bodyLarge?.copyWith(
                      color: colors.textMuted,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // At least / At most toggle
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: colors.surface2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTargetChip(
                      context,
                      label: 'At least',
                      isSelected:
                          _measurableTarget == MeasurableTarget.atLeast,
                      onTap: () => setState(
                        () => _measurableTarget = MeasurableTarget.atLeast,
                      ),
                    ),
                    _buildTargetChip(
                      context,
                      label: 'At most',
                      isSelected:
                          _measurableTarget == MeasurableTarget.atMost,
                      onTap: () => setState(
                        () => _measurableTarget = MeasurableTarget.atMost,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTargetChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
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
          label,
          style: textTheme.bodySmall?.copyWith(
            color: isSelected ? colors.textPrimary : colors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  // ═══ SUBHABITS Section ═════════════════════════════════
  Widget _buildSubHabitsSection(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SUBHABITS',
            style: textTheme.labelSmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(_subHabitControllers.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.drag_indicator_rounded,
                    color: colors.textMuted,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _subHabitControllers[i],
                      focusNode: _subHabitFocusNodes[i],
                      style: textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Sub-habit ${i + 1}',
                        hintStyle: textTheme.bodyMedium?.copyWith(
                          color: colors.textMuted,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      onSubmitted: (_) => _addSubHabit(),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _removeSubHabit(i),
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
          GestureDetector(
            onTap: _addSubHabit,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.add_rounded, color: colors.textMuted, size: 18),
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

  void _addSubHabit() {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    setState(() {
      _subHabitControllers.add(controller);
      _subHabitFocusNodes.add(focusNode);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  void _removeSubHabit(int index) {
    setState(() {
      _subHabitControllers[index].dispose();
      _subHabitFocusNodes[index].dispose();
      _subHabitControllers.removeAt(index);
      _subHabitFocusNodes.removeAt(index);
    });
  }

  // ═══ REPEAT Section ════════════════════════════════════
  Widget _buildRepeatSection(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    final dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final repeatLabels = ['Daily', 'Weekly', 'Monthly'];
    final unitLabels = ['days', 'weeks', 'months'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'REPEAT',
            style: textTheme.labelSmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                // Segmented control
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: colors.bg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: List.generate(3, (i) {
                      final isSelected = _repeatMode == i;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _repeatMode = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colors.surface
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.06),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              repeatLabels[i],
                              style: textTheme.bodySmall?.copyWith(
                                color: isSelected
                                    ? colors.textPrimary
                                    : colors.textSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),
                // Interval row
                Row(
                  children: [
                    Text('Every', style: textTheme.bodyMedium),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 56,
                      height: 36,
                      child: TextField(
                        controller: _intervalController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: colors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(unitLabels[_repeatMode], style: textTheme.bodyMedium),
                  ],
                ),
                // Day selector (weekly only)
                if (_repeatMode == 1) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (i) {
                      final isSelected = _selectedDays.contains(i);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedDays.remove(i);
                            } else {
                              _selectedDays.add(i);
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? colors.textPrimary
                                : Colors.transparent,
                            border: isSelected
                                ? null
                                : Border.all(
                                    color: colors.border,
                                    width: 1,
                                  ),
                          ),
                          child: Text(
                            dayLabels[i],
                            style: textTheme.bodySmall?.copyWith(
                              color: isSelected
                                  ? colors.bg
                                  : colors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══ REMINDER Section ══════════════════════════════════
  Widget _buildReminderSection(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Row(
        children: [
          Text(
            'REMINDER',
            style: textTheme.labelSmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _reminderTime ?? TimeOfDay.now(),
              );
              if (picked != null) setState(() => _reminderTime = picked);
            },
            child: Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color: colors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  _reminderTime != null
                      ? _reminderTime!.format(context)
                      : 'Set time',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
                  icon: Icons.track_changes_rounded,
                  label: _habitType == HabitType.yesNo
                      ? 'Challenge'
                      : 'Goal',
                  onTap: () {
                    // TODO: Challenge/Goal picker in future phase
                  },
                ),
                const SizedBox(width: 8),
                _BottomChip(
                  icon: Icons.flag_outlined,
                  label: 'Priority',
                  onTap: () {
                    // TODO: Priority picker
                  },
                ),
                const SizedBox(width: 8),
                _BottomChip(
                  icon: Icons.bookmark_border_rounded,
                  label: 'Tags',
                  onTap: () {
                    // TODO: Tag picker
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Create Habit button
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
                  'Create Habit',
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
