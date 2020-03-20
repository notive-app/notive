import 'package:flutter/material.dart';
import 'package:notive_app/components/custom_bottom_nav.dart';
import 'package:notive_app/models/notification_model.dart';

import 'constants.dart';

class ArchivedListsScreen extends StatelessWidget {
  static const String id = 'archived_lists_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: 1,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Archived Lists',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Coming Soon...',
              style: TextStyle(
                //color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.w500,
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
                    MaterialPageRoute(
                        builder: (context) => NotiveNotification()),
                  );
                },
                child: Text(
                  "Notification Demo",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
