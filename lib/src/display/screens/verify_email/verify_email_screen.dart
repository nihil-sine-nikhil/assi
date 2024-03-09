import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../domain/helpers/shared_preference_helper.dart';
import '../../components/custom_snackbar/custom_snackbar.dart';
import '../home/main_screen.dart';
import '../sign_up/signup_screen.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({
    super.key,
  });

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = false;
  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(Duration(seconds: 2), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer?.cancel();
      SharedPreferencesHelper.setIsLogin(true);
    }
    ;
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      customErrorSnackBarMsg(time: 2, text: e.toString(), context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenNotch = MediaQuery.paddingOf(context).top;
    return isEmailVerified
        ? MainScreen()
        : Scaffold(
            appBar: PreferredSize(
                preferredSize: Size(screenWidth, 50.h + screenNotch),
                child: SizedBox(
                  width: screenWidth,
                  height: 50.h + screenNotch,
                  child: Padding(
                    padding: EdgeInsets.only(top: screenNotch, left: 17.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: CircleAvatar(
                              backgroundColor: Color(0x176e6d6d),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignupScreen()),
                                        (route) => false);
                                    FirebaseAuth.instance.signOut();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    size: 22,
                                  )),
                            ),
                          ),
                        ),
                        Text(
                          'Verify Email Address',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17.sp,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                )),
            body: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'A verification mail has been sent to your email address.',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22.sp,
                      height: 1.2,
                    ),
                  ),
                  Gap(10.h),
                  Text(
                    'Please, verify the email address to proceed further',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17.sp,
                        height: 1.2,
                        color: Colors.black87),
                  ),
                  Gap(15.h),
                  Icon(
                    Icons.email_outlined,
                    size: 150.w,
                  ),
                  MaterialButton(
                    minWidth: double.infinity,
                    color: Colors.black,
                    onPressed: canResendEmail ? sendVerificationEmail : () {},
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          7.0), // Adjust radius as desired
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 17),
                      child: Text(
                        'Resend Email',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Gap(15.h),
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen()),
                          (route) => false);
                      FirebaseAuth.instance.signOut();
                    },
                    child: Text(
                      'Not your email.',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17.sp,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
