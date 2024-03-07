import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../domain/helpers/shared_preference_helper.dart';
import '../../domain/repos.dart';

class NotificationRepo {
  Future<String> getToken() async {
    String token = (await FirebaseMessaging.instance.getToken()) ?? '';
    logger.f(token);
    SharedPreferencesHelper.setFBToken(token);

    getTokenRefreshed();
    return token;
  }

  String getTokenRefreshed() {
    String token = '';
    FirebaseMessaging.instance.onTokenRefresh.listen((String fcmToken) {
      if (fcmToken.isNotEmpty) {
        token = fcmToken;
        SharedPreferencesHelper.setFBToken(token);
      }
    }).onError((err) {
      token = '';
    });
    return token;
  }

  listenToNotification({required Function(String value) onSelected}) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print('nikhil herere ${event.data}');
      showNotification(
        notification: event,
        onSelected: onSelected,
      );
    });
  }

  showNotification({
    required RemoteMessage notification,
    required Function(String value) onSelected,
  }) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        onSelected(details.payload ?? '');
      },
    );
    channelNotification(flutterLocalNotificationsPlugin, notification);
  }

  channelNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    RemoteMessage notification,
  ) async {
    print('nikhil ccccc  data}');

    final BigTextStyleInformation bigTextStyleInformation =
        BigTextStyleInformation(notification.data['message'],
            htmlFormatTitle: true,
            htmlFormatBigText: true,
            htmlFormatContent: true,
            contentTitle: "Parangat",
            htmlFormatContentTitle: true,
            summaryText: notification.data['title'],
            htmlFormatSummaryText: true);
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            '1:628349056698:android:4d299d206bece9e548f483', 'Parangat',
            channelDescription: 'description',
            importance: Importance.max,
            ticker: 'ticker',
            styleInformation: bigTextStyleInformation);
    NotificationDetails platformChannelSpesifies =
        NotificationDetails(android: androidNotificationDetails);
    final microsecondsSinceEpoch = DateTime.now().microsecondsSinceEpoch;
    final randomUniqueChannelID = microsecondsSinceEpoch % 10000;
    await flutterLocalNotificationsPlugin.show(
      randomUniqueChannelID,
      'Parangat',
      notification.data['message'],
      platformChannelSpesifies,
      payload: 'item x',
    );
  }
}
