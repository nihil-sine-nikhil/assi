import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/constants/firebase_constants.dart';

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
}
