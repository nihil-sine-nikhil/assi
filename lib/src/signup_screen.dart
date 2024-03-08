import 'dart:async';

import 'package:assignment/src/display/screens/login/login_screen.dart';
import 'package:assignment/src/domain/repos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'display/components/custom_snackbar/custom_snackbar.dart';
import 'display/components/custom_textfield/custom_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
            Gap(20.h),
            MaterialButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim());
                } on FirebaseAuthException catch (e) {
                  logger.e(e);
                  ScaffoldMessenger.of(context).clearSnackBars();
                  customErrorSnackBarMsg(
                      time: 2, text: e.toString(), context: context);
                }
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainPage()));
              },
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(7.0), // Adjust radius as desired
              ),
              padding: EdgeInsets.symmetric(vertical: 11.h),
              color: Colors.black,
              child: Text(
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
          Gap(15.h),
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
  const VerifyEmailPage({super.key});

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
    if (isEmailVerified) timer?.cancel();
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
  Widget build(BuildContext context) => isEmailVerified
      ? HomePage()
      : Scaffold(
          appBar: AppBar(
            title: Text('Verify Email'),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text('A verification email has been sent to your email'),
                SizedBox(
                  height: 24,
                ),
                ElevatedButton.icon(
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                  icon: Icon(
                    Icons.email,
                    size: 32,
                  ),
                  label: Text('Resend Email'),
                ),
                SizedBox(
                  height: 24,
                ),
                ElevatedButton.icon(
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  icon: Icon(
                    Icons.email,
                    size: 32,
                  ),
                  label: Text('Sign out'),
                )
              ],
            ),
          ),
        );
}
