import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:hr_manager/controllers/holiday_controller.dart';

class HolidayScreen extends StatelessWidget {
  HolidayScreen({super.key});

  final HolidayController controller = Get.put(HolidayController());

  /// Convert date string "dd-MM-yyyy" to weekday name
  String getWeekDay(String dateStr) {
    try {
      final date = DateFormat("dd-MM-yyyy").parse(dateStr);
      return DateFormat.EEEE().format(date); // full weekday name
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      appBar: AppBar(
        title: const Text(
          "Holiday List",
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xfff4f4f4),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.holidayList.isEmpty) {
            return const Center(child: Text("No Holidays Found"));
          }

          return ListView.builder(
            itemCount: controller.holidayList.length,
            itemBuilder: (context, index) {
              var holiday = controller.holidayList[index];

              String startDate = holiday["holiday_startDate"] ?? "";
              String endDate = holiday["holiday_endDate"] ?? "";
              String dayName = getWeekDay(startDate);

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row with calendar icon and red side bar
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 50,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.event,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            holiday["holiday_name"] ?? "",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              dayName,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Start and End dates
                      Text(
                        "Start: $startDate",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        "End: $endDate",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Days
                      Text(
                        "Duration: ${holiday["days"] ?? ""} day(s)",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Description
                      if (holiday["holiday_description"] != null)
                        Text(
                          holiday["holiday_description"],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}