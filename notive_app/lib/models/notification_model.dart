import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notification extends StatefulWidget{
   @override
   _NotificationState createState() => _NotificationState();
}


class _NotificationState extends State<Notification>{
   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

   @override
   initState(){
      super.initState();
      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
      var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
      var iOS = new IOSInitializationSettings();
      var initSettings = new InitializationSettings(android, iOS);
      flutterLocalNotificationsPlugin.initialize(
         initSettings, 
         onSelectNotification: onSelectNotification
      );
   }

   Future onSelectNotification(String payload){
      debugPrint("payload : $payload");
      showDialog(context: context, builder: (_)=> new AlertDialog(
         title: new Text('Notification'),
         content: new Text('$payload')
      ));
   }

   @override
   Widget build(BuildContext context){
      return Scaffold(
         appBar: new AppBar(
            title: new Text('Flutter Local Notification Title')
         ),
         body: new Center(
            child: new RaisedButton(
               onPressed: showNotification,
               child: new Text(
                  'Demo',
                  style: Theme.of(context).textTheme.headline1,
               ))
         )
      );
   }

   showNotification() async{
      var android = new AndroidNotificationDetails('channelId', 'channelName', 'channelDescription');
      var iOS = new IOSNotificationDetails();
      var platform = new NotificationDetails(android, iOS);
      await flutterLocalNotificationsPlugin.show(0, "You have one new notive!", "This is the notification body.", platform);
   }
}
