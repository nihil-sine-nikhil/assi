import 'package:assignment/src/data/blocs/users/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../data/models/users_model.dart';
import '../../components/circular_progress_indicator/circular_progress_indicator.dart';
import '../add_new_user/add_new_user_screen.dart';
import '../edit_user_details/edit_user_details_screen.dart';

class ChangeUserPositionScreen extends StatefulWidget {
  const ChangeUserPositionScreen({super.key, required this.usersList});
  final List<UserModel> usersList;
  @override
  State<ChangeUserPositionScreen> createState() =>
      _ChangeUserPositionScreenState();
}

class _ChangeUserPositionScreenState extends State<ChangeUserPositionScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> allList = [];

  bool isSelectItem = false;
  Map<int, bool> selectedItem = {};
  bool isLoading = false;

  selectAllAtOnceGo() {
    bool isFalseAvailable = selectedItem.containsValue(false);
    selectedItem.updateAll((key, value) => isFalseAvailable);
    setState(() {
      isSelectItem = selectedItem.containsValue(true);
    });
  }

  @override
  void initState() {
    super.initState();
    allList.addAll(widget.usersList);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenNotch = MediaQuery.paddingOf(context).top;
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserStateLoaded) {
          return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (
                      context,
                    ) =>
                        AddNewUserScreen(),
                  ),
                );
                // selectAllAtOnceGo();
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: double.infinity,
                height: isSelectItem ? 55.h : 0,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black),
                    child: Center(
                      child: Text(
                        'Save changes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
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
                          'Change user position',
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
                Text(
                  'Select the user you want to change position for',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24.sp,
                    height: 1.2,
                  ),
                ),
                Gap(5.h),
                Text(
                  'Tap the edit button to update User details.',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      height: 1.2,
                      color: Colors.black54),
                ),
                Gap(15.h),
                DecoratedBox(
                  decoration: BoxDecoration(
                      color: Color(0x10949494),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 3),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) {
                        widget.usersList.clear();
                        if (v.isNotEmpty) {
                          widget.usersList.addAll(allList.where((element) =>
                              element.firstName!.toLowerCase().contains(
                                  _searchController.text.toLowerCase()) ||
                              element.lastName!.toLowerCase().contains(
                                  _searchController.text.toLowerCase())));
                        } else {
                          widget.usersList.addAll(allList);
                        }

                        setState(() {});
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black87,
                        ),
                        hintText: 'Search by name',
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                          fontSize: 0.017.sh,
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(15.h),
                if (widget.usersList.isNotEmpty)
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.usersList.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        UserModel data = widget.usersList[index];

                        return InkWell(
                          borderRadius: BorderRadius.circular(10),
                          splashColor: Color(0x1FADADAD),
                          // onLongPress: () {
                          //   setState(() {
                          //     selectedItem[index] = !isSelectedData;
                          //     isSelectItem = selectedItem.containsValue(true);
                          //   });
                          // },
                          onTap: () {
                            // if (isSelectItem) {
                            //   setState(() {
                            //     selectedItem[index] = !isSelectedData;
                            //     isSelectItem = selectedItem.containsValue(true);
                            //   });
                            // } else {
                            //   // Open Detail Page
                            // }

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditUserDetailsScreen(
                                          user: data,
                                        )));
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.0,
                              vertical: 10.h,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
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
                                    Text(
                                      '${data.firstName} ${data.lastName}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp,
                                        height: 1.2,
                                      ),
                                    ),
                                    Text(
                                      data.role,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Text(
                                  'Edit  ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    height: 1.2,
                                  ),
                                ),
                                Icon(Icons.edit_note)
                              ],
                            ),
                          ),
                        );
                      })
                else if (widget.usersList.isEmpty && isLoading == false)
                  Center(
                    child: Text("No Data"),
                  )
                else
                  Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        }
        return Scaffold(body: CustomCircularIndicator());
      },
    );
  }
}
