import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:notive_app/components/custom_bottom_nav.dart';
import 'package:notive_app/components/dashboard.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  static const String id = 'dashboard_screen';

  Future<String> createDialogBox(BuildContext context) async {
    TextEditingController customController = TextEditingController();
    // create a pop up screen upon clicking add button
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Please Enter the List Name:"),
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
                  Navigator.of(context).pop(customController.text
                      .toString()); //to return text back to homescreen
                },
                elevation: 0.5,
                child: Text("Submit"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, user, child) {
        return Scaffold(
            bottomNavigationBar: CustomBottomNav(
              selectedIndex: 0,
            ),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'Home',
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: kLightBlueColor,
              child: Icon(
                Icons.add,
                color: kOffWhiteColor,
              ),
              elevation: 5.0,
              onPressed: () async {
                createDialogBox(context).then((String listName) {
                  if (listName != null) {
                    //Create reusable list card
                    user.addList(listName);
                    //Navigator.pop(context);
                  }
                });
              },
            ),
            body: Dashboard());
      },
    );
  }
}
