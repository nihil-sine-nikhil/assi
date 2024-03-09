import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/constants/firebase_constants.dart';
import '../../domain/repos.dart';
import '../models/firestore_response_models/generic_response_model.dart';
import '../models/firestore_response_models/users_list_response_model.dart';
import '../models/users_model.dart';

class FirebaseServices {
  static final FirebaseServices _singleton = FirebaseServices._internal();

  factory FirebaseServices() {
    return _singleton;
  }

  FirebaseServices._internal();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref();

  /// UPLOADING PROFILE PICTURE
  Future<String> storeProfilePic(String ref, File file) async {
    UploadTask uploadTask = storageRef.child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  /// for disabling Login access for multiple users
  Future<CustomResponse> disableUsersLoginAccess({
    required List<String> documentIds,
    required bool grantAccess,
  }) async {
    try {
      final batch = FirebaseFirestore.instance.batch();

      for (final documentId in documentIds) {
        final docRef = firestore
            .collection(FirebaseConstants.userCollection)
            .doc(documentId);
        batch.update(docRef, {'canLogin': grantAccess ? true : false});
      }

      await batch.commit();

      return CustomResponse(
        status: true,
        msg: 'Login access has been disable successfully',
      );
    } catch (e) {
      logger.e(e);
      return CustomResponse(
        status: false,
        msg: e.toString(),
      );
    }
  }

  Future<UsersListResponse> fetchUsersListStream() async {
    List<UserModel> usersList = [];
    try {
      final res = await firestore
          .collection(FirebaseConstants.userCollection)
          .snapshots()
          .listen((event) {
        for (var doc in event.docs) {
          Map<String, dynamic> data = doc.data();
          var user = UserModel.fromMap(data);
          user.documentID = doc.id;
          usersList.add(user);
        }
      });

      return UsersListResponse(
        status: true,
        msg: "Users list fetched successfully.",
        usersList: usersList,
      );
    } catch (e) {
      logger.e(e);
      return UsersListResponse(
        status: false,
        msg: e.toString(),
        usersList: usersList,
      );
    }
  }

  Future<CustomResponse> updateUserDetails(
      {required UserModel userModel, File? profilePic}) async {
    try {
      if (profilePic != null) {
        final microsecondsSinceEpoch = DateTime.now().microsecondsSinceEpoch;
        final randomID = microsecondsSinceEpoch % 10000;
        await storeProfilePic("profilePic/$randomID.jpg", profilePic)
            .then((value) {
          userModel.profilePic = value;
        }).onError((error, stackTrace) {
          logger.e(error);
        });
      }
      firestore
          .collection(FirebaseConstants.userCollection)
          .doc(userModel.documentID)
          .update(userModel.toMap());
      return CustomResponse(
        status: true,
        msg: "User updated successfully.",
      );
    } catch (e) {
      logger.e(e);
      return CustomResponse(
        status: false,
        msg: e.toString(),
      );
    }
  }

  Future<CustomResponse> addNewUser(
      {required UserModel userModel, File? profilePic}) async {
    try {
      if (profilePic != null) {
        final microsecondsSinceEpoch = DateTime.now().microsecondsSinceEpoch;
        final randomID = microsecondsSinceEpoch % 10000;
        await storeProfilePic("profilePic/$randomID.jpg", profilePic)
            .then((value) {
          userModel.profilePic = value;
        }).onError((error, stackTrace) {
          logger.e(error);
        });
      }
      await firestore.collection(FirebaseConstants.userCollection).add(
            userModel.toMap(),
          );
      return CustomResponse(
        status: true,
        msg: 'User added successfully',
      );
    } catch (e) {
      logger.e(e);
      return CustomResponse(
        status: false,
        msg: e.toString(),
      );
    }
  }

  Future<UsersListResponse> fetchUsersList() async {
    List<UserModel> usersList = [];
    try {
      final QuerySnapshot<Map<String, dynamic>> res = await firestore
          .collection(FirebaseConstants.userCollection)
          .orderBy('firstName', descending: false)
          .get();

      logger.f(res.docs);
      for (var doc in res.docs) {
        Map<String, dynamic> data = doc.data();
        var user = UserModel.fromMap(data);
        user.documentID = doc.id;
        usersList.add(user);
      }
      return UsersListResponse(
        status: true,
        msg: "Users list fetched successfully.",
        usersList: usersList,
      );
    } catch (e) {
      logger.e(e);
      return UsersListResponse(
        status: false,
        msg: e.toString(),
        usersList: usersList,
      );
    }
  }
}
