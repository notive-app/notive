import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:notive_app/components/rounded_button.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:provider/provider.dart';

import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  String email;
  String password;

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
                Text('Incorrect Username or Password'),
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
    return Scaffold(
      backgroundColor: kDarkest,
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: kMediumOrange,
      ),
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
                  color: kLightestBlue,
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
                          image: AssetImage('images/login.png'),
                          height: MediaQuery.of(context).size.height * 0.30,
                        ),
                      ),
//                      SizedBox(
//                        height: 10.0,
//                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: kDarkest),
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: kTextFieldDecorationLog.copyWith(
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
                          decoration: kTextFieldDecorationLog.copyWith(
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
                      RoundedButton(
                        title: 'Log In',
                        colour: kMediumOrange,
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });

                          var data = Map<String, dynamic>();
                          email = email
                              .trim(); //to avoid spaces at the end of the email field
                          data["email"] = email;
                          data["password"] = password.trim();
                          var result = await Provider.of<UserModel>(context,
                                  listen: false)
                              .login(data);

                          if (result) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => DashboardScreen()),
                                (Route<dynamic> route) => false);
                          } else {
                            //show error message
                            errorAlert(context);
                          }

                          setState(() {
                            showSpinner = false;
                          });
                        },
                      ),
                    ],
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
