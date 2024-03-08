part of 'auth_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticationStatusChangedEvent extends AuthenticationEvent {}

class AuthenticationPhoneNumberChangedEvent extends AuthenticationEvent {
  final String phoneNumber;
  const AuthenticationPhoneNumberChangedEvent(this.phoneNumber);
  @override
  List<Object?> get props => [phoneNumber];
}

class AuthenticationOTPChangedEvent extends AuthenticationEvent {
  final String otp;
  const AuthenticationOTPChangedEvent(this.otp);
  @override
  List<Object?> get props => [otp];
}

class AuthenticationLoginSubmittedEvent extends AuthenticationEvent {
  final String phoneNumber;
  final BuildContext context;
  const AuthenticationLoginSubmittedEvent(this.phoneNumber, this.context);
  @override
  List<Object?> get props => [phoneNumber, context];
}

class AuthenticationResendOTPEvent extends AuthenticationEvent {
  final String phoneNumber;
  final BuildContext context;
  const AuthenticationResendOTPEvent(this.phoneNumber, this.context);
  @override
  List<Object?> get props => [phoneNumber, context];
}

class AuthenticationOTPVerificationSubmittedEvent extends AuthenticationEvent {
  final String otp;
  final String verificationID;
  final BuildContext context;

  const AuthenticationOTPVerificationSubmittedEvent(
      this.otp, this.verificationID, this.context);
  @override
  List<Object?> get props => [otp, context];
}
