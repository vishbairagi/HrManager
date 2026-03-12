import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_manager/controllers/location_screen.dart';
import 'package:provider/provider.dart';
import 'package:hr_manager/Screens/Splash_screens.dart';
import 'package:hr_manager/theme/theme_controller.dart';

void main() {
  Get.put(LocationController());

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'HR Manager',
      theme: themeController.currentTheme,
      home: const SplashScreen(),
    );
  }
}