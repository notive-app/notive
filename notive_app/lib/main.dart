import 'package:flutter/material.dart';
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
import 'package:notive_app/util/request.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user_model.dart';

//import 'package:http/http.dart' as http;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = prefs.getString('email');
  if(email != null){
    headers['cookie'] = prefs.getString('cookie');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>(create: (context) => UserModel()),
//        ChangeNotifierProvider<ListModel>(create: (context) => ListModel()),
        //Provider(create: (context) => Dashboard()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: kOffWhiteColor,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          // additional settings go here
        ),
        initialRoute: email == null ? WelcomeScreen.id : DashboardScreen.id,
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
      ),
    ),
  );
}
