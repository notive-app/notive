import 'package:flutter/material.dart';
import 'package:notive_app/components/dashboard.dart';
import 'package:notive_app/screens/constants.dart';
import 'add_item_screen.dart';
import 'add_list_screen.dart';
import 'package:notive_app/models/list_data.dart';
import 'package:provider/provider.dart';
import 'package:notive_app/components/custom_drawer.dart';
import 'package:notive_app/screens/settings_screen.dart';
import 'package:notive_app/screens/listview_screen.dart';
import 'package:notive_app/screens/dashboard_screen.dart';

class DashboardScreen extends StatefulWidget {
  static const String id = 'dashboard_screen';
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<String> createDialogBox(BuildContext context) async {
    TextEditingController customController = TextEditingController();
    // create a pop up screen upon clicking add button
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Please Enter the List Name:"),
            content: TextField(
              controller: customController,
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.blue,
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
    return Scaffold(
        //backgroundColor: Colors.white,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Text(
                  'MENU',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.map),
                title: Text('Map'),
                selected: true,
                onTap: () {
                  //why is this giving an error?
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.view_list),
                title: Text('Lists'),
                selected: true,
                onTap: () {
                  //why is this giving an error?
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListViewScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.playlist_add_check),
                title: Text('Archived Lists'),
                selected: true,
                onTap: () {
                  //why is this giving an error?
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Account'),
                selected: true,
                onTap: () {
                  //why is this giving an error?
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                selected: true,
                onTap: () {
                  //why is this giving an error?
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Log Out'),
                selected: true,
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Dashboard',
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          // color: Colors.orangeAccent,
          elevation: 5.0,
          onPressed: () async {
            //print(createDialogBox(context));
            createDialogBox(context).then((String listName) {
              print(listName);
              if (listName != null) {
                //Create reusable list card
                Provider.of<ListData>(context, listen: false).addList(listName);
                //Navigator.pop(context);
              }
            });
          },
          tooltip: 'Add List',
        ),
        body: Dashboard());
  }
}

//class AddListScreen {}

// Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[

//             new Container(
//               padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
//               //height: 500.0,
//               child: GridView.count(
//                 crossAxisCount: 2,
//                 padding: EdgeInsets.all(3.0),
//                 children: <Widget>[
//                   ReusableListCard(color: Colors.blue,),
//                   ReusableListCard(color: Colors.red,),
//                   ReusableListCard(color: Colors.yellow,),
//                   ReusableListCard(color: Colors.pink,),
//                   ReusableListCard(color: Colors.purple,),
//                   ReusableListCard(color: Colors.cyanAccent,),
//                   ReusableListCard(color: Colors.indigo,)
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
