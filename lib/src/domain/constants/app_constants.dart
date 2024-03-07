class AppConstant {
  static const contactNumber = "+91 9876543210";

  /// SHARED PREFERENCES CONSTANTS
  static const spIsLoggedIn = 'isLoggedIn';
  static const spDeviceID = 'deviceID';
  static const spUserName = 'username';
  static const spFetchedDuration = 'detchedDuration';
  static const spUserDocumentID = 'userDocumentID';
  static const spSecondsPlayed = 'secondsPlayed';
  static const spLastPlayedDocumentID = 'lastPlayedDocumentID';

  //global variables to manage few stuffs
  static bool isSecPause = false;
  static String _fcmURL = 'https://fcm.googleapis.com/fcm/send';
  static String get fcmURL => _fcmURL;
  static String _fcmServerKey =
      'AAAAkkyFtro:APA91bFIarh3kN7LW4ggDvi75XcwTeioBKtqk7rXQVh1mivK8w9ynFeZUwpKAzNKRRUv9pGbParnAHA6Xmes1FR8xTX5Per_sMg0m9iT3zi6bPaAVgmczq64-rFTEf_ouhSqKhs5tziM';
  static String get fcmServerKey => _fcmServerKey;
}
