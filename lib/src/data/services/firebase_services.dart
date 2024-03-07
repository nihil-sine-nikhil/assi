import 'package:cloud_firestore/cloud_firestore.dart';

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

  ///user
  Future<bool> checkAdminExist(String email) async {
    try {
      var response = await firestore
          .collection(FirebaseConstants.adminCollection)
          .where('email', isEqualTo: email)
          .get();
      if (response.size > 0) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
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

  Future<CustomResponse> addNewUser({required UserModel userModel}) async {
    try {
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

  Future<CustomResponse> updateUserDetails(
      {required UserModel userModel}) async {
    try {
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
}
