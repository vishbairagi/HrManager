import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ReportController extends GetxController {

  var report = [].obs;
  var isLoading = false.obs;

  final String baseUrl =
      "https://wordpress.thehrmanagers.com/wp-json/hr/user/month-data";

  String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3dvcmRwcmVzcy50aGVocm1hbmFnZXJzLmNvbSIsImlhdCI6MTc3MzExNzY3NiwibmJmIjoxNzczMTE3Njc2LCJleHAiOjE3NzM3MjI0NzYsImRhdGEiOnsidXNlciI6eyJpZCI6IjEyIn19fQ.VV33TFsFDRKIdKeJoZje8GexV8K9lZnI1tSJOzups3s";

  Future<void> fetchReports(String monthYear, String day) async {

    try {

      isLoading.value = true;

      /// Split month + year
       // 2025

      print("Month: $monthYear");
    //  print("Year: $year");
      print("Day: $day");

      final response = await http.post(
        Uri.parse(baseUrl),

        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },

        body: jsonEncode({
          "month": monthYear,
          "days": day,
        }),
      );

      print("STATUS CODE: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {

        var data = jsonDecode(response.body);

        if (data["success"] == true) {

          report.value = data["data"] ?? [];

        } else {

          Get.snackbar("Error", data["message"].toString());

        }

      } else {

        Get.snackbar("Error", "Status: ${response.statusCode}");

      }

    } catch (e) {

      print(e.toString());
      Get.snackbar("Error", e.toString());

    } finally {

      isLoading.value = false;

    }
  }
}