
/////////////////////////////////////
//THIS SCREEN IS NOT NEEDED ANYMORE//
/////////////////////////////////////



import 'package:flutter/material.dart';
import 'package:notive_app/screens/profile_screen.dart';
import 'package:notive_app/screens/range_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'settings_screen';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _switchLight = false;
  bool _pushNot = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
        ),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(children: <Widget>[
          SwitchListTile(
            value: _switchLight,
            title: Text("Dark / Light Theme"),
            onChanged: (value) {
              setState(() {
                _switchLight = value; 
                
              });
            },
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
            value: _pushNot,
            title: Text("Push Notifications"),
            onChanged: (value) {
              setState(() {
                _pushNot = value; 
              });
            },
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
