import 'package:flutter/material.dart';
import 'package:notive_app/components/custom_bottom_nav.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:notive_app/screens/settings_screen.dart';
import 'package:notive_app/screens/welcome_screen.dart';
import 'constants.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'constants.dart';
import 'constants.dart';
import 'constants.dart';
import 'constants.dart';
import 'range_settings_screen.dart';
//import 'package:notive_app/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userEmail;
  bool _switchLight = false;
  bool _pushNot = true;

  //static const String id = 'profile_screen';
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(builder: (context, user, child) {
      userEmail = user.email;
      return Scaffold(
        bottomNavigationBar: CustomBottomNav(
          selectedIndex: 3,
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Profile'),
          //backgroundColor: Colors.black,
        ),
        //backgroundColor: Colors.blueGrey[500],
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 40.0,
                  backgroundImage: AssetImage('images/profile.png'),
                ),
                SizedBox(
                  height: 6.0,
                ),
                Text(
                  'Notivist since July 2019',
                  style: TextStyle(
                    fontFamily: 'SourceSansPro',
                    fontSize: 16.0,
                    color: kLightBlueColor,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 220.0,
                  height: 20.0,
                  child: Divider(
                    color: kLightBlueColor,
                  ),
                ),
                Card(
                  //padding: EdgeInsets.all(10.0),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin: EdgeInsets.only(left : 70.0, right : 70.0, bottom: 10.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.email,
                      color: kPurpleColor,
                      size: 25.0,
                    ),
                    title: Text(
                      '$userEmail',
                      style: TextStyle(
                        color: Colors.blueGrey[900],
                        fontSize: 15.0,
                      ),
                    ),
                    trailing: IconButton(
                        icon: Icon(Icons.edit, color: kDarkPurpleColor,),
                        splashColor: kPurpleColor,
                        onPressed:
                            null), 
                  ),
                ),
                Card(
                  //padding: EdgeInsets.all(10.0),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin: EdgeInsets.only(left : 70.0, right : 70.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.lock,
                      color: kPurpleColor,
                      size: 25.0,
                    ),
                    title: Text(
                      '*************',
                      style: TextStyle(
                        color: Colors.blueGrey[900],
                        fontSize: 15.0,
                      ),
                    ),
                    trailing: IconButton(
                        icon: Icon(Icons.edit, color: kDarkPurpleColor,),
                        splashColor: kPurpleColor,
                        onPressed:
                            null), 
                  ),
                ),
                SizedBox(
                  width: 220.0,
                  height: 20.0,
                  child: Divider(
                    color: kLightBlueColor,
                  ),
                ),
                Card(
                  child: SwitchListTile(
                    activeColor: kLightBlueColor,
                    value: _switchLight,
                    title: Text("Dark / Light Theme"),
                    onChanged: (value) {
                      setState(() {
                        _switchLight = value;
                      });
                    },
                  ),
                ),
                Card(
                  child: SwitchListTile(
                    activeColor: kLightBlueColor,
                    value: _pushNot,
                    title: Text("Push Notifications"),
                    onChanged: (value) {
                      setState(() {
                        _pushNot = value;
                      });
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text("Change Default Range Settings"),
                    subtitle: Text("Rating, Price, Distance"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RangeSettingsScreen()),
                      );
                    },
                  ),
                ),

                /*   SizedBox(
                  width: 250.0,
                  child: RaisedButton(
                    color: kPurpleColor,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(10.0),
                    splashColor: Colors.purpleAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0),
                        side: BorderSide()),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen()),
                      );
                    },
                    child: Text(
                      "Settings",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ), */
                SizedBox(
                  width: 250.0,
                  child: RaisedButton(
                    color: kLightBlueColor,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(10.0),
                    splashColor: Colors.purpleAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0),
                        side: BorderSide()),
                    onPressed: () {
                      Provider.of<UserModel>(context, listen: false).logout();
                      //Navigator.pushNamed(context, WelcomeScreen.id);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreen()),
                          (Route<dynamic> route) => false);
                    },
                    child: Text(
                      "Log out",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),

                /* RoundedButton(
              title: 'Update data',
              colour: kLightBlueColor,
              onPressed: () {
                Navigator.pushNamed(context, ProfileScreen.id);
              },
            ), */
              ],
            ),
          ),
        ),
      );
    });
  }
}
