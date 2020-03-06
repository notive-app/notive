import 'package:flutter/material.dart';
import 'package:notive_app/components/reusable_list_card.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:notive_app/screens/listview_screen.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void openListView(String name) {
      Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListViewScreen(listName: name,)),
                );
    }

    return Consumer<UserModel>(
      builder: (context, user, child) {
        return GridView.count(
          crossAxisCount: 3,
          children: List.generate(user.listsCount, (index) {
            return ReusableListCard(
              color: kPurpleColor,
              listName: user.lists[index].name,
              onPress: () {
                user.curListIndex = index;
                openListView(user.lists[index].name);
              },
              deleteCallback: () {
                user.deleteList(user.lists[index]);
              },
            );
          }),
        );
      },
    );
  }
}
