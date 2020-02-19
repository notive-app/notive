import 'package:flutter/material.dart';
import 'package:notive_app/components/dashboard.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:notive_app/screens/mapview_screen.dart';
import 'package:notive_app/screens/profile_screen.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:notive_app/screens/settings_screen.dart';
import 'package:notive_app/screens/dashboard_screen.dart';
import 'package:notive_app/components/rounded_button.dart';

class ArchivedListsScreen extends StatelessWidget {
  static const String id = 'archived_lists_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  //color: Colors.black,
                  ),
              child: Text(
                'MENU',
                style: TextStyle(
                  //color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.map,
                color: kOrangeColor,
              ),
              title: Text(
                'Map View',
                style: TextStyle(color: kOrangeColor),
              ),
              selected: true,
              onTap: () {
                //why is this giving an error?
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapViewScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.view_list,
                color: kOrangeColor,
              ),
              title: Text(
                'Dashboard',
                style: TextStyle(color: kOrangeColor),
              ),
              selected: true,
              onTap: () {
                //why is this giving an error?
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.playlist_add_check,
                color: kOrangeColor,
              ),
              title: Text(
                'Archived Lists',
                style: TextStyle(color: kOrangeColor),
              ),
              selected: true,
              onTap: () {
                //why is this giving an error?
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ArchivedListsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.account_circle,
                color: kOrangeColor,
              ),
              title: Text(
                'Account',
                style: TextStyle(color: kOrangeColor),
              ),
              selected: true,
              onTap: () {
                //why is this giving an error?
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: kOrangeColor,
              ),
              title: Text(
                'Settings',
                style: TextStyle(color: kOrangeColor),
              ),
              selected: true,
              onTap: () {
                //why is this giving an error?
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: kOrangeColor,
              ),
              title: Text(
                'Log Out',
                style: TextStyle(color: kOrangeColor),
              ),
              selected: true,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Archived Lists',
        ),
      ),
      body: Center(
        child: Text(
          'Coming Soon...',
          style: TextStyle(
            //color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
