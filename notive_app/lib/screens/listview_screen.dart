import 'package:flutter/material.dart';
import 'package:notive_app/components/item_list.dart';
import 'package:notive_app/screens/add_item_screen.dart';
import 'package:provider/provider.dart';
import 'package:notive_app/models/list_model.dart';
import 'constants.dart';

class ListViewScreen extends StatefulWidget {
  static const String id = 'listview_screen';

  @override
  _ListViewScreenState createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO add drawer here
      appBar: AppBar(
        title: Text('List Items'),
      ),
      //backgroundColor: Colors.lightBlueAccent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kOrangeColor,
        child: Icon(Icons.add),
        onPressed: () {
          // Add a new item
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: AddItemScreen(),
              ),
            ),
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 20.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
//                CircleAvatar(
//                  child: Icon(
//                    Icons.list,
//                    size: 30.0,
//                    color: kOrangeColor,
//                  ),
//                  //backgroundColor: Colors.white,
//                  radius: 30.0,
//                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  'List Name',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  '${Provider.of<ListModel>(context).itemsCount} Items',
                  style: TextStyle(
                    //color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              //height: 300.0,
              decoration: BoxDecoration(
                //color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
              ),
              child: ItemsList(),
            ),
          ),
        ],
      ),
    );
  }
}
