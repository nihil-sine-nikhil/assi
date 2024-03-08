import 'package:assignment/src/display/screens/add_new_user/add_new_user_screen.dart';
import 'package:assignment/src/display/screens/change_user_position_screen.dart';
import 'package:assignment/src/display/screens/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../data/models/users_model.dart';
import '../../domain/helpers/shared_preference_helper.dart';
import '../../signup_screen.dart';
import '../disable_login_access_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var fbStream = FirebaseFirestore.instance.collection('users').snapshots();

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
        child: MaterialButton(
          onPressed: () async {
            SharedPreferencesHelper.logout();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SignupScreen()),
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
                      bottom: BorderSide(color: Color(0x2d858484), width: 1))),
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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: fbStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CustomCircularIndicator();
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            }
            if (snapshot.hasData) {
              List<UserModel> dataList = [];
              for (var e in snapshot.data!.docs) {
                Map<String, dynamic> user = e.data();
                var data = UserModel.fromMap(user);
                data.documentID = e.id;
                dataList.add(data);
              }
              return Column(
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangeUserPositionScreen(
                                  usersList: dataList)));
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
                                  usersList: dataList)));
                    },
                    child: Text(
                      'Disable Login Access',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17.sp,
                      ),
                    ),
                  ),
                  ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> user =
                            snapshot.data!.docs[index].data();
                        var data = UserModel.fromMap(user);

                        return InkWell(
                          borderRadius: BorderRadius.circular(10),
                          splashColor: Color(0x1FADADAD),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.0,
                              vertical: 10.h,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.orangeAccent,
                                  backgroundImage:
                                      NetworkImage(data.profilePic),
                                ),
                                Gap(10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Fulll Name:  ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.sp,
                                            height: 1.2,
                                          ),
                                        ),
                                        Text(
                                          '${data.firstName} ${data.lastName}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.sp,
                                            height: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Gap(6.h),
                                    Row(
                                      children: [
                                        Text(
                                          'Role: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.sp,
                                            height: 1.2,
                                          ),
                                        ),
                                        Text(
                                          '${data.role}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.sp,
                                            height: 1.2,
                                          ),
                                        ),
                                        Gap(15.w),
                                        Text(
                                          'Login Access: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.sp,
                                            height: 1.2,
                                          ),
                                        ),
                                        Text(
                                          '${data.canLogin ? "Active" : "Restricted"}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.sp,
                                            color: data.canLogin
                                                ? Colors.green
                                                : Colors.red,
                                            height: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              );
            }
            return const CustomCircularIndicator();
          }),
    );
  }
}
