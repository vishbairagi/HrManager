import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_manager/controllers/location_screen.dart';
import 'package:hr_manager/views/leave_screen.dart';
import 'package:hr_manager/views/salary_screen.dart';
import 'package:intl/intl.dart';
import 'package:hr_manager/controllers/home_controller.dart';
import 'package:hr_manager/controllers/profile_controller.dart';
import 'package:hr_manager/views/TaskScreen.dart';
import 'package:hr_manager/views/event_screen.dart';
import 'package:hr_manager/views/holiday_screen.dart';
import 'package:hr_manager/views/notice_screen.dart';
import 'package:hr_manager/views/profile_Screen2.dart';
import 'package:hr_manager/views/project_screen.dart';
import 'package:hr_manager/views/report_screen.dart';
import 'package:hr_manager/Screens/Profile_Screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());
  final ProfileController controller2 = Get.put(ProfileController());
  final LocationController locationController = Get.find();
  List<Widget> get screens => [
    buildHomeTab(),
    TaskScreen(),
    HolidayScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.pink.shade100,
          unselectedItemColor: Colors.black54,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Task'),
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Holiday'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  /// HOME TAB
  Widget buildHomeTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// TOP BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.grid_view),
                    onPressed: () {
                      Get.bottomSheet(
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.description,
                                    color: Colors.red),
                                title: const Text("Reports"),
                                onTap: () => Get.to(ReportScreen()),
                              ),
                              ListTile(
                                leading: const Icon(Icons.notifications,
                                    color: Colors.red),
                                title: const Text("Notices"),
                                onTap: () => Get.to(NoticeScreen()),
                              ),
                              ListTile(
                                leading:
                                const Icon(Icons.event, color: Colors.red),
                                title: const Text("Events"),
                                onTap: () => Get.to(EventScreen()),
                              ),
                              ListTile(
                                leading: const Icon(Icons.folder_open,
                                    color: Colors.red),
                                title: const Text("Projects"),
                                onTap: () => Get.to(ProjectScreen()),
                              ),
                              ListTile(
                                leading: const Icon(Icons.calendar_month,
                                    color: Colors.red),
                                title: const Text("Leaves"),
                                onTap: () => Get.to(LeaveScreen()),
                              ),ListTile(
                                leading: const Icon(Icons.wallet,
                                    color: Colors.red),
                                title: const Text("Salary"),
                                onTap: () => Get.to(SalaryScreen()),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  /// PROFILE IMAGE
                  Obx(() {
                    final photoUrl =
                        controller2.profileData['staff']?['profile_photo'] ?? "";

                    return CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage:
                      photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                      child: InkWell(
                        onTap: () => Get.to(ProfileScreen2()),
                        child: photoUrl.isEmpty
                            ? const Icon(Icons.person, size: 28)
                            : null,
                      ),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 20),

              /// WEEK DAYS
              Obx(() {
                var week = controller.getCurrentWeek();

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: week.map((day) {
                    bool isToday = DateFormat('yyyy-MM-dd').format(day) ==
                        DateFormat('yyyy-MM-dd')
                            .format(controller.today.value);

                    return Column(
                      children: [
                        Text(
                          day.day.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isToday ? Colors.red : Colors.black,
                          ),
                        ),
                        Text(
                          DateFormat('EEE').format(day),
                          style: TextStyle(
                            fontSize: 14,
                            color: isToday ? Colors.red : Colors.black54,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              }),

              const SizedBox(height: 20),

              /// TODAY ATTENDANCE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Today Attendance',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Obx(() => Text(
                    controller.currentTime.value,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  )),
                ],
              ),

              const SizedBox(height: 16),

              /// OFFICE IN / OUT
              Row(
                children: [
                  Expanded(
                      child:
                      attendanceCard("Office In", controller.checkIn)),
                  const SizedBox(width: 12),
                  Expanded(
                      child:
                      attendanceCard("Office Out", controller.checkOut)),
                ],
              ),

              const SizedBox(height: 12),

              /// PRESENT / ABSENT
              Row(
                children: [
                  Expanded(
                      child:
                      dayCard("Present Days", controller.presentDays)),
                  const SizedBox(width: 12),
                  Expanded(
                      child:
                      dayCard("Absent Days", controller.absentDays)),
                ],
              ),

              const SizedBox(height: 20),

              // **Office In Location Card**
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // align everything left

                        children: [
                          Text("Live Location :", style: TextStyle(
                            fontSize: 18, // increase size
                            fontWeight: FontWeight.bold,
                          ),),
                          Row(

children: [
                             // const Icon(Icons.login, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Obx(() => Text(
                                  locationController.officeInLocation.value.isNotEmpty
                                      ? locationController.officeInLocation.value
                                      : "Fetching location...",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal, fontSize: 16),
                                )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
SizedBox(height: 10,),
              /// SWIPE BUTTON
              GestureDetector(
                onHorizontalDragEnd: (details) {
                  controller.checkInAPI();
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Text(
                      'Swipe to Check In',
                      style:
                      TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// NOTICE SECTION
              const Text("Notice",
                  style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              const SizedBox(height: 10),

              Obx(() => Column(
                children: controller.noticeList.map((notice) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(Icons.notifications,
                          color: Colors.red),
                      title: Text(notice["notice_title"] ?? ""),
                      subtitle:
                      Text(notice["notice_description"] ?? ""),
                    ),
                  );
                }).toList(),
              )),

              const SizedBox(height: 20),

              /// EVENT SECTION
              const Text("Events",
                  style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              const SizedBox(height: 10),

              Obx(() => Column(
                children: controller.eventList.map((event) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading:
                      const Icon(Icons.event, color: Colors.blue),
                      title: Text(event["title"] ?? ""),
                      subtitle: Text(event["description"] ?? ""),
                      trailing: Text(event["event_date"] ?? ""),
                    ),
                  );
                }).toList(),
              )),

              const SizedBox(height: 20),

              /// HOLIDAY SECTION
              const Text("Holiday",
                  style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              const SizedBox(height: 10),

              Obx(() => Column(
                children: controller.holidayList.map((holiday) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(Icons.beach_access,
                          color: Colors.green),
                      title: Text(holiday["holiday_name"] ?? ""),
                      subtitle:
                      Text(holiday["holiday_description"] ?? ""),
                      trailing:
                      Text(holiday["holiday_startDate"] ?? ""),
                    ),
                  );
                }).toList(),
              )),
            ],
          ),
        ),
      ),
    );
  }
  /// ATTENDANCE CARD
  Widget attendanceCard(String title, RxString value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.login, color: Colors.red),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() => Text(
              value.value,
              style: const TextStyle(fontSize: 24),
            )),
          ],
        ),
      ),
    );
  }

  /// DAY CARD (PRESENT / ABSENT)
  Widget dayCard(String title, RxString value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.red),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() => Text(
              value.value,
              style: const TextStyle(fontSize: 24),
            )),
          ],
        ),
      ),
    );
  }}