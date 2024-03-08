import 'package:assignment/src/display/screens/verify_otp_screen.dart';
import 'package:assignment/src/domain/helpers/shared_preference_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/constants/app_constants.dart';
import '../../domain/constants/asset_constants.dart';
import '../../domain/repos.dart';
import '../../signup_screen.dart';
import '../components/custom_snackbar/custom_snackbar.dart';
import 'main_screen.dart';

class SignupPhoneScreen extends StatefulWidget {
  const SignupPhoneScreen({super.key});

  @override
  State<SignupPhoneScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupPhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  FocusNode _phoneFocusNode = FocusNode();
  bool isLoading = false;
  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();

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
            'Sign Up!',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24.sp,
              height: 1.2,
            ),
          ),
          Gap(5.h),
          Text(
            'Signup using your phone number.',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                height: 1.4,
                color: Color(0xd2424242)),
          ),
          Gap(15.h),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color:
                    _phoneFocusNode.hasFocus ? Colors.black87 : Colors.black12,
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
              child: IntrinsicHeight(
                  child: Row(
                children: [
                  Image.asset(
                    Assets.icons.india,
                    width: 20,
                  ),
                  Text(
                    '  +91',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 10),
                    child: VerticalDivider(
                      color: Colors.black26,
                      width: 0.7,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      focusNode: _phoneFocusNode,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s")),
                        LengthLimitingTextInputFormatter(10),
                      ],
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: '9876543210',
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                          fontSize: 0.017.sh,
                        ),
                      ),
                    ),
                  )
                ],
              )),
            ),
          ),
          Gap(20.h),
          MaterialButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              if (_phoneController.text.trim().isEmpty ||
                  _phoneController.text.trim().length != 10) {
                ScaffoldMessenger.of(context).clearSnackBars();
                customErrorSnackBarMsg(
                    time: 2,
                    text: 'Please, enter a valid mobile number.',
                    context: context);
              } else {
                try {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: '+91${_phoneController.text.trim()}',
                      verificationCompleted:
                          (PhoneAuthCredential phoneAuthCredential) async {
                        phoneAuthCredential.smsCode;
                        User? user = (await FirebaseAuth.instance
                                .signInWithCredential(phoneAuthCredential))
                            .user;

                        if (user != null) {
                          // userID is stored to a variable and then saved to shared preference
                          SharedPreferences sp =
                              await SharedPreferences.getInstance();
                          sp.setString(AppConstant.spUserID, user.uid);
                          sp.setInt(AppConstant.spPhone,
                              int.parse(_phoneController.text.trim()));
                          // now we check if the user exists or not in FireStore
                          SharedPreferencesHelper.setIsLogin(true);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainScreen()),
                              (route) => false);
                        }
                      },
                      verificationFailed: (FirebaseAuthException error) {
                        if (error.code == 'network-request-failed') {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          customErrorSnackBarMsg(
                              time: 2, text: '${error.code}', context: context);

                          throw Exception(error.message);
                        }
                      },
                      codeSent: (verificationCode, forceResendingToken) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (
                              context,
                            ) =>
                                VerifyOTPScreen(
                              phone: _phoneController.text.trim(),
                              verificationCode: verificationCode,
                            ),
                          ),
                        );
                      },
                      codeAutoRetrievalTimeout: (verificationCode) {});
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
                    'Send OTP',
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
