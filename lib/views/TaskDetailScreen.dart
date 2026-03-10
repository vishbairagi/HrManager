import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  final Map<String, dynamic> task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Details"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildRow("Project Name", task["project_name"]),
            _buildRow("Task Title", task["task_title"]),
            _buildRow("Start Date", task["start_date"]),
            _buildRow("End Date", task["end_date"]),
            _buildRow("Team Leader", task["team_leader"]),
            _buildRow("Assigned Staff", task["assign_staff"]),
            _buildRow("Status", task["status"]),
            _buildRow("Project ID", task["project_id"]),
            _buildRow("Team Leader ID", task["team_leader_id"]),
            _buildRow("Task Assign ID", task["task_assign_id"]),
            _buildRow("Is Active", task["is_active"]),
            _buildRow("Is Delete", task["is_delete"]),
            _buildRow("Created At", task["created_at"]),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value ?? "-"),
          ),
        ],
      ),
    );
  }
}