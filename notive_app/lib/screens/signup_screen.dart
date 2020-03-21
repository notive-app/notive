import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:notive_app/components/rounded_button.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:notive_app/screens/constants.dart';
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
                Text('This e-mail is already in use'),
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
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      //backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    padding: EdgeInsets.all(5),
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kTextFieldDecorationSign.copyWith(
                        hintText: 'Enter your email'),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: kTextFieldDecorationSign.copyWith(
                        hintText: 'Enter your password'),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      username = value;
                    },
                    decoration: kTextFieldDecorationSign.copyWith(
                        hintText: 'Enter your username'),
                  ),
                ),
              ),
              Flexible(
                child: RoundedButton(
                  title: 'Register',
                  colour: kPurpleColor,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });

                    var data = Map<String, dynamic>();
                    data["email"] = email;
                    data["password"] = password;
                    data["name"] = username;

                    var result =
                        await Provider.of<UserModel>(context, listen: false)
                            .signUp(data);

                    if (result) {
                      Navigator.pushNamed(context, DashboardScreen.id);
                    }
                    else{
                      errorAlert(context);
                    }

                    setState(() {
                      showSpinner = false;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
