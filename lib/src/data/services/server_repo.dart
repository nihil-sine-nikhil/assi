import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/constants/app_constants.dart';
import '../../domain/helpers/shared_preference_helper.dart';
import '../../domain/repos.dart';

class ServerRepo {
  final String hostname = AppConstant.fcmURL; // live ip
  Future<bool> sendFCMNotification({
    required String message,
    required String title,
  }) async {
    try {
      final token = SharedPreferencesHelper.getFBToken();

      final Map<String, dynamic> body = {
        'to': token,
        'data': {
          'title': title,
          'message': message,
        },
      };
      final response = await http
          .post(Uri.parse(hostname), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=${AppConstant.fcmServerKey}',
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      logger.e(e.toString());
      return false;
    }
  }
}
