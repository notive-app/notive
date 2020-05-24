import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notive_app/components/app_themes.dart';
import 'package:notive_app/components/custom_bottom_nav.dart';
import 'package:notive_app/components/rounded_button.dart';
import 'package:notive_app/models/theme_manager.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:notive_app/screens/settings_screen.dart';
import 'package:notive_app/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:provider/provider.dart';
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
  bool _darkMode = false;
  bool _pushNot = true;

//  addBoolToSF() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    prefs.setBool('_darkMode', true);
//  }
//
//  _setDarkTheme() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    bool darkTheme = (prefs.getBool('darkTheme'));
//    print('DarkTheme: $darkTheme.');
//    await prefs.setBool('darkTheme', true);
//  }

  final lightTheme = AppTheme.values[2];
  final darkTheme = AppTheme.values[1];

  Future<String> createDialogBox(BuildContext context) async {
    TextEditingController customController = TextEditingController();
    // create a pop up screen upon clicking add button
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Enter your New Password:",
              style: TextStyle(fontSize: 16.0),
            ),
            content: TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(40),
              ],
              controller: customController,
            ),
            actions: <Widget>[
              Center(
                child: MaterialButton(
                  color: kLightBlueColor,
                  onPressed: () {
                    // close the dialog box when submit is clicked.
                    Navigator.of(context).pop(customController.text.toString());
                  },
                  elevation: 0.5,
                  child: Text("Submit"),
                ),
              )
            ],
          );
        });
  }

  //static const String id = 'profile_screen';
  @override
  Widget build(BuildContext context) {
    ThemeManager _themeManager = Provider.of<ThemeManager>(context);

    return Consumer<UserModel>(builder: (context, user, child) {
      userEmail = user.email;
      userName = user.name;
      if (user.chosenTheme == 'dark') {
        _darkMode = true;
      } else {
        _darkMode = false;
      }

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
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    //width: MediaQuery.of(context).size.width * 0.50,
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.15,
                      backgroundImage: AssetImage('images/profile.png'),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Center(
                        child: Text(
                          '$userName',
                          style: TextStyle(
                            fontFamily: 'SourceSansPro',
                            fontSize: 16.0,
                            color: kMediumOrange,
                            letterSpacing: 2.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.80,
                        height: 30.0,
                        child: Divider(
                          color: kLightBlueColor,
                        ),
                      ),
                      Card(
                        //padding: EdgeInsets.all(10.0),
                        color: kLightestBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        margin: EdgeInsets.only(
                            left: 10.0, right: 10.0, bottom: 10.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.email,
                            color: kDarkBlueColor,
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
                        color: kGrayColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.lock,
                            color: kDarkBlueColor,
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
                      Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: kGrayColor, width: 1),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        margin: EdgeInsets.only(
                            left: 10.0, right: 10.0, bottom: 10.0),
                        child: SwitchListTile(
                          activeColor: kLightBlueColor,
                          value: _darkMode,
                          title: Text("Enable Dark Theme"),
                          onChanged: (value) {
                            setState(() {
                              _darkMode = value;
                              if (_darkMode == true) {
                                //dark mode
                                user.chosenTheme = 'dark';
                                _themeManager.setTheme(darkTheme);
                              } else {
                                //light mode
                                user.chosenTheme = 'light';
                                _themeManager.setTheme(lightTheme);
                              }
                              print(value);
                            });
                          },
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: kGrayColor, width: 1),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        margin: EdgeInsets.only(
                            left: 10.0, right: 10.0, bottom: 10.0),
                        child: SwitchListTile(
                          activeColor: kLightBlueColor,
                          value: _pushNot,
                          title: Text("Push Notifications"),
                          onChanged: (value) {
                            setState(() {
                              _pushNot = value;
                              print(_pushNot);
                            });
                          },
                        ),
                      ),
                      /* Card(
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
                      ), */
                      RoundedButton(
                        title: 'Log Out',
                        colour: kLightBlueColor,
                        onPressed: () {
                          Provider.of<UserModel>(context, listen: false)
                              .logout();
                          //Navigator.pushNamed(context, WelcomeScreen.id);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => WelcomeScreen()),
                              (Route<dynamic> route) => false);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
