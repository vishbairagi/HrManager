import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_manager/views/EventDetailScreen.dart';
import '../controllers/events_controller.dart';

class EventScreen extends StatelessWidget {
  EventScreen({super.key});

  final EventsController controller = Get.put(EventsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Events"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.events.isEmpty) {
              return const Center(child: Text("No Events Found"));
            }

            return ListView.builder(
              itemCount: controller.events.length,
              itemBuilder: (context, index) {
                final event = controller.events[index];

                return InkWell(
                  onTap: () {
                    // Navigate to detail screen with event data
                    Get.to(() => EventDetailScreen(event: event));
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event["event_name"] ?? "No Name",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            event["event_description"] ?? "No Description",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
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