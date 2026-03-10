import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LeaveController extends GetxController {

  var leaves = [].obs;
  var isLoading = false.obs;

  /// API URL
  final String baseUrl =
      "https://wordpress.thehrmanagers.com/wp-json/hr/user/leaves";

  /// Token (replace with your token)
  final String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3dvcmRwcmVzcy50aGVocm1hbmFnZXJzLmNvbSIsImlhdCI6MTc3MzExMzMzMywibmJmIjoxNzczMTEzMzMzLCJleHAiOjE3NzM3MTgxMzMsImRhdGEiOnsidXNlciI6eyJpZCI6IjEyIn19fQ.kzLw-Hjjpngxa7duknl5R_mvSZrMGpWbn9ucR2MOVQc";

  @override
  void onInit() {
    super.onInit();
    fetchLeaves();
  }

  Future<void> fetchLeaves() async {
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

        if (jsonResponse["success"] == true) {

          // store only data list
          leaves.value = jsonResponse["data"];

        } else {

          Get.snackbar("Error", jsonResponse["message"]);

        }

      } else {

        Get.snackbar("Error", "Failed to load leaves: ${response.statusCode}");

      }

    } catch (e) {

      Get.snackbar("Error", "Server error: $e");

    } finally {

      isLoading.value = false;

    }
  }
}