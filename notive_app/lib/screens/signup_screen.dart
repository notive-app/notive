import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:notive_app/components/rounded_button.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:notive_app/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import 'dashboard_screen.dart';

class SignupScreen extends StatefulWidget {
  static const String id = 'signup_screen';
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  //final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  String username;
  String surname;
  Future<void> errorAlert(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'This e-mail is already in use \nor Invalid e-mail adress'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Sign Up',
            //style: TextStyle(color: kOffWhiteColor),
          ),
          backgroundColor: kDeepYellow,
        ),
        backgroundColor: kDarkest,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 10.0,
              bottom: 10.0,
            ),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: kLightestBlue.withOpacity(0.8),
                  border: Border.all(
                    color: Color(0xff462f3f),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 18.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          child: Image(
                            image: AssetImage('images/sign.png'),
                            height: MediaQuery.of(context).size.height * 0.30,
                          ),
                        ),
//                        SizedBox(
//                          height: 10.0,
//                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: kDarkest),
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              email = value;
                            },
                            decoration: kTextFieldDecorationSign.copyWith(
                              hintText: 'Enter your email',
                              hintStyle: TextStyle(
                                color: Colors.black26,
                              ),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.black26,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: TextField(
                            style: TextStyle(color: kDarkest),
                            obscureText: true,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: kTextFieldDecorationSign.copyWith(
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(
                                color: Colors.black26,
                              ),
                              prefixIcon: Icon(
                                Icons.enhanced_encryption,
                                color: Colors.black26,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: TextField(
                            style: TextStyle(color: kDarkest),
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              username = value;
                            },
                            decoration: kTextFieldDecorationSign.copyWith(
                              hintText: 'Enter your username',
                              hintStyle: TextStyle(
                                color: Colors.black26,
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.black26,
                              ),
                            ),
                          ),
                        ),
                        RoundedButton(
                          title: 'Register',
                          colour: kDeepYellow,
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });

                            var data = Map<String, dynamic>();
                            data["email"] = email.trim();
                            data["password"] = password.trim();
                            data["name"] = username;

                            var result = await Provider.of<UserModel>(context,
                                    listen: false)
                                .signUp(data);

                            if (result) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => DashboardScreen()),
                                  (Route<dynamic> route) => false);
                            } else {
                              errorAlert(context);
                            }

                            setState(() {
                              showSpinner = false;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
