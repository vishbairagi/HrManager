import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_manager/controllers/profile_controller.dart';

class ProfileScreen2 extends StatelessWidget {
  ProfileScreen2({super.key});

  final ProfileController controller = Get.put(ProfileController());

  Widget buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tabButton(String text, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? Colors.red : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: active
                ? [
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
              )
            ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: active ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body:
      Obx(() {

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.profileData.value;
        print(data);
        final staff = data["staff"] ?? {};

        String name = data["user_display_name"] ?? "";
        String email = data["user_email"] ?? "";
        String dob = staff["date_of_birth"] ?? "Not Available";
        String phone = staff["phone"] ?? "Not Available";
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              /// Tabs
              Row(
                children: [
                  tabButton(
                    "Personal",
                    controller.isPersonal.value,
                        () => controller.changeTab(true),
                  ),

                  const SizedBox(width: 10),

                  tabButton(
                    "Professional",
                    !controller.isPersonal.value,
                        () => controller.changeTab(false),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              /// PERSONAL
              if (controller.isPersonal.value) ...[
                buildField("Full Name", name),
                buildField("Email Address", email),
                buildField("Date of Birth", dob),
                buildField("Mobile Number", phone),
              ],

              /// PROFESSIONAL
              if (!controller.isPersonal.value) ...[
                buildField("Joining Date", staff["date_of_join"] ?? ""),
                buildField("Department Name", "Not Available"),
                buildField("Designation Name", "Not Available"),
                buildField("Salary", staff["salary"] ?? ""),
                buildField("PF No.", "Not Available"),
              ],
            ],
          ),
        );
      }),
    );
  }
}