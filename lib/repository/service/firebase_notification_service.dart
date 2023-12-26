import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();
    print("token $fCMToken");

    initPushNotification();
  }

  void handleMessage(RemoteMessage? message) async {
    if (message == null) return;

    // Handle your notification here for both foreground and background
    print("Handling message: ${message.messageId}");
  }

  Future<void> initPushNotification() async {
    // Handle the initial message when the app is not running
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      handleMessage(message);
    });

    // Handle messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((message) {
      handleMessage(message);
    });

    // Handle messages when the app is in the background and opened
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message);
    });
  }
}
