import 'dart:io';

import 'package:assignment/src/display/screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../data/blocs/users/user_bloc.dart';
import '../data/models/users_model.dart';
import '../domain/constants/asset_constants.dart';
import '../domain/constants/ui_constants.dart';
import 'components/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'components/custom_snackbar/custom_snackbar.dart';
import 'components/custom_textfield/custom_textfield.dart';
import 'components/image_picker/image_picker.dart';

class EditUserDetailsScreen extends StatefulWidget {
  const EditUserDetailsScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<EditUserDetailsScreen> createState() => _EditUserDetailsScreenState();
}

class _EditUserDetailsScreenState extends State<EditUserDetailsScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedUserRole = 'Assign to an office';
  String _selectedLoginAccess = loginAccessList.first;
  String _selectedUserTeam = 'Select a role (Closer, Setter or Manager)';
  File? image;
  FocusNode _phoneFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _selectedLoginAccess = widget.user.canLogin ? 'Active' : "Restricted";
    _firstNameController.text = widget.user.firstName;
    _lastNameController.text = widget.user.lastName;
    _phoneController.text = widget.user.phone;
    _emailController.text = widget.user.email;
    _selectedUserRole = widget.user.role;
    _selectedUserTeam = widget.user.team;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _phoneFocusNode.dispose();

    super.dispose();
  }

  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
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
                  MainScreen(),
            ),
          );
        }
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return IgnorePointer(
            ignoring: state is UserStateLoading ? true : false,
            child: Scaffold(
              bottomNavigationBar: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                margin: EdgeInsets.only(
                  bottom: 25.h,
                  left: state is UserStateLoading ? 90.w : 17.w,
                  right: state is UserStateLoading ? 90.w : 17.w,
                ),
                height: 50.h,
                child: MaterialButton(
                  onPressed: () {
                    if (_firstNameController.text.trim().isEmpty ||
                        _lastNameController.text.trim().isEmpty ||
                        _emailController.text.trim().isEmpty ||
                        _phoneController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      customErrorSnackBarMsg(
                          time: 2,
                          text: 'Please, enter all the details above',
                          context: context);
                    } else if (_phoneController.text.trim().length != 10) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      customErrorSnackBarMsg(
                          time: 2,
                          text: 'Enter a valid mobile number.',
                          context: context);
                    } else if (_selectedUserTeam ==
                            'Select a role (Closer, Setter or Manager)' ||
                        _selectedUserRole == 'Assign to an office') {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      customErrorSnackBarMsg(
                          time: 2,
                          text: 'Must select both a Team and a Role.',
                          context: context);
                    } else {
                      userBloc.add(UserEventUpdate(
                          userModel: UserModel(
                              documentID: widget.user.documentID,
                              phone: _phoneController.text.trim(),
                              email: _emailController.text.trim(),
                              canLogin: _selectedLoginAccess == 'Active'
                                  ? true
                                  : false,
                              firstName: _firstNameController.text.trim(),
                              lastName: _lastNameController.text.trim(),
                              profilePic: widget.user.profilePic,
                              role: _selectedUserRole,
                              team: _selectedUserTeam,
                              createdOn: FieldValue.serverTimestamp(),
                              updatedOn: FieldValue.serverTimestamp()),
                          profilePic: image));
                    }
                  },
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(7.0), // Adjust radius as desired
                  ),
                  padding: EdgeInsets.symmetric(vertical: 11.h),
                  color: Colors.black,
                  child: state is UserStateLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Update User',
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
                    child: Padding(
                      padding: EdgeInsets.only(top: screenNotch, left: 17.w),
                      child: Row(
                        children: [
                          Expanded(
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
                              ),
                            ),
                          ),
                          Text(
                            'Update user details',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17.sp,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  )),
              body: ListView(
                padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 10.h),
                children: [
                  Gap(5.h),
                  (image == null)
                      ? GestureDetector(
                          onTap: selectImage,
                          child: Column(
                            children: [
                              CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(widget.user.profilePic),
                                  backgroundColor: Color(0x38868686),
                                  radius: 38),
                              Text(
                                'Change',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.sp,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            CircleAvatar(
                                backgroundImage: FileImage(image!),
                                backgroundColor: Color(0x38868686),
                                radius: 38),
                            Gap(7.h),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  image = null;
                                });
                              },
                              child: Text(
                                'Remove',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.sp,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                  Gap(15.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          autofocus: true,
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
                        color: _phoneFocusNode.hasFocus
                            ? Colors.black87
                            : Colors.black12,
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
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]")),
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
                        widget: StatefulBuilder(
                            builder: (context, bottomSheetSetState) {
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
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                fontWeight: _selectedUserTeam ==
                                        'Select a role (Closer, Setter or Manager)'
                                    ? FontWeight.w400
                                    : FontWeight.w500,
                                color: _selectedUserTeam ==
                                        'Select a role (Closer, Setter or Manager)'
                                    ? Colors.grey
                                    : Colors.black,
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
                        widget: StatefulBuilder(
                            builder: (context, bottomSheetSetState) {
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
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                fontWeight:
                                    _selectedUserRole == 'Assign to an office'
                                        ? FontWeight.w400
                                        : FontWeight.w500,
                                color:
                                    _selectedUserRole == 'Assign to an office'
                                        ? Colors.grey
                                        : Colors.black,
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
                    'Login Access',
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
                        title: 'Update login access',
                        widget: StatefulBuilder(
                            builder: (context, bottomSheetSetState) {
                          return Column(
                            children: [
                              ...loginAccessList.map(
                                (role) => GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    bottomSheetSetState(() {
                                      if (_selectedLoginAccess == role) {
                                        setState(() {
                                          Navigator.pop(context);
                                        });
                                      } else {
                                        _selectedLoginAccess = role;
                                        setState(() {
                                          Navigator.pop(context);
                                        });
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color:
                                                  _selectedLoginAccess == role
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
                                                  color: role == 'Restricted'
                                                      ? Colors.red
                                                      : Colors.black),
                                            ),
                                            Spacer(),
                                            IgnorePointer(
                                              child: Radio(
                                                activeColor: Colors.black,
                                                value: role,
                                                groupValue:
                                                    _selectedLoginAccess,
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
                              _selectedLoginAccess,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: _selectedLoginAccess == 'Restricted'
                                    ? Colors.red
                                    : Colors.black,
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
