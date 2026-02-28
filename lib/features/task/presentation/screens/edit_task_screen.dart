import 'package:flutter/material.dart';

/// Placeholder Edit Task screen.
class EditTaskScreen extends StatelessWidget {
  final String taskId;

  const EditTaskScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Edit Task: $taskId')));
  }
}
