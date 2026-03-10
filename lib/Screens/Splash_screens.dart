import 'package:flutter/material.dart';
import 'package:hr_manager/views/home_screen.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hr_manager/views/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      animationBehavior: AnimationBehavior.normal,
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    checkLogin();
  }

  /// Check if user already logged in
  Future<void> checkLogin() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    await Future.delayed(const Duration(seconds: 3));

    if (token != null && token.isNotEmpty) {

      /// User already logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );

    } else {

      /// User not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SizedBox.expand(
          child: Image.network(
            'https://play-lh.googleusercontent.com/ofKNsJyn7CgLSXpCnwn-yxf7RBa4_tOtrq_Gvzjk79ywpImHylIq-Un8HRCG0pI6LRLI=w480-h960-rw',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}