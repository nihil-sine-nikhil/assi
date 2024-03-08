import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../domain/repos.dart';
import '../../../signup_screen.dart';
import '../../components/custom_snackbar/custom_snackbar.dart';
import '../../components/custom_textfield/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    _passwordController.dispose();

    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenNotch = MediaQuery.paddingOf(context).top;
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: 25.h,
          left: 17.w,
          right: 17.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupScreen()));
                },
                child: Text(
                  'Not a user? Sign Up first',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Gap(20.h),
            MaterialButton(
              onPressed: () {},
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(7.0), // Adjust radius as desired
              ),
              padding: EdgeInsets.symmetric(vertical: 11.h),
              color: Colors.black,
              child: Text(
                'Login with phone',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
          preferredSize: Size(screenWidth, 50.h + screenNotch),
          child: SizedBox(
            width: screenWidth,
            height: 50.h + screenNotch,
            child: Padding(
              padding: EdgeInsets.only(top: screenNotch, left: 17.w),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: CircleAvatar(
                    backgroundColor: Color(0x176e6d6d),
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 22,
                        )),
                  )),
            ),
          )),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 10.h),
        children: [
          Text(
            'Log In!',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24.sp,
              height: 1.2,
            ),
          ),
          Gap(5.h),
          Text(
            'Login using your account credentials to access your workspace',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                height: 1.4,
                color: Color(0xd2424242)),
          ),
          Gap(15.h),
          CustomTextField(
            hint: 'johndoe@email.com',
            title: 'Email address',
            controller: _emailController,
            textInputType: TextInputType.emailAddress,
          ),
          Gap(15.h),
          CustomTextField(
            hint: '*********',
            title: 'Password',
            controller: _passwordController,
            textInputType: TextInputType.text,
            isObscure: true,
          ),
          Gap(20.h),
          MaterialButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              if (_emailController.text.trim().isEmpty ||
                  _passwordController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).clearSnackBars();
                customErrorSnackBarMsg(
                    time: 2,
                    text: 'Please, enter all the details above',
                    context: context);
              } else if (_passwordController.text.trim().length < 6) {
                ScaffoldMessenger.of(context).clearSnackBars();
                customErrorSnackBarMsg(
                    time: 2,
                    text: 'Please, use a longer password',
                    context: context);
              } else {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim());
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainPage()));
                } on FirebaseAuthException catch (e) {
                  logger.e(e);
                  ScaffoldMessenger.of(context).clearSnackBars();
                  customErrorSnackBarMsg(
                      time: 2, text: '${e.message}', context: context);
                }
              }
              setState(() {
                isLoading = false;
              });
            },
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(7.0), // Adjust radius as desired
            ),
            padding: EdgeInsets.symmetric(vertical: 11.h),
            color: Colors.black,
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Log In',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
