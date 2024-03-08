import 'package:assignment/src/data/blocs/users/user_bloc.dart';
import 'package:assignment/src/display/screens/add_new_user/add_new_user_screen.dart';
import 'package:assignment/src/display/screens/change_user_position_screen.dart';
import 'package:assignment/src/display/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
