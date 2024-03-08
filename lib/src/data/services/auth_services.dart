import 'dart:async';
import 'dart:io';

import 'package:assignment/src/display/screens/verify_otp_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../display/screens/main_screen.dart';
import '../../domain/constants/app_constants.dart';
import '../models/firestore_response_models/generic_response_model.dart';

class AuthenticationServices {
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  final FirebaseAuth _fbAuth = FirebaseAuth.instance;
  String? _uid;
  String? get uid => _uid;
  final FirebaseStorage _fbStorage = FirebaseStorage.instance;
  final FirebaseFirestore _fbFireStore = FirebaseFirestore.instance;

  Future<bool> checkWhetherAdmin() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String? _uid = sp.getString(AppConstant.spUserID);

      var adminsList = await listOfAdmins();

      if (adminsList!.contains(_uid)) {
        return true;
      } else {
        return false;
      }
      return false;
    } catch (e, substack) {
      print(e.toString());
      print(substack.toString());
      return false;
    }
  }

  /// CHECKING WHETHER SIGNED IN OR NOT
  Future<List> checkSignedIn() async {
    final SharedPreferences _sharedPref = await SharedPreferences.getInstance();
    if (_sharedPref.getBool(AppConstant.spIsSignedIn) == true) {
      if (_sharedPref.getBool(AppConstant.spIsAdmin) == true) {
        return [true, true];
      } else {
        return [true, false];
      }
    }
    return [false, false];
  }

  Future setSignin({required bool isAdmin}) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool(AppConstant.spIsSignedIn, true);
    sp.setBool(AppConstant.spIsAdmin, isAdmin);

    _isSignedIn = true;
  }

  Future<CustomResponse> signInWithPhone(
      String _phone, BuildContext context) async {
    CustomResponse _response =
        CustomResponse(status: true, msg: "OTP is sent to $_phone");
    Completer<CustomResponse> _completer = Completer<CustomResponse>();

    try {
      await _fbAuth.verifyPhoneNumber(
          phoneNumber: '+91$_phone',
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            phoneAuthCredential.smsCode;
            User? user =
                (await _fbAuth.signInWithCredential(phoneAuthCredential)).user;

            if (user != null) {
              // userID is stored to a variable and then saved to shared preference
              SharedPreferences sp = await SharedPreferences.getInstance();
              sp.setString(AppConstant.spUserID, user.uid);
              sp.setInt(AppConstant.spPhone, int.parse(_phone));
              // now we check if the user exists or not in FireStore
              setSignin(isAdmin: false);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                  (route) => false);
            } else {
              if (kDebugMode) {
                logger.e("User is null");
              }
            }
          },
          verificationFailed: (FirebaseAuthException error) {
            if (error.code == 'network-request-failed') {
              _response.status = false;
              _response.msg = 'Check your internet connection & try again.';
              _completer.complete(_response);
            } else {
              _response.status = false;
              _response.msg = 'The provided number is not valid.';
              print('kException 113 ${error.code}');
              print('kException 113 $error');

              _completer.complete(_response);
            }

            // TODO: unhandled exception here

            throw Exception(error.message);
          },
          codeSent: (verificationCode, forceResendingToken) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (
                  context,
                ) =>
                    VerifyOTPScreen(
                  phone: _phone,
                  verificationCode: verificationCode,
                ),
              ),
            );
          },
          codeAutoRetrievalTimeout: (verificationCode) {});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-phone-number') {
        _response.status = false;
        _response.msg = 'Oops! This phone number is not valid.';
        _completer.complete(_response);
      } else {
        _response.status = false;
        _response.msg = 'Something went wrong. Try again later.';
        print('kException 135 ${e.message}');
        _completer.complete(_response);
      }
    }
    return _completer.future;
  }

  Future<CustomResponse> verifyOTP(
      String _otp, String _verificationID, BuildContext context) async {
    CustomResponse _response =
        CustomResponse(status: true, msg: "OTP is successfully verified");
    // Completer<CustomResponse> _completer = Completer<CustomResponse>();

    try {
      PhoneAuthCredential cred = PhoneAuthProvider.credential(
          verificationId: _verificationID, smsCode: _otp);
      User? user = (await _fbAuth.signInWithCredential(cred)).user;
      if (user != null) {
        _uid = user.uid;
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString(AppConstant.spUserID, user.uid);
        sp.setInt(
            AppConstant.spPhone, int.parse((user.phoneNumber)!.substring(3)));
        setSignin(isAdmin: false);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
            (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        _response.status = false;
        _response.msg = "Oops! The OTP isn't valid. Try again!";
      } else if (e.code == 'invalid-verification-id') {
        _response.status = false;
        _response.msg = "Invalid verification ID";
      } else {
        print("kException 172 ${e.message}");
        print("kException 172 ${e.hashCode}");
        print("kException 172 ${e.code}");
        _response.status = false;
        _response.msg = '${e.message}';
        return _response;
      }
      // invalid-verification-id = he verification ID used to create the phone auth credential is invalid.
      // invalid-verification-code
      // The sms verification code used to create the phone auth credential is invalid. Please resend the verification code sms and be sure use the verification code provided by the user.
    }
    return _response;
  }

  /// RESEND OTP
  Future<bool> resendOTP(String _phone) async {
    await _fbAuth.verifyPhoneNumber(
        phoneNumber: '+91$_phone',
        verificationCompleted:
            (PhoneAuthCredential phoneAuthCredential) async {},
        verificationFailed: (error) {},
        codeSent: (verificationCode, forceResendingToken) {},
        codeAutoRetrievalTimeout: (verificationCode) {});

    return true;
  }

  /// END OF RESEND OTP

  ///

  Future<String> storeProfilePic(String ref, File file) async {
    UploadTask uploadTask = _fbStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future userSignOut() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    await _fbAuth.signOut();
  }

  /// INCREASE TOTAL NUMBERS OF USERS
  Future<int?> updatedUsersTotal() async {
    try {
      final snapshot = await _fbFireStore.collection('kpi').doc('kpi').get();
      var data = snapshot.data()!['totalUsers'];
      var updatedUsersTotal = data + 1;
      await _fbFireStore
          .collection("kpi")
          .doc("kpi")
          .update({'totalUsers': updatedUsersTotal}).catchError((error) {
        print('kError 348 $error');
      });
      return updatedUsersTotal;
    } catch (e) {
      print('kError 352 $e');
      return null;
    }
  }

  /// GET LIST OF USER ID OF ADMINS
  Future<List?> listOfAdmins() async {
    try {
      final snapshot =
          await _fbFireStore.collection('admins').doc('admins').get();
      var data = snapshot.data()!['uids'];
      List userIDs = data;

      return userIDs;
    } catch (e) {
      print('kError 352 $e');
      return null;
    }
  }
}
