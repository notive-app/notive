import 'package:flutter/material.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:notive_app/screens/login_screen.dart';
import 'package:notive_app/screens/signup_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:notive_app/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
//    with SingleTickerProviderStateMixin {
//  AnimationController controller;
//  Animation animation;
//  @override
//  void dispose() {
//    if (controller != null) {
//      controller.dispose();
//    }
//    super.dispose();
//  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/welcome1.png"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //backgroundColor: animation.value,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
//              Row(
//                children: <Widget>[
//                  Hero(
//                    tag: 'logo',
//                    child: Container(
//                      child: Image.asset('images/logo.png'),
//                      height: 60.0,
//                    ),
//                  ),
//                  SizedBox(
//                    width: 18.0,
//                  ),
//                  TypewriterAnimatedTextKit(
//                    text: ['NOTIVE.'],
//                    textStyle: TextStyle(
//                      fontSize: 50.0,
//                      fontWeight: FontWeight.w900,
//                    ),
//                  ),
//                ],
//              ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.50,
//                height: 48.0,
                  ),
                  RoundedButton(
                    title: 'Log In',
                    textColor: kDarkest,
                    colour: kMediumOrange,
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                  ),
                  RoundedButton(
                    title: 'Sign Up',
                    textColor: kDarkest,
                    colour: kDeepYellow,
                    onPressed: () {
                      Navigator.pushNamed(context, SignupScreen.id);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
