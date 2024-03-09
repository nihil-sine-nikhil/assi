import 'package:assignment/src/display/screens/home/main_screen.dart';
import 'package:assignment/src/display/screens/sign_up/signup_screen.dart';
import 'package:assignment/src/domain/helpers/shared_preference_helper.dart';
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
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignupScreen()),
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
