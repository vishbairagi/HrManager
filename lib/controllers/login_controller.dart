import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_manager/views/home_screen.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  final formKey = GlobalKey<FormState>();

  Future<void> loginUser() async {

    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    final url = Uri.parse(
        'https://wordpress.thehrmanagers.com/wp-json/jwt-auth/v1/token');

    try {
      final response = await http.post(
        url,
        body: {
          'username': emailController.text.trim(),
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Login Successsfull");

        Get.snackbar("Success", "Login Successful");
        print("Login Successsfull2");
        Get.offAll(() =>  HomeScreen());

      } else {
        final error = json.decode(response.body);

        Get.snackbar("Error", error['message']);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}