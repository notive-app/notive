import 'package:flutter/material.dart';
import 'package:notive_app/components/custom_bottom_nav.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:notive_app/screens/settings_screen.dart';
import 'package:notive_app/screens/welcome_screen.dart';
import 'constants.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = 'profile_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: 3,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('User Profile'),
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
                radius: 50.0,
                backgroundImage: AssetImage('images/ben.jpg'),
              ),
              Text(
                'Hygerta Imeri',
                style: TextStyle(
                  fontFamily: 'Lobster',
                  fontSize: 20.0,
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
                  color: kPurpleColor,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 220.0,
                height: 20.0,
                child: Divider(
                  color: kPurpleColor,
                ),
              ),
              Card(
                //padding: EdgeInsets.all(10.0),
                color: Colors.grey[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 35.0),
                child: ListTile(
                  leading: Icon(
                    Icons.email,
                    color: kPurpleColor,
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
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 35.0),
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
                ),
              ),
              Card(
                //padding: EdgeInsets.all(10.0),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 35.0),
                child: ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    color: kPurpleColor,
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
              SizedBox(
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
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  },
                  child: Text(
                    "Settings",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              SizedBox(
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
                    Provider.of<UserModel>(context, listen: false).logout();
                    //Navigator.pushNamed(context, WelcomeScreen.id);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => WelcomeScreen()),
                        (Route<dynamic> route) => false);
                  },
                  child: Text(
                    "Logout",
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
  }
}
