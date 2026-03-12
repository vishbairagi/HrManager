import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_manager/controllers/location_screen.dart';
import 'package:hr_manager/views/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
final LocationController locationController=Get.put(LocationController());
  var isLoading = false.obs;

  final formKey = GlobalKey<FormState>();

  // Node.js API URL
  final locationApiUrl = 'https://hrmanagerbackend.onrender.com/update-location';
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
        print("Login Successful");

        Get.snackbar("Success", "Login Successful");

        // Get live location after login
        final position = await getCurrentLocation();

        if (position != null) {

          String address = await getAddressFromLatLng(
              position.latitude,
              position.longitude
          );

          locationController.setLocation(address);

          await sendLocationToApi(
            userId: data['user_id'].toString(),
            username: emailController.text.trim(),
            email: data['user_email'] ?? '',
            lat: position.latitude,
            lng: position.longitude,
          );
        }

        Get.offAll(() => HomeScreen());
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

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      Placemark place = placemarks[0];

      String address =
          "${place.street}, ${place.locality}, ${place.administrativeArea}";

      return address;
    } catch (e) {
      return "Location not found";
    }
  }

  // Get current location
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Error", "Location services are disabled.");
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Error", "Location permissions are denied");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
          "Error", "Location permissions are permanently denied.");
      return null;
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // Send location and user info to Node.js API
  Future<void> sendLocationToApi({
    required String userId,
    required String username,
    required String email,
    required double lat,
    required double lng,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(locationApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'username': username,
          'email': email,
          'latitude': lat,
          'longitude': lng,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        print('Location sent successfully with user info');
        print(" Response of Location Apim: ");
        print(response.body);
      } else {
        print('Failed to send location: ${response.body}');
      }
    } catch (e) {
      print('Error sending location: $e');
    }
  }
}