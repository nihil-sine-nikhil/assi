import 'package:assignment/src/display/screens/main_screen.dart';
import 'package:assignment/src/domain/helpers/shared_preference_helper.dart';
import 'package:assignment/src/signup_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  navigate() async {
    final isLogin = SharedPreferencesHelper.isLogin();
    Future.delayed(const Duration(seconds: 2), () {
      if (isLogin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MainScreen()), // Replace with your home page
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SignupScreen()), // Replace with your sign-up page
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      ),
    );
  }
}
