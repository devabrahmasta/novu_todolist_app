import 'package:flutter/material.dart';

import '../../../../core/theme/novu_colors_extension.dart';

class ProjectsPlaceholderScreen extends StatelessWidget {
  const ProjectsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    return Scaffold(
      backgroundColor: colors.bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_outlined, size: 64, color: colors.textMuted),
            const SizedBox(height: 16),
            Text('Projects', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Coming soon', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
