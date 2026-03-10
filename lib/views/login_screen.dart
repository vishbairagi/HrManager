import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {

  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [

                    /// Email
                    TextFormField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter Email";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    /// Password
                    TextFormField(
                      controller: controller.passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter Password";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    /// Login Button
                    Obx(() => SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.loginUser,
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text("Login"),
                      ),
                    )),

                    const SizedBox(height: 20),

                    TextButton(
                      onPressed: () {},
                      child: const Text("Forgot Password?"),
                    )

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}