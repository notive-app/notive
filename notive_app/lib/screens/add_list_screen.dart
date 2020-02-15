import 'package:flutter/material.dart';
import 'package:notive_app/models/notive_model.dart';
import 'package:provider/provider.dart';

class AddListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String newListName;
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
        decoration: BoxDecoration(
          //color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40.0),
            topLeft: Radius.circular(40.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Add a List',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25.0, color: Colors.lightBlueAccent),
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newValue) {
                newListName = newValue;
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
              color: Colors.lightBlueAccent,
              onPressed: () {
                Provider.of<NotiveModel>(context, listen: false)
                    .addList(newListName);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
