import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_manager/controllers/logout_controller.dart';
import 'package:hr_manager/controllers/profile_controller.dart';
import 'package:hr_manager/views/logout_screen.dart';
import 'package:hr_manager/views/profile_Screen2.dart';
import 'package:hr_manager/views/update_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller=Get.put(ProfileController());
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Profile Image
            Obx(() {
              final event = controller.profileData.value;
              final staff = event['staff'];
              return CircleAvatar(
                radius: 50,
                backgroundColor: Colors.purple[100],
                backgroundImage: staff['profile_photo'] != null
                    ? NetworkImage(staff['profile_photo'])
                    : null,
                // Remove child completely
                child: null,
              );
            }),
            const SizedBox(height: 20),

            // Edit Profile Button
            ElevatedButton(
              onPressed: () {
                Get.to(UpdateProfileScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(
                    horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Edit Profile"),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  buildOption(
                    icon: Icons.person_outline,
                    title: "My Profile",
                    onTap: () {
                      Get.to(() =>  ProfileScreen2());
                    },
                  ),

                  buildOption(
                    icon: Icons.description_outlined,
                    title: "Terms & Conditions",
                    onTap: () {},
                  ),

                  buildOption(
                    icon: Icons.lock_outline,
                    title: "Privacy Policy",
                    onTap: () {},
                  ),

                  buildOption(
                    icon: Icons.logout,
                    title: "Log out",
                    titleColor: Colors.red,
                    onTap: () {
                      Get.to(LogoutScreen());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOption({
    required IconData icon,
    required String title,
    Color titleColor = Colors.black,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: TextStyle(color: titleColor),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}