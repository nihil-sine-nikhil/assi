import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ScaffoldFeatureController customSnackBarMsg({
  required BuildContext context,
  required String text,
  required int time,
  w,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      width: double.infinity,
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      duration: Duration(seconds: time),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                text,
                maxLines: 5,
                style: TextStyle(
                  fontSize: 12.sp,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  ScaffoldMessenger.of(context).clearSnackBars();
                },
                child: const Icon(Icons.close, color: Colors.white)),
          ],
        ),
      ),
    ),
  );
}

ScaffoldFeatureController customErrorSnackBarMsg({
  required BuildContext context,
  required String text,
  required int time,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      width: double.infinity,
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      duration: Duration(seconds: time),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color(0xffa20418),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                text,
                maxLines: 5,
                style: TextStyle(
                  fontSize: 12.sp,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  ScaffoldMessenger.of(context).clearSnackBars();
                },
                child: const Icon(Icons.close, color: Colors.white)),
          ],
        ),
      ),
    ),
  );
}
