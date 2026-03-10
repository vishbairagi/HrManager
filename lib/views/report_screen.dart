import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_manager/controllers/report_controller.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({super.key});

  final ReportController controller = Get.put(ReportController());

  final RxString selectedMonth = "March 2026".obs;
  final RxString selectedDay = "All".obs;

  /// generate days 1-31
  final List<String> days =
  ["All", ...List.generate(31, (index) => (index + 1).toString())];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              /// Title
              const Text(
                "Reports",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              /// Month + Day Filter
              Row(
                children: [

                  /// Month Dropdown
                  Expanded(
                    child: Obx(
                          () => DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Month / Year",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),

                        value: selectedMonth.value,

                        items: [
                          "March 2026",
                          "February 2026",
                          "January 2026"
                        ]
                            .map(
                              (month) => DropdownMenuItem(
                            value: month,
                            child: Text(month),
                          ),
                        )
                            .toList(),

                        onChanged: (value) {
                          selectedMonth.value = value!;
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  /// Day Dropdown
                  Expanded(
                    child: Obx(
                          () => DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Day",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),

                        value: selectedDay.value,

                        items: days
                            .map(
                              (day) => DropdownMenuItem(
                            value: day,
                            child: Text(day),
                          ),
                        )
                            .toList(),

                        onChanged: (value) {
                          selectedDay.value = value!;
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Get Report Button
              ElevatedButton(
                onPressed: () {
                  controller.fetchReports(
                    selectedMonth.value,
                    selectedDay.value,
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white12,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),

                child: const Text(
                  "Get Report",
                  style: TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 16),

              /// Report List
              Expanded(
                child: Obx(() {

                  /// Loading
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  /// Empty state
                  if (controller.report.isEmpty) {
                    return const Center(
                      child: Text(
                        'Press "Get Report" to get the Report.',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  /// Data List
                  return ListView.builder(
                    itemCount: controller.report.length,

                    itemBuilder: (context, index) {

                      final item = controller.report[index];

                      return GestureDetector(

                        /// Popup with full data
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(

                              title: Text(item["currentDate"] ?? ""),

                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,

                                  children: item.entries.map<Widget>((e) {
                                    return Padding(
                                      padding:
                                      const EdgeInsets.only(bottom: 4),

                                      child: Text(
                                        "${e.key} : ${e.value}",
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          );
                        },

                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              /// Date
                              Text(
                                "${item["day"]} - ${item["currentDate"]}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 8),

                              /// Office Time
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,

                                children: [
                                  Text(
                                      "Office In: ${item["office_in"] ?? "-"}"),
                                  Text(
                                      "Office Out: ${item["office_out"] ?? "-"}"),
                                ],
                              ),

                              const SizedBox(height: 6),

                              /// Lunch Time
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,

                                children: [
                                  Text(
                                      "Lunch In: ${item["lunch_in"] ?? "-"}"),
                                  Text(
                                      "Lunch Out: ${item["lunch_out"] ?? "-"}"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}