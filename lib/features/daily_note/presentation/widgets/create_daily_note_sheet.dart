import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/novu_colors_extension.dart';

/// Shows the Daily Note bottom sheet.
void showDailyNoteSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const CreateDailyNoteSheet(),
  );
}

class CreateDailyNoteSheet extends ConsumerStatefulWidget {
  const CreateDailyNoteSheet({super.key});

  @override
  ConsumerState<CreateDailyNoteSheet> createState() =>
      _CreateDailyNoteSheetState();
}

class _CreateDailyNoteSheetState extends ConsumerState<CreateDailyNoteSheet> {
  final _noteController = TextEditingController();
  final _focusNode = FocusNode();
  int _selectedMoodIndex = -1; // -1 means none

  final List<String> _moodEmojis = ['😫', '😔', '😐', '🙂', '🤩'];
  final List<String> _moodLabels = ['Awful', 'Bad', 'Okay', 'Good', 'Great'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final note = _noteController.text.trim();
    if (note.isEmpty && _selectedMoodIndex == -1) {
      Navigator.of(context).pop();
      return;
    }
    // TODO: Connect to use case in future iteration
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(context)),
                SliverToBoxAdapter(child: _buildMoodSection(context)),
                SliverToBoxAdapter(child: _buildNoteSection(context)),
                SliverToBoxAdapter(child: _buildPhotoPlaceholder(context)),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
          _buildBottomBar(context, bottomInset),
        ],
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
    final today = DateTime.now();

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          width: 48,
          height: 4,
          decoration: BoxDecoration(
            color: colors.border,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Daily Note',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${months[today.month - 1]} ${today.day}, ${today.year}',
          style: textTheme.bodySmall?.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ─── Mood Tracker ──────────────────────────────────────────────────────
  Widget _buildMoodSection(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MOOD',
            style: textTheme.labelSmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_moodEmojis.length, (i) {
              final isSelected = _selectedMoodIndex == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedMoodIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 56,
                  height: 72,
                  decoration: BoxDecoration(
                    color: isSelected ? colors.surface2 : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? colors.textPrimary : colors.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _moodEmojis[i],
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _moodLabels[i],
                        style: textTheme.labelSmall?.copyWith(
                          color: isSelected
                              ? colors.textPrimary
                              : colors.textSecondary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ─── Text Note ─────────────────────────────────────────────────────────
  Widget _buildNoteSection(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NOTE',
            style: textTheme.labelSmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface2,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: _noteController,
              focusNode: _focusNode,
              maxLines: null,
              minLines: 4,
              style: textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
              decoration: InputDecoration(
                hintText: 'Sum up your day in a few words...',
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: colors.textMuted,
                  height: 1.5,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Pro Photo Placeholder ─────────────────────────────────────────────
  Widget _buildPhotoPlaceholder(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'PHOTO',
                style: textTheme.labelSmall?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.textPrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'PRO',
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.bg,
                    fontWeight: FontWeight.w800,
                    fontSize: 8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.surface2,
              borderRadius: BorderRadius.circular(20),
              // Dashed border visually handled via light dotted color or just solid faint border
              border: Border.all(color: colors.border, width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_a_photo_outlined,
                  color: colors.textMuted,
                  size: 28,
                ),
                const SizedBox(height: 8),
                Text(
                  'Add a photo to remember today',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Bottom Bar ────────────────────────────────────────────────────────
  Widget _buildBottomBar(BuildContext context, double bottomInset) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 16 + bottomInset),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.textPrimary,
              foregroundColor: colors.bg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              'Save Entry',
              style: textTheme.bodyLarge?.copyWith(
                color: colors.bg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
