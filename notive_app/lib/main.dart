import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notive_app/models/theme_manager.dart';
import 'package:notive_app/screens/archived_lists_screen.dart';
import 'package:notive_app/screens/dashboard_screen.dart';
import 'package:notive_app/screens/listview_screen.dart';
import 'package:notive_app/screens/login_screen.dart';
import 'package:notive_app/screens/mapview_screen.dart';
import 'package:notive_app/screens/profile_screen.dart';
import 'package:notive_app/screens/range_settings_screen.dart';
import 'package:notive_app/screens/settings_screen.dart';
import 'package:notive_app/screens/signup_screen.dart';
import 'package:notive_app/screens/welcome_screen.dart';
import 'package:notive_app/util/notification.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user_model.dart';

var email;
var password;
var buildCount = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var _firebaseMessaging = FirebaseMessaging();
  _firebaseMessaging.configure(
    onMessage: messageHandler,
    onBackgroundMessage: backgroundMessageHandler,
    onLaunch: launchMessageHandler,
    onResume: resumeMessageHandler,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  email = prefs.getString('email');
  password = prefs.getString('password');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>(create: (context) => UserModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeManager>(
      create: (_) => ThemeManager(),
      child: new NotiveApp(),
    );
  }
}

class NotiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    rebuildAllChildren(context);
    final manager = Provider.of<ThemeManager>(context);
    var initialRoute = WelcomeScreen.id;

    // build count is required because this widget is built twice at the start, i dont know why
    if (email != null && password != null && buildCount == 0) {
      buildCount += 1;
      initialRoute = DashboardScreen.id;
      var data = Map<String, dynamic>();
      data["email"] = email;
      data["password"] = password;
      Provider.of<UserModel>(context, listen: false).login(data);
    }

    return MaterialApp(
      theme: manager.themeData,
      initialRoute: initialRoute,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        SignupScreen.id: (context) => SignupScreen(),
        DashboardScreen.id: (context) => DashboardScreen(),
        ListViewScreen.id: (context) => ListViewScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        SettingsScreen.id: (context) => SettingsScreen(),
        ArchivedListsScreen.id: (context) => ArchivedListsScreen(),
        MapViewScreen.id: (context) => MapViewScreen(),
        RangeSettingsScreen.id: (context) => RangeSettingsScreen(),
      },
    );
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }
}
