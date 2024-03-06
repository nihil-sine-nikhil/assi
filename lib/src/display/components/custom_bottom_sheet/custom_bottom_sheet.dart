import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

Future<dynamic> titleBottomSheet(
    {required BuildContext context,
    bool? enableDrag,
    required String title,
    bool? isScrollControlled,
    required Widget widget}) {
  return showModalBottomSheet(
    enableDrag: enableDrag ?? true,
    isDismissible: false,
    backgroundColor: Colors.white,
    isScrollControlled: isScrollControlled ?? true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
    context: context,
    builder: (context) => SingleChildScrollView(
      child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ColoredBox(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      CircleAvatar(
                        backgroundColor: Color(0x246e6d6d),
                        child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.close,
                              size: 20,
                            )),
                      )
                    ],
                  ),
                  Gap(15.h),
                  widget
                ],
              ),
            ),
          )),
    ),
  );
}
