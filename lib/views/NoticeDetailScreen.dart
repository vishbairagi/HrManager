import 'package:flutter/material.dart';

class NoticeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> notice;

  const NoticeDetailScreen({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notice Details"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildRow("Notice Name", notice["notice_name"]),
            _buildRow("Description", notice["notice_description"]),
            _buildRow("ID", notice["id"]),
            _buildRow("Company ID", notice["company_id"]),
            _buildRow("Is Active", notice["is_active"]),
            _buildRow("Is Delete", notice["is_delete"]),
            _buildRow("Created At", notice["created_at"]),
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