import 'package:assignment/src/domain/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/blocs/users/users_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenNotch = MediaQuery.paddingOf(context).top;
    return BlocProvider.value(
      value: usersBloc..add(UsersEventInit()),
      child: Scaffold(
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
      ),
    );
  }
}
