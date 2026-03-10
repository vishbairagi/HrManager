import 'package:flutter/material.dart';

class LeaveDetailScreen extends StatelessWidget {

  final Map<String, dynamic> leave;

  const LeaveDetailScreen({super.key, required this.leave});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Leave Details"),
        backgroundColor: Colors.blueAccent,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(

          children: [

            _buildRow("Leave ID", leave["leave_id"]),
            _buildRow("Staff ID", leave["staff_id"]),
            _buildRow("Leave Title", leave["leave_title"]),
            _buildRow("Start Date", leave["startDate"]),
            _buildRow("End Date", leave["endDate"]),
            _buildRow("Leave Status", leave["leave_status"]),
            _buildRow("Leave Count", leave["leave_count"]),
            _buildRow("Company ID", leave["company_id"]),
            _buildRow("Created At", leave["created_at"]),
            _buildRow("Is Active", leave["is_active"]),
            _buildRow("Is Delete", leave["is_delete"]),

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
            child: Text(value.toString()),
          ),
        ],
      ),
    );
  }
}