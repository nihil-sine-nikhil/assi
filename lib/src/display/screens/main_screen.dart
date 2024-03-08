import 'package:assignment/src/data/blocs/users/user_bloc.dart';
import 'package:assignment/src/display/screens/add_new_user/add_new_user_screen.dart';
import 'package:assignment/src/display/screens/change_user_position_screen.dart';
import 'package:assignment/src/display/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/helpers/shared_preference_helper.dart';
import '../../signup_screen.dart';
import '../disable_login_access_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenNotch = MediaQuery.paddingOf(context).top;
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
              bottom: 25.h,
              left: 17.w,
              right: 17.w,
            ),
            child: MaterialButton(
              onPressed: () async {
                SharedPreferencesHelper.logout();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignupScreen()),
                    (route) => false);
              },
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(7.0), // Adjust radius as desired
              ),
              padding: EdgeInsets.symmetric(vertical: 14.h),
              color: Colors.red,
              child: Text(
                'Log Out',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          appBar: PreferredSize(
              preferredSize: Size(screenWidth, 50.h + screenNotch),
              child: SizedBox(
                width: screenWidth,
                height: 50.h + screenNotch,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Color(0x2d858484), width: 1))),
                  child: Padding(
                    padding: EdgeInsets.only(top: screenNotch),
                    child: Center(
                      child: Text(
                        'Home Screen',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              )),
          body: state is UserStateLoaded
              ? Column(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeUserPositionScreen(
                                    usersList:
                                        state.usersListResponse.usersList)));
                      },
                      child: Text(
                        'Change user positions screen',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17.sp,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddNewUserScreen()));
                      },
                      child: Text(
                        'Add new user',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17.sp,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DisableLoginAccessScreen(
                                    usersList:
                                        state.usersListResponse.usersList)));
                      },
                      child: Text(
                        'Disable Login Access',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17.sp,
                        ),
                      ),
                    ),
                  ],
                )
              : CustomCircularIndicator(),
        );
      },
    );
  }
}
