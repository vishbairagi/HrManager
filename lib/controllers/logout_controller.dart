import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hr_manager/views/login_screen.dart';

class LogoutController extends GetxController {
  /// Call this to logout the user
  void logoutUser() {
    // Clear any stored session or token
    // Example: if using GetStorage or shared_preferences
    // GetStorage().erase(); // uncomment if using GetStorage
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();

    // Navigate to login page and remove all previous routes
    Get.offAll(() => LoginScreen());
  }
}