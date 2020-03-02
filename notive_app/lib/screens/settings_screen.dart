import 'package:flutter/material.dart';
import 'package:notive_app/components/custom_drawer.dart';
import 'package:notive_app/screens/profile_screen.dart';
import 'package:notive_app/screens/range_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'settings_screen';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
        ),
        leading: BackButton(
          //color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      //drawer: CustomDrawer(),
      body: Center(
        child: Column(children: <Widget>[
          SwitchListTile(
            value: false,
            title: Text("Dark / Light Theme"),
            onChanged: (value) {},
          ),
          CheckboxListTile(
            value: true,
            title: Text("Add New Item to Top"),
            onChanged: (value) {},
          ),
          ListTile(
            title: Text("Change Default Range Settings"),
            subtitle: Text("Rating, Price, Distance"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RangeSettingsScreen()),
              );
            },
          ),
          SwitchListTile(
            value: true,
            title: Text("Push Notifications"),
            onChanged: (value) {},
          ),
          ListTile(
            title: Text("Account"),
            subtitle: Text("Change Password, Change Email"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ]),
      ),
    );
  }
}
