import 'package:flutter/material.dart';
import '../../../../core/theme/novu_colors_extension.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
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
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;
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
      title: Text(title, style: textTheme.bodyLarge),
      trailing: trailing != null
          ? Text(
              trailing!,
              style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
            )
          : Icon(
              Icons.chevron_right_rounded,
              color: colors.textMuted,
              size: 22,
            ),
      onTap: onTap,
    );
  }
}
