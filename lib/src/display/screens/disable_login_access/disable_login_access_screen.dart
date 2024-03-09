import 'package:assignment/src/data/blocs/users/user_bloc.dart';
import 'package:assignment/src/display/screens/add_new_user/add_new_user_screen.dart';
import 'package:assignment/src/display/screens/home/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../data/models/users_model.dart';
import '../../components/circular_progress_indicator/circular_progress_indicator.dart';
import '../../components/custom_snackbar/custom_snackbar.dart';

class DisableLoginAccessScreen extends StatefulWidget {
  const DisableLoginAccessScreen({super.key, required this.usersList});
  final List<UserModel> usersList;
  @override
  State<DisableLoginAccessScreen> createState() =>
      _DisableLoginAccessScreenState();
}

class _DisableLoginAccessScreenState extends State<DisableLoginAccessScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> allList = [];

  bool isSelectItem = false;
  Map<String, bool> selectedItem = {};
  bool isLoading = false;
  List<String> selectedDocumentedID = [];
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
    final userBloc = context.read<UserBloc>();

    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenNotch = MediaQuery.paddingOf(context).top;
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserStateUpdateSuccesful) {
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
          if (state is UserStateLoaded) {
            return IgnorePointer(
              ignoring: state is UserStateLoading ? true : false,
              child: Scaffold(
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
                    margin: EdgeInsets.only(
                      bottom: 15.h,
                      left: state is UserStateLoading ? 90.w : 17.w,
                      right: state is UserStateLoading ? 90.w : 17.w,
                    ),
                    height: isSelectItem ? 90.h : 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.black),
                            child: MaterialButton(
                              onPressed: () {
                                userBloc.add(UserEventUpdateLoginAccess(
                                    documentIDs: selectedDocumentedID,
                                    grantAccess: true));
                              },
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    7.0), // Adjust radius as desired
                              ),
                              color: Colors.black,
                              child: state is UserStateLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Grant access',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: isSelectItem ? 16.sp : 0,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.red),
                            child: MaterialButton(
                              onPressed: () {
                                userBloc.add(UserEventUpdateLoginAccess(
                                    documentIDs: selectedDocumentedID,
                                    grantAccess: false));
                              },
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    7.0), // Adjust radius as desired
                              ),
                              color: Colors.red,
                              child: state is UserStateLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Restrict',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: isSelectItem ? 16.sp : 0,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
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
                              'Disable user login',
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 17.w, vertical: 10.h),
                  children: [
                    Text(
                      'Select the user you want to enable/disable login access',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24.sp,
                        height: 1.2,
                      ),
                    ),
                    Gap(5.h),
                    Text(
                      'Long press to select multiple users at once.',
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
                            selectedItem?[data.documentID!] =
                                selectedItem?[data.documentID!] ?? false;
                            bool? isSelectedData =
                                selectedItem[data.documentID!];
                            return InkWell(
                              borderRadius: BorderRadius.circular(10),
                              splashColor: Color(0x1FADADAD),
                              onLongPress: () {
                                setState(() {
                                  selectedItem[data.documentID!] =
                                      !isSelectedData;

                                  isSelectItem =
                                      selectedItem.containsValue(true);
                                  if (isSelectItem) {
                                    selectedDocumentedID.add(data.documentID!);
                                  } else {
                                    selectedDocumentedID.removeWhere(
                                        (element) =>
                                            element == data.documentID);
                                  }
                                });
                              },
                              onTap: () {
                                if (isSelectItem) {
                                  setState(() {
                                    selectedItem[data.documentID!] =
                                        !isSelectedData;
                                    if (selectedItem[data.documentID!]!) {
                                      selectedDocumentedID
                                          .add(data.documentID!);
                                    } else {
                                      selectedDocumentedID.removeWhere(
                                          (element) =>
                                              element == data.documentID);
                                    }
                                    isSelectItem =
                                        selectedItem.containsValue(true);
                                  });
                                }
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        Gap(3.w),
                                        Text(
                                          data.canLogin
                                              ? "Active"
                                              : "Restricted",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.sp,
                                            color: data.canLogin
                                                ? Colors.black
                                                : Colors.red,
                                            height: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    _mainUI(
                                      isSelectedData!,
                                    ),
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
              ),
            );
          }
          return Scaffold(body: CustomCircularIndicator());
        },
      ),
    );
  }

  Widget _mainUI(
    bool isSelected,
  ) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> anim) =>
          RotationTransition(
        turns: child.key == const ValueKey('icon1')
            ? Tween<double>(begin: 0, end: 1).animate(anim)
            : Tween<double>(begin: 1, end: 0).animate(anim),
        child: ScaleTransition(
          scale: anim,
          child: child,
        ),
      ),
      child: isSelectItem
          ? Icon(
              key: const ValueKey('icon1'),
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: Theme.of(context).primaryColor,
            )
          : Icon(
              Icons.keyboard_arrow_right,
              key: const ValueKey('icon2'),
            ),
    );
  }
}
