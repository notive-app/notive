import 'package:flutter/material.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:provider/provider.dart';

import 'constants.dart';

class AddItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String newItemString;
    return Container(
      //color: Colors.black54,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
        decoration: BoxDecoration(
          //color: Colors.black,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40.0),
            topLeft: Radius.circular(40.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Add a New Item',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25.0, color: kPurpleColor),
            ),
            TextField(
              //TODO check the maximum length that the string can take here
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newValue) {
                newItemString = newValue;
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            FlatButton(
              child: Text(
                'Add the Item',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: kPurpleColor,
              onPressed: () {
                Provider.of<UserModel>(context, listen: false)
                    .addItem(newItemString);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
