import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../domain/constants/asset_constants.dart';
import '../../components/custom_snackbar/custom_snackbar.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> allList = [];
  List<UserModel> userList = CustomData.mydata;
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
    init();
  }

  init() async {
    isLoading = true;

    setState(() {});
    allList.clear();
    allList.addAll(userList);
    print("42 working");
    userList.clear();
    if (_searchController.text.trim().isNotEmpty) {
      userList.addAll(allList.where((element) => element.name
          .toLowerCase()!
          .contains(_searchController.text.toLowerCase())));
    } else {
      userList.addAll(allList);
    }
    isLoading = false;

    setState(() {});
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).clearSnackBars();
          customErrorSnackBarMsg(
              time: 3,
              text: 'Login access has been denied successfully',
              context: context);
          // selectAllAtOnceGo();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.check),
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
          Gap(15.h),
          DecoratedBox(
            decoration: BoxDecoration(
                color: Color(0x10949494),
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
              child: TextField(
                controller: _searchController,
                onChanged: (v) {
                  userList.clear();
                  if (v.isNotEmpty) {
                    userList.addAll(allList.where((element) => element.name!
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase())));
                  } else {
                    userList.addAll(allList);
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
          if (userList.isNotEmpty)
            ListView.builder(
                shrinkWrap: true,
                itemCount: userList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  UserModel data = userList[index];
                  selectedItem?[index] = selectedItem?[index] ?? false;
                  bool? isSelectedData = selectedItem[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    splashColor: Color(0x1FADADAD),
                    onLongPress: () {
                      setState(() {
                        selectedItem[index] = !isSelectedData;
                        isSelectItem = selectedItem.containsValue(true);
                      });
                    },
                    onTap: () {
                      if (isSelectItem) {
                        setState(() {
                          selectedItem[index] = !isSelectedData;
                          isSelectItem = selectedItem.containsValue(true);
                        });
                      } else {
                        // Open Detail Page
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
                            backgroundImage: AssetImage(data.profilePic),
                          ),
                          Gap(10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data.name,
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
                          _mainUI(
                            isSelectedData!,
                          ),
                        ],
                      ),
                    ),
                  );
                })
          else if (userList.isEmpty && isLoading == false)
            Center(
              child: Text("No Data"),
            )
          else
            Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _mainUI(
    bool isSelected,
  ) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
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

class CustomData {
  static List<UserModel> mydata = [
    UserModel(
        id: 1, name: 'Tester 1', role: 'Admin', profilePic: Assets.icons.india),
    UserModel(
        id: 2, name: 'Tester 2', role: 'Admin', profilePic: Assets.icons.india),
    UserModel(
        id: 3, name: 'Tester 3', role: 'Admin', profilePic: Assets.icons.india),
    UserModel(
        id: 3, name: 'Tester 3', role: 'Admin', profilePic: Assets.icons.india),
    UserModel(
        id: 4, name: 'Tester 4', role: 'Admin', profilePic: Assets.icons.india),
    UserModel(
        id: 5, name: 'Tester 5', role: 'Admin', profilePic: Assets.icons.india),
    UserModel(
        id: 6, name: 'Tester 6', role: 'Admin', profilePic: Assets.icons.india),
  ];
}

class UserModel {
  final int id;
  final String name;
  final String role;
  final String profilePic;
  const UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.profilePic,
  });
}
