import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../domain/constants/asset_constants.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<UserModel> myData = CustomData.mydata;
  bool isSelectItem = false;
  Map<int, bool> selectedItem = {};

  selectAllAtOnceGo() {
    bool isFalseAvailable = selectedItem.containsValue(false);
    selectedItem.updateAll((key, value) => isFalseAvailable);
    setState(() {
      isSelectItem = selectedItem.containsValue(true);
    });
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
          selectAllAtOnceGo();
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
          ListView.builder(
              shrinkWrap: true,
              itemCount: myData.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                UserModel data = myData[index];
                selectedItem?[index] = selectedItem?[index] ?? false;
                bool? isSelectedData = selectedItem[index];

                return ListTile(
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
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    data.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      height: 1.2,
                    ),
                  ),
                  subtitle: Text(
                    data.role,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      height: 1.2,
                    ),
                  ),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.orangeAccent,
                    backgroundImage: AssetImage(data.profilePic),
                  ),
                  trailing: _mainUI(isSelectedData!, data),
                );
              })
        ],
      ),
    );
  }

  Widget _mainUI(bool isSelected, UserModel ourdata) {
    if (isSelectItem) {
      return Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
        color: Theme.of(context).primaryColor,
      );
    } else {
      return Icon(Icons.keyboard_arrow_right);
    }
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
