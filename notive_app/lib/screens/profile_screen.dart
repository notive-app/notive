import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:notive_app/screens/archived_lists_screen.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:notive_app/screens/settings_screen.dart';
import 'package:notive_app/screens/dashboard_screen.dart';
import 'mapview_screen.dart';
import 'package:notive_app/components/rounded_button.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = 'profile_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text('User Profile'),
        //backgroundColor: Colors.black,
      ),
      //backgroundColor: Colors.blueGrey[500],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 70.0,
              backgroundImage: AssetImage('images/ben.jpg'),
            ),
            Text(
              'Hygerta Imeri',
              style: TextStyle(
                fontFamily: 'Lobster',
                fontSize: 35.0,
                //color: Colors.white,
                //fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(
              height: 6.0,
            ),
            Text(
              'Notivist since July 2019',
              style: TextStyle(
                fontFamily: 'SourceSansPro',
                fontSize: 16.0,
                color: kOrangeColor,
                letterSpacing: 2.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 220.0,
              height: 20.0,
              child: Divider(
                color: kOrangeColor,
              ),
            ),
            Card(
              //padding: EdgeInsets.all(10.0),
              color: Colors.grey[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
              child: ListTile(
                leading: Icon(
                  Icons.email,
                  color: kOrangeColor,
                  size: 25.0,
                ),
                title: Text(
                  'hygerta.imeri@hotmail.com',
                  style: TextStyle(
                    color: Colors.blueGrey[900],
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            Card(
              //padding: EdgeInsets.all(10.0),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
              child: ListTile(
                leading: Icon(
                  Icons.lock,
                  color: kOrangeColor,
                  size: 25.0,
                ),
                title: Text(
                  '*************',
                  style: TextStyle(
                    color: Colors.blueGrey[900],
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            Card(
              //padding: EdgeInsets.all(10.0),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
              child: ListTile(
                leading: Icon(
                  Icons.calendar_today,
                  color: kOrangeColor,
                  size: 25.0,
                ),
                title: Text(
                  '14 Aug 1997',
                  style: TextStyle(
                    color: Colors.blueGrey[900],
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            RoundedButton(
              title: 'Update data',
              colour: kLightBlueColor,
              onPressed: () {
                Navigator.pushNamed(context, ProfileScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
