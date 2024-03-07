// import 'package:assignment/src/data/models/users_model.dart';
// import 'package:assignment/src/display/screens/add_new_user/add_new_user_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
//
// import 'display/components/custom_snackbar/custom_snackbar.dart';
// import 'display/screens/home/home_screen.dart';
//
// class UsersListScreen extends StatefulWidget {
//   const UsersListScreen({super.key});
//
//   @override
//   State<UsersListScreen> createState() => _UsersListScreenState();
// }
//
// class _UsersListScreenState extends State<UsersListScreen> {
//   final TextEditingController _searchController = TextEditingController();
//
//   bool isSelectItem = false;
//   Map<int, bool> selectedItem = {};
//   bool isLoading = false;
//
//   var fbStream = FirebaseFirestore.instance.collection('users').snapshots();
//   selectAllAtOnceGo() {
//     bool isFalseAvailable = selectedItem.containsValue(false);
//     selectedItem.updateAll((key, value) => isFalseAvailable);
//     setState(() {
//       isSelectItem = selectedItem.containsValue(true);
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.sizeOf(context).width;
//     final double screenNotch = MediaQuery.paddingOf(context).top;
//     return Scaffold(
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: GestureDetector(
//         onTap: () {
//           ScaffoldMessenger.of(context).clearSnackBars();
//           customErrorSnackBarMsg(
//               time: 3,
//               text: 'Login access has been denied successfully',
//               context: context);
//           // selectAllAtOnceGo();
//         },
//         child: AnimatedContainer(
//           duration: Duration(milliseconds: 500),
//           width: double.infinity,
//           height: isSelectItem ? 55.h : 35.h,
//           child: isSelectItem
//               ? Padding(
//                   padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
//                   child: DecoratedBox(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         color: Colors.black),
//                     child: Center(
//                       child: Text(
//                         'Save changes',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           color: Colors.white,
//                           fontSize: 16.sp,
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               : FloatingActionButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (
//                           context,
//                         ) =>
//                             AddNewUserScreen(),
//                       ),
//                     );
//                   },
//                   child: Icon(Icons.add),
//                 ),
//         ),
//       ),
//       appBar: PreferredSize(
//           preferredSize: Size(screenWidth, 50.h + screenNotch),
//           child: SizedBox(
//             width: screenWidth,
//             height: 50.h + screenNotch,
//             child: Padding(
//               padding: EdgeInsets.only(top: screenNotch, left: 17.w),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: CircleAvatar(
//                         backgroundColor: Color(0x176e6d6d),
//                         child: IconButton(
//                             onPressed: () => Navigator.pop(context),
//                             icon: const Icon(
//                               Icons.arrow_back,
//                               size: 22,
//                             )),
//                       ),
//                     ),
//                   ),
//                   Text(
//                     'Change user position',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 17.sp,
//                     ),
//                   ),
//                   Spacer(),
//                 ],
//               ),
//             ),
//           )),
//       body: ListView(
//         padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 10.h),
//         children: [
//           Text(
//             'Select the user you want to change position for',
//             style: TextStyle(
//               fontWeight: FontWeight.w500,
//               fontSize: 24.sp,
//               height: 1.2,
//             ),
//           ),
//           Gap(15.h),
//           StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//               stream: fbStream,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const CustomCircularIndicator();
//                 }
//
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Text(
//                       snapshot.error.toString(),
//                     ),
//                   );
//                 }
//                 if (snapshot.hasData) {
//                   return Column(
//                     children: [
//                       DecoratedBox(
//                         decoration: BoxDecoration(
//                             color: Color(0x10949494),
//                             borderRadius: BorderRadius.circular(12)),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 5.0, vertical: 3),
//                           child: TextField(
//                             controller: _searchController,
//                             onChanged: (v) {
//                               userList.clear();
//                               if (v.isNotEmpty) {
//                                 userList.addAll(allList.where((element) =>
//                                     element.name!.toLowerCase().contains(
//                                         _searchController.text.toLowerCase())));
//                               } else {
//                                 userList.addAll(allList);
//                               }
//
//                               setState(() {});
//                             },
//                             keyboardType: TextInputType.text,
//                             textInputAction: TextInputAction.next,
//                             cursorColor: Colors.black,
//                             decoration: InputDecoration(
//                               prefixIcon: Icon(
//                                 Icons.search,
//                                 color: Colors.black87,
//                               ),
//                               hintText: 'Search by name',
//                               enabledBorder: InputBorder.none,
//                               focusedBorder: InputBorder.none,
//                               hintStyle: TextStyle(
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey,
//                                 fontSize: 0.017.sh,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Gap(15.h),
//                       ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: snapshot.data!.docs.length,
//                           physics: NeverScrollableScrollPhysics(),
//                           itemBuilder: (BuildContext context, int index) {
//                             Map<String, dynamic> user =
//                                 snapshot.data!.docs[index].data();
//                             var data = UserModel.fromMap(user);
//
//                             selectedItem?[index] =
//                                 selectedItem?[index] ?? false;
//                             bool? isSelectedData = selectedItem[index];
//
//                             return InkWell(
//                               borderRadius: BorderRadius.circular(10),
//                               splashColor: Color(0x1FADADAD),
//                               onLongPress: () {
//                                 setState(() {
//                                   selectedItem[index] = !isSelectedData;
//                                   isSelectItem =
//                                       selectedItem.containsValue(true);
//                                 });
//                               },
//                               onTap: () {
//                                 if (isSelectItem) {
//                                   setState(() {
//                                     selectedItem[index] = !isSelectedData;
//                                     isSelectItem =
//                                         selectedItem.containsValue(true);
//                                   });
//                                 } else {
//                                   // Open Detail Page
//                                 }
//                               },
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: 3.0,
//                                   vertical: 10.h,
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     CircleAvatar(
//                                       radius: 20,
//                                       backgroundColor: Colors.orangeAccent,
//                                       backgroundImage:
//                                           AssetImage(data.profilePic),
//                                     ),
//                                     Gap(10.w),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           data.firstName,
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 15.sp,
//                                             height: 1.2,
//                                           ),
//                                         ),
//                                         Text(
//                                           data.role,
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w400,
//                                             fontSize: 12.sp,
//                                             height: 1.2,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Spacer(),
//                                     _mainUI(
//                                       isSelectedData!,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           }),
//                     ],
//                   );
//                 }
//                 return const CustomCircularIndicator();
//               })
//         ],
//       ),
//     );
//   }
//
//   Widget _mainUI(
//     bool isSelected,
//   ) {
//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 500),
//       transitionBuilder: (Widget child, Animation<double> anim) =>
//           RotationTransition(
//         turns: child.key == const ValueKey('icon1')
//             ? Tween<double>(begin: 0, end: 1).animate(anim)
//             : Tween<double>(begin: 1, end: 0).animate(anim),
//         child: ScaleTransition(
//           scale: anim,
//           child: child,
//         ),
//       ),
//       child: isSelectItem
//           ? Icon(
//               key: const ValueKey('icon1'),
//               isSelected ? Icons.check_box : Icons.check_box_outline_blank,
//               color: Theme.of(context).primaryColor,
//             )
//           : Icon(
//               Icons.keyboard_arrow_right,
//               key: const ValueKey('icon2'),
//             ),
//     );
//   }
// }
