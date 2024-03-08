import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../services/auth_services.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  late final AuthenticationServices _authServices;

  AuthenticationBloc({required AuthenticationServices authServices})
      : _authServices = authServices,
        super(AuthenticationInitial()) {
    on<AuthenticationStatusChangedEvent>((event, emit) async {
      final res = await _authServices.checkSignedIn();
      if (res.first) {
        if (res[1]) {
          emit(AuthenticationAdminLoggedInState());
        } else {
          emit(AuthenticationLoggedInState());
        }
      } else {
        emit(AuthenticationUnknownState());
      }
    });

    /// start of PHONE NUMBER SEND OTP
    on<AuthenticationPhoneNumberChangedEvent>((event, emit) {
      if (event.phoneNumber.length == 10) {
        emit(AuthenticationPhoneNumberValidState());
      } else {
        emit(AuthenticationPhoneNumberInvalidState());
      }
    });

    on<AuthenticationLoginSubmittedEvent>((event, emit) async {
      emit(AuthenticationPhoneSubmittedLoadingState());
      final _response =
          await _authServices.signInWithPhone(event.phoneNumber, event.context);
      if (_response.status) {
        emit(AuthenticationOTPSentSuccessfulState(_response.msg ?? "NA"));
      } else if (!_response.status) {
        emit(AuthenticationOTPSentFailedState(
            _response.msg ?? "Something went wrong."));
      }
    });

    /// end of PHONE NUMBER SEND OTP

    /// start of OTP VERIFICATION
    on<AuthenticationOTPChangedEvent>((event, emit) {
      if (event.otp.length == 6) {
        emit(AuthenticationOTPValidState());
      } else {
        emit(AuthenticationOTPInvalidState());
      }
    });

    on<AuthenticationOTPVerificationSubmittedEvent>((event, emit) async {
      emit(AuthenticationOTPVerificationSubmittedLoadingState());
      final _response = await _authServices.verifyOTP(
          event.otp, event.verificationID, event.context);
      if (_response.status) {
        emit(AuthenticationOTPVerifiedSuccessfulState(_response.msg ?? "NA"));
      } else {
        emit(AuthenticationOTPVerifiedFailedState(
            _response.msg ?? "Something went wrong."));
      }
    });

    /// end of OTP VERIFICATION

    /// RESEND OTP
    on<AuthenticationResendOTPEvent>((event, emit) async {
      emit(AuthenticationResendOTPLoadingState());
      final _response = await _authServices.resendOTP(event.phoneNumber);
      if (_response) {
        emit(const AuthenticationOTPResentSuccessfulState("NA"));
      } else if (!_response) {
        emit(const AuthenticationOTPResentFailedState("Something went wrong."));
      }
    });

    /// end of RESEND OTP
  }
}
