import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  // ------------------- OBSERVABLES -------------------
  var currentTime = ''.obs;
  var selectedIndex = 0.obs;
  var isCheckedIn = false.obs;
  var isLoading = false.obs;

  var today = DateTime.now().obs;

  // Attendance
  var checkIn = "00:00".obs;
  var checkOut = "00:00".obs;
  var presentDays = "0".obs;
  var absentDays = "0".obs;

  // Staff info
  var staffName = "".obs;
  var email = "".obs;
  var phone = "".obs;
  var department = "".obs;
  var profilePhoto = "".obs;

  // Lists
  var noticeList = <Map<String, dynamic>>[].obs;
  var eventList = <Map<String, dynamic>>[].obs;
  var holidayList = <Map<String, dynamic>>[].obs;

  // IDs required for check-in
  late int staffId;
  late int userId;

  // Timer
  late Timer timer;

  // ------------------- API -------------------
  final String baseUrl = "https://wordpress.thehrmanagers.com/wp-json/hr/user/home";
  late String token;

  // ------------------- INIT -------------------
  @override
  void onInit() {
    super.onInit();

    // Set your token here
    token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3dvcmRwcmVzcy50aGVocm1hbmFnZXJzLmNvbSIsImlhdCI6MTc3MzEyODAwMCwibmJmIjoxNzczMTI4MDAwLCJleHAiOjE3NzM3MzI4MDAsImRhdGEiOnsidXNlciI6eyJpZCI6IjEyIn19fQ._cVXn4FMIhBhIswUtKtK6lTcodsc58dcpxYgMYeHRW0";

    // Start timer
    updateTime();
    timer = Timer.periodic(const Duration(seconds: 1), (_) => updateTime());

    fetchHomeData();
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }

  // ------------------- TIME -------------------
  void updateTime() {
    currentTime.value = DateFormat('hh:mm:ss a').format(DateTime.now());
  }

  // ------------------- TAB -------------------
  void changeTab(int index) {
    selectedIndex.value = index;
  }

  // ------------------- WEEK DAYS -------------------
  List<DateTime> getCurrentWeek() {
    int weekday = today.value.weekday;
    DateTime startOfWeek = today.value.subtract(Duration(days: weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  // ------------------- FETCH HOME DATA -------------------
  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json["data"];

        // Store IDs for check-in
        staffId = int.parse(data["staff_id"].toString());
        userId = int.parse(data["user_id"].toString());

        // Staff info
        staffName.value = data["staffName"] ?? "";
        email.value = data["email"] ?? "";
        phone.value = data["phone_no"] ?? "";
        department.value = data["department"] ?? "";
        profilePhoto.value = data["profile_photo"] ?? "";

        // Attendance
        checkIn.value = data["office_in_time"] ?? "00:00";
        checkOut.value = data["office_out_time"] ?? "00:00";
        presentDays.value = data["attendate_days"].toString();
        absentDays.value = data["total_absent"].toString();

        // Lists
        noticeList.value = List<Map<String, dynamic>>.from(data["notice_data"] ?? []);
        eventList.value = List<Map<String, dynamic>>.from(data["event_data"] ?? []);
        holidayList.value = List<Map<String, dynamic>>.from(data["holiday_data"] ?? []);

      } else {
        print("API ERROR: ${response.statusCode}");
      }
    } catch (e) {
      print("API Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------- CHECK-IN API -------------------
  Future<void> checkInAPI() async {
    if (isCheckedIn.value) return; // prevent double swipe

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "action": "check_in",
          "staff_id": staffId,
          "user_id": userId,
        }),
      );

      print("Check-in response: ${response.statusCode} ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        isCheckedIn.value = true;

        // Refresh dashboard
        await fetchHomeData();

        Get.snackbar("Success", "Checked in successfully!");
      } else {
        Get.snackbar("Error", data["message"] ?? "Check-in failed!");
      }
    } catch (e) {
      print("Check-in error: $e");
      Get.snackbar("Error", "Check-in error!");
    }
  }
}