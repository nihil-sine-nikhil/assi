import 'dart:async';

import 'package:flutter/material.dart';

class PopupHelper {
  static PopupHelper _instance = new PopupHelper.internal();

  Dialog? _dialog;
  bool isShowing = false;
  PopupHelper.internal();
  factory PopupHelper() => _instance;
  showLoaderDialog(BuildContext context) {
    isShowing = true;
    if (_dialog == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _dialog = Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: EdgeInsets.all(16),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Stack(
                    children: [
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: Image.asset(
                      //     "assets/icons/show_talent_logo.png",
                      //     height: 50,
                      //     width: 50,
                      //   ),
                      // ),
                      Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              width: 50,
              height: 50,
              child: WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: _dialog!,
              ),
            );
          },
        ).then((value) => _dialog == null);
      });
    }
  }

  Future hideLoaderDialog(BuildContext context) async {
    if (_dialog != null) {
      Navigator.of(context, rootNavigator: true).pop();
      _dialog = null;
      isShowing = true;
    }
  }
}
