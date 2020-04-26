import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notive_app/components/custom_bottom_nav.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:notive_app/screens/settings_screen.dart';
import 'package:notive_app/screens/welcome_screen.dart';
import 'constants.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:provider/provider.dart';
import 'package:notive_app/screens/theme.dart';

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
  String userName;
  bool _darkMode = false; //
  bool _pushNot = true;

  Future<String> createDialogBox(BuildContext context) async {
    TextEditingController customController = TextEditingController();
    // create a pop up screen upon clicking add button
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Please Enter New Password:"),
            content: TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(40),
              ],
              controller: customController,
            ),
            actions: <Widget>[
              MaterialButton(
                color: kLightBlueColor,
                onPressed: () {
                  // close the dialog box when submit is clicked.
                  Navigator.of(context).pop(customController.text.toString());
                },
                elevation: 0.5,
                child: Text("Submit"),
              )
            ],
          );
        });
  }

  //static const String id = 'profile_screen';
  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

//    bool switchTheme(bool darkMode) {
////      bool switchTheme = darkMode;
////      if (!switchTheme) {
////        _themeChanger.setTheme(ThemeData.light());
//////        return _darkMode = !darkMode;
////      } else {
////        _themeChanger.setTheme(ThemeData.dark());
//////        return _darkMode = !darkMode;
////      }
//      return !darkMode;
//    }

    return Consumer<UserModel>(builder: (context, user, child) {
      userEmail = user.email;
      userName = user.name;
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
                  '$userName',
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
                  margin:
                      EdgeInsets.only(left: 70.0, right: 70.0, bottom: 10.0),
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
                  ),
                ),
                Card(
                  //padding: EdgeInsets.all(10.0),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin: EdgeInsets.only(left: 70.0, right: 70.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.lock,
                      color: kPurpleColor,
                      size: 25.0,
                    ),
                    title: Text(
                      'Change Password',
                      style: TextStyle(
                        color: Colors.blueGrey[900],
                        fontSize: 15.0,
                      ),
                    ),
                    trailing: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: kDarkPurpleColor,
                        ),
                        splashColor: kPurpleColor,
                        onPressed: () {
                          createDialogBox(context).then((String newPass) {
                            if (newPass != null) {
                              user.changePassword(user, newPass);
                              //Navigator.pop(context);
                            }
                          });
                        }),
                  ),
                ),
                SizedBox(
                  width: 220.0,
                  height: 20.0,
                  child: Divider(
                    color: kLightBlueColor,
                  ),
                ),
//                Card(
//                  child: SwitchListTile(
//                    activeColor: kLightBlueColor,
//                    value: _darkMode,
//                    title: Text("Go Dark"),
//                    onChanged: (value) {
//                      setState(() {
//                        _darkMode = switchTheme(value);
//                      });
//                    },
//                  ),
//                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Select Theme',
                      style: TextStyle(
                        fontFamily: 'SourceSansPro',
                        fontSize: 16.0,
                        color: kLightBlueColor,
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Card(
                      child: FlatButton(
                          child: Text('Light Theme'),
                          onPressed: () =>
                              _themeChanger.setTheme(ThemeData.light())),
                    ),
                    Card(
                      child: FlatButton(
                        child: Text('Dark Theme'),
                        onPressed: () =>
                            _themeChanger.setTheme(ThemeData.dark()),
                      ),
                    ),
                  ],
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
