import 'package:flutter/material.dart';

import '../widgets/create_task_bottom_sheet.dart';

/// Create Task screen — shows the bottom sheet immediately on entry.
///
/// If opened via route (e.g. deep link), it auto-launches the sheet.
/// Otherwise prefer calling [showCreateTaskSheet] directly.
class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showCreateTaskSheet(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.transparent);
  }
}
