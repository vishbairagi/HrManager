import 'package:flutter/material.dart';

class EventDetailScreen extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Details"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildRow("Event Name", event["event_name"]),
            _buildRow("Description", event["event_description"]),
            _buildRow("Event Date", event["event_date"]),
            _buildRow("Event Time", event["event_time"]),
            _buildRow("ID", event["id"]),
            _buildRow("Company ID", event["company_id"]),
            _buildRow("Is Active", event["is_active"]),
            _buildRow("Is Delete", event["is_delete"]),
            _buildRow("Created At", event["created_at"]),
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