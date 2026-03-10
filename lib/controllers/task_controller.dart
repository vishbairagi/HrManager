import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TaskController extends GetxController {
  var tasks = [].obs;
  var isLoading = false.obs;

  /// API URL
  final String baseUrl = "https://wordpress.thehrmanagers.com/wp-json/hr/user/user_task";

  /// Your token (pass your actual token here)
  final String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3dvcmRwcmVzcy50aGVocm1hbmFnZXJzLmNvbSIsImlhdCI6MTc3MzA1MzUyNSwibmJmIjoxNzczMDUzNTI1LCJleHAiOjE3NzM2NTgzMjUsImRhdGEiOnsidXNlciI6eyJpZCI6IjEyIn19fQ.EgMw90PDs2MnPP81OVPQ_9HjoQJAV87g3TLd9D6dxWw";

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse);

        if (jsonResponse['success'] == true) {
          tasks.value = jsonResponse['data']; // Only take the data array
        } else {
          Get.snackbar("Error", jsonResponse['message'] ?? "Failed to load tasks");
        }
      } else {
        Get.snackbar("Error", "Failed to load tasks: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Server error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}