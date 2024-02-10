import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class Notifications
{
  Future<void> getToken();
  Future<void> handleOnForeGround();
  void handleOnBackGround();
  Future<void> handleOnTerminated();
}

class HandleNotifications implements Notifications
{
  HandleNotifications._internal();

  static HandleNotifications? instance;

  static HandleNotifications getInstance()
  {
    return instance ??= HandleNotifications._internal();
  }

  @override
  Future<void> getToken()async {
    await FirebaseMessaging.instance.getToken().then((token)
    {
      log('Token : $token');
    });
  }

  @override
  Future<void> handleOnForeGround()async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((message) {
      log('the message is on fore : ${message.data}');
    });
  }

  @override
  void handleOnBackGround() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  @override
  Future<void> handleOnTerminated() async{}

}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async
{
  log("Handling a background message: ${message.messageId}");
}