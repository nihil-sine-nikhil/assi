import 'package:assignment/src/domain/helpers/shared_preference_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';

import '../../../domain/repos.dart';
import '../../components/custom_snackbar/custom_snackbar.dart';
import '../home/main_screen.dart';

class EnterOTPScreen extends StatefulWidget {
  const EnterOTPScreen(
      {super.key, required this.verificationCode, required this.phone});
  final String verificationCode;
  final String phone;
  @override
  State<EnterOTPScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<EnterOTPScreen> {
  final TextEditingController _otpEC = TextEditingController();

  bool isLoading = false;
  @override
  void dispose() {
    _otpEC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenNotch = MediaQuery.paddingOf(context).top;
    return Scaffold(
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
            'Verify Phone number!',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24.sp,
              height: 1.2,
            ),
          ),
          Gap(5.h),
          Text(
            'Enter the OTP sent to your phone.',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                height: 1.4,
                color: Color(0xd2424242)),
          ),
          Gap(15.h),
          Pinput(
            autofocus: true,
            controller: _otpEC,
            length: 6,
            showCursor: true,
            defaultPinTheme: PinTheme(
              height: 65,
              width: 55,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12, width: 1.5),
                borderRadius: BorderRadius.circular(
                  5,
                ),
              ),
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            onChanged: (value) {},
            focusedPinTheme: PinTheme(
              height: 65,
              width: 55,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black87, width: 1.5),
                borderRadius: BorderRadius.circular(
                  5,
                ),
              ),
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Gap(20.h),
          MaterialButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              if (_otpEC.text.trim().isEmpty ||
                  _otpEC.text.trim().length != 6) {
                ScaffoldMessenger.of(context).clearSnackBars();
                customErrorSnackBarMsg(
                    time: 2,
                    text: 'Please, enter a valid OTP.',
                    context: context);
              } else {
                try {
                  PhoneAuthCredential cred = PhoneAuthProvider.credential(
                      verificationId: widget.verificationCode!,
                      smsCode: _otpEC.text.trim());
                  User? user =
                      (await FirebaseAuth.instance.signInWithCredential(cred))
                          .user;

                  if (user != null) {
                    SharedPreferencesHelper.setIsLogin(true);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()),
                        (route) => false);
                  }
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
                    'Verify OTP',
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
