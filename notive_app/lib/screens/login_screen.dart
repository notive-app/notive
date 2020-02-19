import 'package:flutter/material.dart';
import 'package:notive_app/components/rounded_button.dart';
import 'package:notive_app/screens/constants.dart';
import 'dashboard_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart';
import 'package:notive_app/util/request.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LogIn'),
      ),
      //backgroundColor: Colors.black,
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
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecorationLog.copyWith(
                    hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecorationLog.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Log In',
                colour: kLightBlueColor,
                onPressed: () async {
                  //print(email);
                  // String data = "{'password': '" + password + "', 'email': '" + email + "'}";
                  Map<String, dynamic> data = {
                    'password': password,
                    'email': email
                  };

                  int userID;
                  String user_email, name, surname;
                  List<dynamic> response = await loginUser(data);
                  int status = response[0];
                  String msg = response[1];
                  if (status == 200) {
                    Map<String, dynamic> data = response[2];
                    user_email = data['email'];
                    name = data['name'];
                    surname = data['surname'];
                  } else {
                    // Error message with msg variable message.
                  }

                  setState(() {
                    showSpinner = true;
                    print(response);
                  });
//                  try {
//                    final user = await _auth.signInWithEmailAndPassword(
//                        email: email, password: password);
//                    if (user != null) {
//
//                    }
//
//                    setState(() {
//                      showSpinner = false;
//                    });
//                  } catch (e) {
//                    print(e);
//                  }
                },
              ),
              Text(
                'Forgot password?',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
