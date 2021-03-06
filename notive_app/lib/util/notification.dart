import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notification {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future showNotificationWithoutSound(String name) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        '1', 'location-bg', 'fetch location in background',
        playSound: false, importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'There are opportunities close to you!',
      '$name',
      platformChannelSpecifics,
      payload: '',
    );
  }

  Notification() {
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
}