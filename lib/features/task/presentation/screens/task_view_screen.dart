import 'package:flutter/material.dart';

/// Placeholder Task View (analytics) screen.
class TaskViewScreen extends StatelessWidget {
  final String taskId;

  const TaskViewScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Task View: $taskId')));
  }
}
