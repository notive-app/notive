import 'package:flutter/material.dart';
import 'package:notive_app/screens/settings_screen.dart';
import 'package:notive_app/screens/listview_screen.dart';
import 'package:notive_app/screens/dashboard_screen.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NOTIVE'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'MENU',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Map'),
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
              leading: Icon(Icons.view_list),
              title: Text('Lists'),
              selected: true,
              onTap: () {
                //why is this giving an error?
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListViewScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.playlist_add_check),
              title: Text('Archived Lists'),
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
              leading: Icon(Icons.account_circle),
              title: Text('Account'),
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
              leading: Icon(Icons.settings),
              title: Text('Settings'),
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
              leading: Icon(Icons.exit_to_app),
              title: Text('Log Out'),
              selected: true,
            ),
          ],
        ),
      ),
    );
  }
}
