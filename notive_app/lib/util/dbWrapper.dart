import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:notive_app/util/notification.dart';

class DBWrapper {
  final dbRef = FirebaseDatabase.instance.reference().child("users");
  final FirebaseMessaging fcm = new FirebaseMessaging();
  
  
  DBWraooer(){
    fcm.configure(
    onMessage: messageHandler,
    onBackgroundMessage: backgroundMessageHandler,
    onLaunch: launchMessageHandler,
    onResume: resumeMessageHandler,
  );
  }

  void addUser(UserModel user) async{
    // Get the token for this device
    String fcmToken = await fcm.getToken();

    if(dbRef.child(user.id.toString()) == null){ // first time.
      dbRef.set(user.id.toString());
    }

    if (fcmToken != null) {
      dbRef.child(user.id.toString()).set({
        "user_email": user.email,
        "user_name": user.name,
        "token": fcmToken
      });
    }
    else {
      dbRef.set(user.id.toString());   
      dbRef.child(user.id.toString()).set({
        "user_email": user.email,
        "user_name": user.name
      });
    }
  }

  bool findUser(UserModel user){
    return false;
  }
}