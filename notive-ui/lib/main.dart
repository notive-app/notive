import 'package:flutter/material.dart';
import 'package:notive_app/screens/profile_screen.dart';
import 'package:notive_app/screens/welcome_screen.dart';
import 'package:notive_app/screens/login_screen.dart';
import 'package:notive_app/screens/signup_screen.dart';
import 'package:notive_app/screens/dashboard_screen.dart';
import 'package:notive_app/screens/listview_screen.dart';

void main() => runApp(NotiveApp());

class NotiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        SignupScreen.id: (context) => SignupScreen(),
        DashboardScreen.id: (context) => DashboardScreen(),
        ListViewScreen.id: (context) => ListViewScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
      },
    );
  }
}
