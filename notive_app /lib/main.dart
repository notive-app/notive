import 'package:flutter/material.dart';
import 'package:notive_app/models/item_data.dart';
import 'models/list_data.dart';
import 'package:provider/provider.dart';
import 'package:notive_app/screens/profile_screen.dart';
import 'package:notive_app/screens/welcome_screen.dart';
import 'package:notive_app/screens/login_screen.dart';
import 'package:notive_app/screens/signup_screen.dart';
import 'package:notive_app/screens/dashboard_screen.dart';
import 'package:notive_app/screens/listview_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ListData()),
        //Provider(create: (context) => ListViewScreen()),
        Provider(create: (context) => DashboardScreen()),
      ],
      child: NotiveApp(),
    ),
  );
}

class NotiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.orange,
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
        ListViewScreen.id: (context) => ListViewScreen(),
      },
    );
  }
}
