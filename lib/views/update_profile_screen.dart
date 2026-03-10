import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  // Reactive variables
  final isLoading = true.obs;
  final profileData = {}.obs;

  // Text controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // API endpoints
  final String apiUrl = "https://wordpress.thehrmanagers.com/wp-json/jwt-auth/v1/token";
  final String updateUrl = "https://wordpress.thehrmanagers.com/wp-json/wp/v2/users/me";

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "username": "weblizar_staff_1",
          "password": "123456",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        profileData.value = data;
        usernameController.text = data['user_nicename'] ?? '';
      } else {
        Get.snackbar("Error", "Failed to load profile");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateProfile() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Username and password cannot be empty");
      return;
    }

    try {
      isLoading(true);
      final token = profileData['token'];
      final response = await http.post(
        Uri.parse(updateUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "username": usernameController.text,
          "password": passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Profile updated successfully");
        profileData['user_nicename'] = usernameController.text;
      } else {
        print("Update failed: ${response.body}");
        Get.snackbar("Error", "Failed to update profile");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Update Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (profileData.isEmpty) {
          return const Center(child: Text("No profile data"));
        }

        final staff = profileData['staff'];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                        NetworkImage(staff['profile_photo'] ?? ''),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        staff['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        staff['email'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Username Field
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),

              // Password Field
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),

              // Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: updateProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: const Text(
                    'Update Profile',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}