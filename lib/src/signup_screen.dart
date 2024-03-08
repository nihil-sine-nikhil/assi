import 'dart:async';

import 'package:assignment/src/display/screens/login/login_screen.dart';
import 'package:assignment/src/display/screens/main_screen.dart';
import 'package:assignment/src/domain/helpers/shared_preference_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'display/components/custom_snackbar/custom_snackbar.dart';
import 'display/components/custom_textfield/custom_textfield.dart';
import 'domain/repos.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  'Already a user? Login',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Gap(10.h),
            MaterialButton(
              onPressed: () async {},
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(7.0), // Adjust radius as desired
              ),
              padding: EdgeInsets.symmetric(vertical: 11.h),
              color: Colors.black,
              child: Text(
                'Sign up with Phone',
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
            'Welcome Here!',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24.sp,
              height: 1.2,
            ),
          ),
          Gap(5.h),
          Text(
            'Signup using your email address and password.',
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
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
                    'Sign up',
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

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
          body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return VerifyEmailPage();
          } else {
            return AuthPage();
          }
        },
      ));
}

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

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
