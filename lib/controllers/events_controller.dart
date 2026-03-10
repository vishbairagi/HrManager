import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EventsController extends GetxController {

  var events = [].obs; // Corrected spelling
  var isLoading = false.obs;

  /// API URL
  final String baseUrl = "https://wordpress.thehrmanagers.com/wp-json/hr/user/user_event";

  /// Your token (replace with actual token)
  final String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3dvcmRwcmVzcy50aGVocm1hbmFnZXJzLmNvbSIsImlhdCI6MTc3MzA1MzUyNSwibmJmIjoxNzczMDUzNTI1LCJleHAiOjE3NzM2NTgzMjUsImRhdGEiOnsidXNlciI6eyJpZCI6IjEyIn19fQ.EgMw90PDs2MnPP81OVPQ_9HjoQJAV87g3TLd9D6dxWw";

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
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

        if (jsonResponse['success'] == true) {
          events.value = jsonResponse['data']; // Only take the data array
        } else {
          Get.snackbar("Error", jsonResponse['message'] ?? "Failed to load events");
        }
      } else {
        Get.snackbar("Error", "Failed to load events: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Server error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}