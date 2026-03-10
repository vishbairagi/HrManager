import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_manager/controllers/logout_controller.dart';

class LogoutScreen extends StatelessWidget {
  LogoutScreen({super.key});

  final LogoutController controller = Get.put(LogoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logout"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Are you sure you want to logout?",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.logoutUser();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Logout"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); // cancel and go back
                  },
                  child: const Text("Cancel"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}