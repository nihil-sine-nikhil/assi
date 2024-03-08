part of 'auth_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationUnknownState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationLoggedInState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationAdminLoggedInState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationPhoneNumberValidState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationOTPValidState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationPhoneSubmittedLoadingState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationResendOTPLoadingState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationOTPVerificationSubmittedLoadingState
    extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationOTPSentSuccessfulState extends AuthenticationState {
  const AuthenticationOTPSentSuccessfulState(this.msg);
  final String msg;
  @override
  List<Object> get props => [msg];
}

class AuthenticationOTPResentSuccessfulState extends AuthenticationState {
  const AuthenticationOTPResentSuccessfulState(this.msg);
  final String msg;
  @override
  List<Object> get props => [msg];
}

class AuthenticationOTPVerifiedSuccessfulState extends AuthenticationState {
  const AuthenticationOTPVerifiedSuccessfulState(this.msg);
  final String msg;
  @override
  List<Object> get props => [msg];
}

class AuthenticationOTPVerifiedFailedState extends AuthenticationState {
  const AuthenticationOTPVerifiedFailedState(this.msg);
  final String msg;
  @override
  List<Object> get props => [msg];
}

class AuthenticationOTPSentFailedState extends AuthenticationState {
  const AuthenticationOTPSentFailedState(this.msg);
  final String msg;

  @override
  List<Object> get props => [msg];
}

class AuthenticationOTPResentFailedState extends AuthenticationState {
  const AuthenticationOTPResentFailedState(this.msg);
  final String msg;

  @override
  List<Object> get props => [msg];
}

class AuthenticationPhoneNumberInvalidState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationOTPInvalidState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationLoginSuccessfulState extends AuthenticationState {
  @override
  List<Object> get props => [];
}
