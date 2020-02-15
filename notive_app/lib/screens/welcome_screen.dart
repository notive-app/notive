import 'package:flutter/material.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:notive_app/screens/listview_screen.dart';
import 'package:notive_app/screens/login_screen.dart';
import 'package:notive_app/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:notive_app/screens/signup_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:notive_app/components/rounded_button.dart';
import 'dashboard_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
//
//  @override
//  void initState() {
//    super.initState();
//
//    controller =
//        AnimationController(duration: Duration(seconds: 1), vsync: this);
//    animation = ColorTween(begin: Colors.blueGrey, end: Colors.black45)
//        .animate(controller);
//    controller.forward();
//    controller.addListener(() {
//      setState(() {});
//    });
//  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                SizedBox(
                  width: 18.0,
                ),
                TypewriterAnimatedTextKit(
                  text: ['NOTIVE.'],
                  textStyle: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: 'Log In',
              colour: kLightBlueColor,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              title: 'Sign Up',
              colour: kOrangeColor,
              onPressed: () {
                Navigator.pushNamed(context, SignupScreen.id);
              },
            ),
            RoundedButton(
              title: 'TEST',
              colour: Colors.red,
              onPressed: () {
                Navigator.pushNamed(context, DashboardScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
