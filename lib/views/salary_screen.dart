import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_manager/controllers/salary_controller.dart';

class SalaryScreen extends StatelessWidget {
  SalaryScreen({super.key});

  final SalarySlipController controller = Get.put(SalarySlipController());

  final RxString selectedMonth = "March 2026".obs;

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
                "Salary Slip",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              /// Month Dropdown
              Obx(() => DropdownButtonFormField<String>(
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
                    .map((month) => DropdownMenuItem(
                  value: month,
                  child: Text(month),
                ))
                    .toList(),

                onChanged: (value) {
                  selectedMonth.value = value!;
                },
              )),

              const SizedBox(height: 20),

              /// Get Report Button
              ElevatedButton(
                onPressed: () {
                  controller.fetchSalarySlip(selectedMonth.value);
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white12,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),

                child: const Text(
                  "Get Salary Slip",
                  style: TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 16),

              /// Result Section
              Expanded(
                child: Obx(() {

                  /// Loading
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  /// Empty
                  if (controller.salaryData.isEmpty) {
                    return const Center(
                      child: Text(
                        "Press Get Salary Slip",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  final data = controller.salaryData;

                  return GestureDetector(

                    /// Show all data popup
                    onTap: () {

                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(

                          title: const Text("Salary Slip Details"),

                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: data.entries.map<Widget>((e) {

                                return Padding(
                                  padding:
                                  const EdgeInsets.only(bottom: 6),

                                  child: Text(
                                    "${e.key} : ${e.value}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );

                              }).toList(),
                            ),
                          ),
                        ),
                      );

                    },

                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              /// Name
                              Row(
                                children: [
                                  const Icon(Icons.person, color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      data["empFullName"] ?? "",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const Divider(height: 20),

                              _infoRow("Phone", data["phone_no"]),
                              _infoRow("Department", data["department"]),
                              _infoRow("Designation", data["designation"]),

                              const SizedBox(height: 10),

                              _infoRow("Salary", data["empSalary"]),
                              _infoRow("Leaves", data["leaves"].toString()),
                              _infoRow("Working Days", data["total_working_days"].toString()),
                              _infoRow("Attendance", data["total_attendance"].toString()),
                              _infoRow("Absent", data["total_absent"].toString()),
                              _infoRow("Working Hours", data["TotalWorkingHour"].toString()),

                              const Divider(),

                              _infoRow("Total Salary", data["Toatlsalary"]),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Calculated Salary",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    data["CalculatedSalary"] ?? "-",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


Widget _infoRow(String title, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(value ?? "-"),
      ],
    ),
  );
}