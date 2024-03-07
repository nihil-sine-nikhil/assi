import 'package:assignment/src/data/blocs/users/user_bloc.dart';
import 'package:assignment/src/data/models/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../domain/constants/asset_constants.dart';
import '../../../domain/constants/ui_constants.dart';
import '../../components/custom_bottom_sheet/custom_bottom_sheet.dart';
import '../../components/custom_snackbar/custom_snackbar.dart';
import '../../components/custom_textfield/custom_textfield.dart';
import '../users_list/users_list_screen.dart';

class AddNewUserScreen extends StatefulWidget {
  const AddNewUserScreen({super.key});

  @override
  State<AddNewUserScreen> createState() => _AddNewUserScreenState();
}

class _AddNewUserScreenState extends State<AddNewUserScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedUserRole = 'Assign to an office';
  String _selectedUserTeam = 'Select a role (Closer, Setter or Manager)';
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenNotch = MediaQuery.paddingOf(context).top;
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        print('state is ${state}');
        if (state is UserStateUpdateSuccesful) {
          print('sxxxxxx ${state}');
          ScaffoldMessenger.of(context).clearSnackBars();
          customSnackBarMsg(
              time: 2, text: state.customResponse.msg, context: context);

          if (state is UserStateUpdateFailed) {
            ScaffoldMessenger.of(context).clearSnackBars();
            customErrorSnackBarMsg(
                time: 2, text: state.customResponse.msg, context: context);
          }
          userBloc.add(UserEventFetchAll());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (
                context,
              ) =>
                  UsersListScreen(),
            ),
          );
        }
      },
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            bottom: 25.h,
            left: 17.w,
            right: 17.w,
          ),
          child: MaterialButton(
            onPressed: () {
              print('niisdsid');
              // print('state is ${userBloc.state}');
              userBloc.add(UserEventAddUser(
                  userModel: UserModel(
                      phone: _emailController.text.trim(),
                      email: _emailController.text.trim(),
                      canLogin: true,
                      firstName: _firstNameController.text.trim(),
                      lastName: _lastNameController.text.trim(),
                      profilePic: '',
                      role: _selectedUserRole,
                      team: _selectedUserTeam,
                      createdOn: FieldValue.serverTimestamp(),
                      updatedOn: FieldValue.serverTimestamp())));
            },
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(7.0), // Adjust radius as desired
            ),
            padding: EdgeInsets.symmetric(vertical: 11.h),
            color: Colors.black,
            child: Text(
              'Send invite',
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
                      'Add new user',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17.sp,
                      ),
                    ),
                  ),
                ),
              ),
            )),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 10.h),
          children: [
            Text(
              'We will send a welcome email to the new user with a download link to the app.',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17.sp,
                height: 1.2,
              ),
            ),
            Gap(5.h),
            Text(
              'Once they register you will be able to see them on your user list.',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                height: 1.2,
              ),
            ),
            Gap(15.h),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hint: 'John',
                    title: 'First name',
                    controller: _firstNameController,
                    textInputType: TextInputType.text,
                  ),
                ),
                Gap(15.w),
                Expanded(
                  child: CustomTextField(
                    hint: 'Doe',
                    title: 'Last name',
                    controller: _lastNameController,
                    textInputType: TextInputType.text,
                  ),
                ),
              ],
            ),
            Gap(13.h),
            CustomTextField(
              hint: 'johndoe@email.com',
              title: 'Email address',
              controller: _emailController,
              textInputType: TextInputType.emailAddress,
            ),
            Gap(15.h),
            Text(
              'Phone number',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
                color: Colors.black87,
              ),
            ),
            Gap(3.h),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.black12,
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
                        controller: _emailController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          FilteringTextInputFormatter.deny(
                              RegExp(r"\s\b|\b\s")),
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
            Gap(15.h),
            Text(
              'Team',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
                color: Colors.black87,
              ),
            ),
            Gap(3.h),
            GestureDetector(
              onTap: () {
                titleBottomSheet(
                  context: context,
                  title: 'Select a Team',
                  widget:
                      StatefulBuilder(builder: (context, bottomSheetSetState) {
                    return Column(
                      children: [
                        ...userTeamList.map(
                          (team) => GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              bottomSheetSetState(() {
                                if (_selectedUserTeam == team) {
                                  setState(() {
                                    Navigator.pop(context);
                                  });

                                  return;
                                } else {
                                  _selectedUserTeam = team;
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: _selectedUserTeam == team
                                            ? Colors.black87
                                            : Colors.black12,
                                        width: 1)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, top: 5, bottom: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        team,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Spacer(),
                                      IgnorePointer(
                                        child: Radio(
                                          activeColor: Colors.black,
                                          value: team,
                                          groupValue: _selectedUserTeam,
                                          onChanged: (_) {},
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Gap(10.h),
                      ],
                    );
                  }),
                );
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.black12,
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Text(
                        _selectedUserTeam,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                          fontSize: 0.017.sh,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black54,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Gap(15.h),
            Text(
              'Role',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
                color: Colors.black87,
              ),
            ),
            Gap(3.h),
            GestureDetector(
              onTap: () {
                titleBottomSheet(
                  context: context,
                  title: 'Change Position',
                  widget:
                      StatefulBuilder(builder: (context, bottomSheetSetState) {
                    return Column(
                      children: [
                        ...userRoleList.map(
                          (role) => GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              bottomSheetSetState(() {
                                if (_selectedUserRole == role) {
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                } else {
                                  _selectedUserRole = role;
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: _selectedUserRole == role
                                            ? Colors.black87
                                            : Colors.black12,
                                        width: 1)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, top: 5, bottom: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        role,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Spacer(),
                                      IgnorePointer(
                                        child: Radio(
                                          activeColor: Colors.black,
                                          value: role,
                                          groupValue: _selectedUserRole,
                                          onChanged: (_) {},
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Gap(10.h),
                      ],
                    );
                  }),
                );
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.black12,
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Text(
                        _selectedUserRole,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                          fontSize: 0.017.sh,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black54,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
