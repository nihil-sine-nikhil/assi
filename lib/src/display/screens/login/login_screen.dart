import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../components/custom_textfield/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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
                onTap: () {},
                child: Text(
                  'Login with phone number',
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
                'Send invite',
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
            'Welcome back!',
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
          Gap(15.h),
          Text(
            'Forgot password?',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              fontSize: 13.sp,
              color: Colors.black87,
            ),
          ),
          Gap(3.h),
        ],
      ),
    );
  }
}
