import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_manager/controllers/leaves_controller.dart';
import 'package:hr_manager/views/LeaveDetailScreen.dart';


class LeaveScreen extends StatelessWidget {
  LeaveScreen({super.key});

  final LeaveController controller = Get.put(LeaveController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("My Leaves"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() {

            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.leaves.isEmpty) {
              return const Center(child: Text("No Leaves Found"));
            }

            return ListView.builder(
              itemCount: controller.leaves.length,
              itemBuilder: (context, index) {

                final leave = controller.leaves[index];

                bool approved =
                    (leave["leave_status"] ?? "").toLowerCase() == "approved";

                return InkWell(
                  onTap: () {
                    Get.to(() => LeaveDetailScreen(leave: leave));
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    color: approved ? Colors.green[400] : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            leave["leave_title"] ?? "",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: approved ? Colors.white : Colors.black,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    "Start: ${leave["startDate"]}",
                                    style: TextStyle(
                                      color: approved
                                          ? Colors.white70
                                          : Colors.grey[700],
                                    ),
                                  ),

                                  Text(
                                    "End: ${leave["endDate"]}",
                                    style: TextStyle(
                                      color: approved
                                          ? Colors.white70
                                          : Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                leave["leave_status"] ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: approved
                                      ? Colors.white
                                      : Colors.blueAccent,
                                ),
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