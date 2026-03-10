import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_manager/views/TaskDetailScreen.dart';
import '../controllers/task_controller.dart';

class ProjectScreen extends StatelessWidget {
  ProjectScreen({super.key});

  final TaskController controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("My Projects"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.tasks.isEmpty) {
              return const Center(child: Text("No Tasks Found"));
            }

            return ListView.builder(
              itemCount: controller.tasks.length,
              itemBuilder: (context, index) {
                final task = controller.tasks[index];
                bool isDone = (task["status"] ?? "").toLowerCase() == "done";

                return InkWell(
                  onTap: () {
                    // Navigate to detail screen and pass task
                    Get.to(() => TaskDetailScreen(task: task));
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: isDone ? Colors.deepPurple : Colors.white,
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task["project_name"] ?? "No Project Name",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDone ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            task["task_title"] ?? "",
                            style: TextStyle(
                              fontSize: 16,
                              color: isDone ? Colors.white70 : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Start: ${task["start_date"] ?? "-"}",
                                    style: TextStyle(
                                      color: isDone ? Colors.white70 : Colors.grey[700],
                                    ),
                                  ),
                                  Text(
                                    "End: ${task["end_date"] ?? "-"}",
                                    style: TextStyle(
                                      color: isDone ? Colors.white70 : Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Leader: ${task["team_leader"] ?? "-"}",
                                    style: TextStyle(
                                      color: isDone ? Colors.white70 : Colors.grey[700],
                                    ),
                                  ),
                                  Text(
                                    "Status: ${task["status"] ?? "-"}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isDone ? Colors.white : Colors.blueAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}