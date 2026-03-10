import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {

  final String apiUrl =
      "https://wordpress.thehrmanagers.com/wp-json/jwt-auth/v1/token";

  var isLoading = true.obs;
  var profileData = {}.obs;
  var isPersonal = true.obs;

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  void changeTab(bool value) {
    isPersonal.value = value;
  }

  Future<void> fetchProfile() async {
    try {
      isLoading(true);

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "username": "weblizar_staff",
          "password": "123456"
        },
      );

      print("STATUS CODE: ${response.statusCode}");
      print("API RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        profileData.value = json.decode(response.body);
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Failed to load profile");
    } finally {
      isLoading(false);
    }
  }}