import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../custom_bottom_sheet/custom_bottom_sheet.dart';
import '../custom_snackbar/custom_snackbar.dart';

Future<File?> pickImage(BuildContext context) async {
  ImagePicker imagePicker = ImagePicker();

  File? image;
  await titleBottomSheet(
      context: context,
      title: "Pick an image",
      widget: Padding(
        padding: const EdgeInsets.only(bottom: 30.0, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () async {
                try {
                  final pickedImage = await imagePicker.pickImage(
                      source: ImageSource.camera, imageQuality: 30);
                  if (pickedImage != null) {
                    image = File(pickedImage.path);
                  }
                } catch (e) {
                  customSnackBarMsg(
                      context: context, text: e.toString(), time: 3);
                }
                Navigator.pop(context);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 50,
                  ),
                  Text(
                    'Camera',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            InkWell(
              onTap: () async {
                try {
                  final pickedImage = await imagePicker.pickImage(
                      source: ImageSource.gallery, imageQuality: 30);
                  if (pickedImage != null) {
                    image = File(pickedImage.path);
                  }
                } catch (e) {
                  customSnackBarMsg(
                      context: context, text: e.toString(), time: 3);
                }
                Navigator.pop(context);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 50,
                  ),
                  Text(
                    'Gallery',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ));
  return image;
}
