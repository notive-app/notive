import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notive_app/screens/archived_lists_screen.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:notive_app/screens/dashboard_screen.dart';
import 'package:notive_app/screens/listview_screen.dart';
import 'package:notive_app/screens/login_screen.dart';
import 'package:notive_app/screens/mapview_screen.dart';
import 'package:notive_app/screens/profile_screen.dart';
import 'package:notive_app/screens/settings_screen.dart';
import 'package:notive_app/screens/signup_screen.dart';
import 'package:notive_app/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'models/user_model.dart';
import 'package:notive_app/models/notification_model.dart';

// Streams are created so that app can respond to notification-related
// events since the plugin is initialised in the `main` function

NotificationAppLaunchDetails notificationAppLaunchDetails;

Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid =
      AndroidInitializationSettings('notification_img');
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>(create: (context) => UserModel()),
//        ChangeNotifierProvider<ListModel>(create: (context) => ListModel()),
        //Provider(create: (context) => Dashboard()),
      ],
      child: NotiveApp(),
    ),
  );
}

class NotiveApp extends StatefulWidget {
  @override
  _NotiveAppState createState() => _NotiveAppState();
}

class _NotiveAppState extends State<NotiveApp> {
  final MethodChannel platform =
      MethodChannel('crossingthestreams.io/resourceResolver');
  @override
  initState() {
    super.initState();
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapViewScreen(),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MapViewScreen()),
      );
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    var log = Provider.of<UserModel>(context, listen: false).isLoggedIn;

    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: kOffWhiteColor,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        // additional settings go here
      ),
      initialRoute: WelcomeScreen.id,
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
      },
    );
  }
}
