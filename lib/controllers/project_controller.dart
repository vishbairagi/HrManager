import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProjectController extends GetxController {

  var projects = [].obs;
  var isLoading = false.obs;

  /// API URL from senior
  final String baseUrl = "API_URL_HERE";

  @override
  void onInit() {
    super.onInit();
    fetchproject();
  }

  Future<void> fetchproject() async {

    try {

      isLoading.value = true;

      final response = await http.get(
        Uri.parse(baseUrl),
      );

      if (response.statusCode == 200) {
        projects.value = jsonDecode(response.body);

      } else {

//        Get.snackbar("Error", "Failed to load tasks");

      }

    } catch (e) {

    //  Get.snackbar("Error", "Server error");

    } finally {

      isLoading.value = false;

    }
  }
}