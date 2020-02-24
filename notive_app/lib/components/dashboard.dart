import 'package:flutter/material.dart';
import 'package:notive_app/components/reusable_list_card.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:notive_app/screens/listview_screen.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void openListView() {
      Navigator.pushNamed(context, ListViewScreen.id);
    }

    return Consumer<UserModel>(
      builder: (context, user, child) {
        return GridView.count(
          crossAxisCount: 2,
          children: List.generate(user.listsCount, (index) {
            return ReusableListCard(
              color: kLightBlueColor,
              listName: user.lists[index].name,
              onPress: () {
                user.curListIndex = index;
                openListView();
              },
              deleteCallback: () {
                user.deleteList(user.lists[index]);
              },
            );
          }),
        );

//         return ListView.builder(
//           shrinkWrap: true,
//           itemBuilder: (context, index) {
//             return Container(
//               child: SingleChildScrollView(
//                 child: Center(
//                   child: ReusableListCard(
//                     color: RandomColor().randomColor(),
//                     listName: listData.lists[index].listName,
//                     //TODO add Function onPress here
//                     onPress: openListView,
//                   ),
//                 ),
//               ),
//             );

// //              ReusableListCard(
// //              color: RandomColor().randomColor(),
// //              listName: listData.lists[index].listName,
// ////              checkCallback: (bool isMuted) {
// ////                listData.changeListName(listData.lists[index]);
// ////              },
// ////              deleteCallback: () {
// ////                listData.deleteList(listData.lists[index]);
// ////              },
// //            );
//           },
//           itemCount: listData.itemsCount,
//         );
      },
    );
  }
}
