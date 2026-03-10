import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_manager/views/NoticeDetailScreen.dart';
import '../controllers/notice_controller.dart';

class NoticeScreen extends StatelessWidget {
  NoticeScreen({super.key});

  final NoticeController controller = Get.put(NoticeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Notices"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.notices.isEmpty) {
              return const Center(child: Text("No Notices Found"));
            }

            return ListView.builder(
              itemCount: controller.notices.length,
              itemBuilder: (context, index) {
                final notice = controller.notices[index];

                return InkWell(
                  onTap: () {
                    // Navigate to detail screen and pass notice data
                    Get.to(() => NoticeDetailScreen(notice: notice));
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
                            notice["notice_name"] ?? "No Name",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            notice["notice_description"] ?? "No Description",
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