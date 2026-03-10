import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HolidayController extends GetxController {
  var holidayList = [].obs;
  var isLoading = false.obs;

  final String apiUrl =
      "https://wordpress.thehrmanagers.com/wp-json/hr/user/user_holiday";

  /// Replace with your actual token
  final String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3dvcmRwcmVzcy50aGVocm1hbmFnZXJzLmNvbSIsImlhdCI6MTc3MzA0MjU2NywibmJmIjoxNzczMDQyNTY3LCJleHAiOjE3NzM2NDczNjcsImRhdGEiOnsidXNlciI6eyJpZCI6IjEyIn19fQ.lG_hs1yJrt2EkHFVfnkYTK06jdfEokAts1p__Hn_G_A";

  @override
  void onInit() {
    super.onInit();
    fetchHolidays();
  }

  Future<void> fetchHolidays() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse);

        if (jsonResponse["success"] == true) {
          holidayList.value = jsonResponse["data"];
        } else {
          Get.snackbar("Error", jsonResponse["message"] ?? "Failed to load holidays");
        }
      } else {
        Get.snackbar("Error", "Failed to load holidays");
      }
    } catch (e) {
      Get.snackbar("Error", "Server Error");
    } finally {
      isLoading.value = false;
    }
  }
}