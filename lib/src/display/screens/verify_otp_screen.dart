import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../data/blocs/auth_bloc/auth_bloc.dart';
import '../../domain/constants/ui_constants.dart';
import '../components/custom_snackbar/custom_snackbar.dart';
import 'enter_phone_number_screen.dart';

// ignore: must_be_immutable
class VerifyOTPScreen extends StatefulWidget {
  const VerifyOTPScreen({Key? key, this.verificationCode, this.phone})
      : super(key: key);
  final String? verificationCode;
  final String? phone;

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  final TextEditingController _otpEC = TextEditingController();
  //TODO: Remember to dispose TextEditing controllers from all screens

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationOTPVerifiedFailedState) {
          customErrorSnackBarMsg(time: 3, text: state.msg, context: context);
        }
        if (state is AuthenticationOTPResentSuccessfulState) {
          customSnackBarMsg(time: 3, text: state.msg, context: context);
        }
        if (state is AuthenticationOTPResentFailedState) {
          customErrorSnackBarMsg(time: 3, text: state.msg, context: context);
        }
      },
      builder: (context, state) {
        final _bloc = context.read<AuthenticationBloc>();
        return IgnorePointer(
          ignoring:
              (state is AuthenticationOTPVerificationSubmittedLoadingState) ||
                      (state is AuthenticationResendOTPLoadingState)
                  ? true
                  : false,
          child: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          size: 40,
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Row(
                        children: [
                          poppinsText(
                            txt: 'Enter',
                            fontSize: 25,
                            weight: FontWeight.w600,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: poppinsText(
                              txt: 'OTP',
                              fontSize: 23,
                              weight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Pinput(
                        autofocus: true,
                        controller: _otpEC,
                        length: 6,
                        showCursor: true,
                        defaultPinTheme: PinTheme(
                          height: 65,
                          width: 55,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                          ),
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // onCompleted: (value) {
                        //   if (state is AuthenticationOTPValidState) {
                        //     _bloc.add(
                        //         AuthenticationOTPVerificationSubmittedEvent(
                        //             _otpEC.text,
                        //             widget.verificationCode ?? ""));
                        //   } else {
                        //     CustomErrorSnackBarMsg(
                        //         time: 3,
                        //         text: "Enter a valid 6 digit OTP.",
                        //         context: context);
                        //   }
                        // },
                        onChanged: (value) {
                          _bloc.add(AuthenticationOTPChangedEvent(_otpEC.text));
                        },
                        focusedPinTheme: PinTheme(
                          height: 65,
                          width: 55,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                          ),
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          poppinsText(
                            txt: 'OTP sent to your phone',
                            fontSize: 13,
                            weight: FontWeight.w400,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              _bloc.add(AuthenticationResendOTPEvent(
                                  widget.phone ?? "", context));
                            },
                            child: Text(
                              "Resend OTP",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
                      MaterialButton(
                        height: 65,
                        minWidth: double.infinity,
                        color: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        child:
                            (state is AuthenticationOTPVerificationSubmittedLoadingState) ||
                                    (state
                                        is AuthenticationResendOTPLoadingState)
                                ? const JumpingDots()
                                : poppinsText(
                                    txt: "Verify",
                                    fontSize: 17,
                                    weight: FontWeight.w600,
                                  ),
                        onPressed: () {
                          if (state is AuthenticationOTPValidState) {
                            _bloc.add(
                                AuthenticationOTPVerificationSubmittedEvent(
                                    _otpEC.text,
                                    widget.verificationCode ?? "",
                                    context));
                          } else {
                            customErrorSnackBarMsg(
                                time: 3,
                                text: "Enter a valid 6 digit OTP.",
                                context: context);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _otpEC.dispose(); // TODO: implement dispose
    super.dispose();
  }
}
